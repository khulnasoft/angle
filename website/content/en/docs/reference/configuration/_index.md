---
title: Configuring Angle
short: Configuration
weight: 2
aliases: ["/docs/configuration", "/docs/setup/configuration"]
---

Angle is configured using a configuration file. This section contains a
comprehensive reference of all Angle configuration options.

## Example

The following is an example of a popular Angle configuration that ingests logs
from a file and routes them to both Elasticsearch and AWS S3. Your configuration
will differ based on your needs.

{{< tabs default="angle.yaml" >}}
{{< tab title="angle.yaml" >}}

```yaml
# Set global options
data_dir: "/var/lib/angle"

# Angle's API (disabled by default)
# Enable and try it out with the `angle top` command
api:
  enabled: false
# address = "127.0.0.1:8686"

# Ingest data by tailing one or more files
sources:
  apache_logs:
    type: "file"
    include:
      - "/var/log/apache2/*.log" # supports globbing
    ignore_older: 86400          # 1 day

# Structure and parse via Angle's Remap Language
transforms:
  apache_parser:
    inputs:
      - "apache_logs"
    type: "remap"
    source: ". = parse_apache_log(.message)"

  # Sample the data to save on cost
  apache_sampler:
    inputs:
      - "apache_parser"
    type: "sample"
    rate: 2 # only keep 50% (1/`rate`)

# Send structured data to a short-term storage
sinks:
  es_cluster:
    inputs:
      - "apache_sampler"       # only take sampled data
    type: "elasticsearch"
    endpoints:
      - "http://79.12.221.222:9200"
    bulk:
      index: "angle-%Y-%m-%d" # daily indices

  # Send structured data to a cost-effective long-term storage
  s3_archives:
    inputs:
      - "apache_parser" # don't sample for S3
    type: "aws_s3"
    region: "us-east-1"
    bucket: "my-log-archives"
    key_prefix: "date=%Y-%m-%d"   # daily partitions, hive friendly format
    compression: "gzip"           # compress final objects
    framing:
      method: "newline_delimited" # new line delimited...
    encoding:
      codec: "json"               # ...JSON
    batch:
      max_bytes: 10000000         # 10mb uncompressed
```

{{< /tab >}}
{{< tab title="angle.toml" >}}

```toml
# Set global options
data_dir = "/var/lib/angle"

# Angle's API (disabled by default)
# Enable and try it out with the `angle top` command
[api]
enabled = false
# address = "127.0.0.1:8686"

# Ingest data by tailing one or more files
[sources.apache_logs]
type         = "file"
include      = ["/var/log/apache2/*.log"]    # supports globbing
ignore_older = 86400                         # 1 day

# Structure and parse via Angle's Remap Language
[transforms.apache_parser]
inputs = ["apache_logs"]
type   = "remap"
source = '''
. = parse_apache_log(.message)
'''

# Sample the data to save on cost
[transforms.apache_sampler]
inputs = ["apache_parser"]
type   = "sample"
rate   = 2                    # only keep 50% (1/`rate`)

# Send structured data to a short-term storage
[sinks.es_cluster]
inputs     = ["apache_sampler"]             # only take sampled data
type       = "elasticsearch"
endpoints  = ["http://79.12.221.222:9200"]  # local or external host
bulk.index = "angle-%Y-%m-%d"              # daily indices

# Send structured data to a cost-effective long-term storage
[sinks.s3_archives]
inputs          = ["apache_parser"]    # don't sample for S3
type            = "aws_s3"
region          = "us-east-1"
bucket          = "my-log-archives"
key_prefix      = "date=%Y-%m-%d"      # daily partitions, hive friendly format
compression     = "gzip"               # compress final objects
framing.method  = "newline_delimited"  # new line delimited...
encoding.codec  = "json"               # ...JSON
batch.max_bytes = 10000000             # 10mb uncompressed
```

{{< /tab >}}
{{< tab title="angle.json" >}}

```json
{
  "data_dir": "/var/lib/angle",
  "sources": {
    "apache_logs": {
      "type": "file",
      "include": [
        "/var/log/apache2/*.log"
      ],
      "ignore_older": 86400
    }
  },
  "transforms": {
    "apache_parser": {
      "inputs": [
        "apache_logs"
      ],
      "type": "remap",
      "source": ". = parse_apache_log(.message)"
    },
    "apache_sampler": {
      "inputs": [
        "apache_parser"
      ],
      "type": "sample",
      "rate": 50
    }
  },
  "sinks": {
    "es_cluster": {
      "inputs": [
        "apache_sampler"
      ],
      "type": "elasticsearch",
      "endpoints": ["http://79.12.221.222:9200"],
      "bulk": {
        "index": "angle-%Y-%m-%d"
      }
    },
    "s3_archives": {
      "inputs": [
        "apache_parser"
      ],
      "type": "aws_s3",
      "region": "us-east-1",
      "bucket": "my-log-archives",
      "key_prefix": "date=%Y-%m-%d",
      "compression": "gzip",
      "framing": {
        "method": "newline_delimited"
      },
      "encoding": {
        "codec": "json"
      },
      "batch": {
        "max_bytes": 10000000
      }
    }
  }
}
```

{{< /tab >}}
{{< /tabs >}}

To use this configuration file, specify it with the `--config` flag when
starting Angle:

{{< tabs default="YAML" >}}
{{< tab title="YAML" >}}

```shell
angle --config /etc/angle/angle.yaml
```

{{< /tab >}}
{{< tab title="TOML" >}}

```shell
angle --config /etc/angle/angle.toml
```

{{< /tab >}}
{{< tab title="JSON" >}}

```shell
angle --config /etc/angle/angle.json
```

{{< /tab >}}
{{< /tabs >}}

## Reference

### Components

{{< jump "/docs/reference/configuration/sources" >}} {{< jump
"/docs/reference/configuration/transforms" >}} {{< jump
"/docs/reference/configuration/sinks" >}}

### Advanced

{{< jump "/docs/reference/configuration/global-options" >}} {{< jump
"/docs/reference/configuration/template-syntax" >}}

## How it works

### Environment variables

Angle interpolates environment variables within your configuration file with
the following syntax:

```yaml
transforms:
  add_host:
    type: "remap"
    source: |
      # Basic usage. "$HOSTNAME" also works.
      .host = "${HOSTNAME}" # or "$HOSTNAME"

      # Setting a default value when not present.
      .environment = "${ENV:-development}"

      # Requiring an environment variable to be present.
      .tenant = "${TENANT:?tenant must be supplied}"
```

#### Default values

Default values can be supplied using `:-` or `-` syntax:

```yaml
option: "${ENV_VAR:-default}" # default value if variable is unset or empty
option: "${ENV_VAR-default}" # default value only if variable is unset
```

#### Required variables

Environment variables that are required can be specified using `:?` or `?` syntax:

```yaml
option: "${ENV_VAR:?err}" # Angle exits with 'err' message if variable is unset or empty
option: "${ENV_VAR?err}" # Angle exits with 'err' message only if variable is unset
```

#### Escaping

You can escape environment variables by prefacing them with a `$` character. For
example `$${HOSTNAME}` or `$$HOSTNAME` is treated literally in the above
environment variable example.

### Formats

Angle supports [YAML], [TOML], and [JSON] to ensure that Angle fits into your
workflow. A side benefit of supporting YAML and JSON is that they enable you to use
data templating languages such as [ytt], [Jsonnet] and [Cue].

#### Location

The location of your Angle configuration file depends on your installation
method. For most Linux-based systems, the file can be found at
`/etc/angle/angle.yaml`.

### Multiple files

You can pass multiple configuration files when starting Angle:

```shell
angle --config angle1.yaml --config angle2.yaml
```

Or using a [globbing syntax][glob]:

```shell
angle --config /etc/angle/*.yaml
```

#### Automatic namespacing

You can also split your configuration by grouping the components by their type, one directory per component type, where the file name is used as the component id. For example:

{{< tabs default="angle.yaml" >}}
{{< tab title="angle.yaml" >}}

```yaml
# Set global options
data_dir: "/var/lib/angle"

# Angle's API (disabled by default)
# Enable and try it out with the `angle top` command
api:
  enabled: false
  # address: "127.0.0.1:8686"
```

{{< /tab >}}
{{< tab title="sources/apache_logs.yaml" >}}

```yaml
# Ingest data by tailing one or more files
type: "file"
include: ["/var/log/apache2/*.log"]    # supports globbing
ignore_older: 86400                    # 1 day
```

{{< /tab >}}
{{< tab title="transforms/apache_parser.yaml" >}}

```yaml
# Structure and parse via Angle Remap Language
inputs:
  - "apache_logs"
type: "remap"
source: |
  . = parse_apache_log(.message)
```

{{< /tab >}}
{{< tab title="transforms/apache_sampler.yaml" >}}

```yaml
# Sample the data to save on cost
inputs:
  - "apache_parser"
type: "sample"
rate: 2 # only keep 50% (1/`rate`)
```

{{< /tab >}}
{{< tab title="sinks/es_cluster.yaml" >}}

```yaml
# Send structured data to a short-term storage
inputs:
  - "apache_sampler"             # only take sampled data
type: "elasticsearch"
endpoints:
  - "http://79.12.221.222:9200"  # local or external host
bulk:
  index: "angle-%Y-%m-%d"      # daily indices
```

{{< /tab >}}
{{< tab title="sinks/s3_archives.yaml" >}}

```yaml
# Send structured data to a cost-effective long-term storage
inputs:
  - "apache_parser"           # don't sample for S3
type: "aws_s3"
region: "us-east-1"
bucket: "my-log-archives"
key_prefix: "date=%Y-%m-%d"   # daily partitions, hive-friendly format
compression: "gzip"           # compress final objects
framing:
  method: "newline_delimited" # new line delimited...
encoding:
  codec: "json"               # ...JSON
batch:
  max_bytes: 10000000         # 10mb uncompressed
```

{{< /tab >}}
{{< /tabs >}}

Angle then needs to be started using the `--config-dir` argument to specify the root configuration folder.

```bash
angle --config-dir /etc/angle
```

#### Wildcards in component IDs

Angle supports wildcards (`*`) in component IDs when building your topology.
For example:

```yaml
sources:
  app1_logs:
    type: "file"
    includes: ["/var/log/app1.log"]

  app2_logs:
    type: "file"
    includes: ["/var/log/app.log"]

  system_logs:
    type: "file"
    includes: ["/var/log/system.log"]

sinks:
  app_logs:
    type: "datadog_logs"
    inputs: ["app*"]

  archive:
    type: "aws_s3"
    inputs: ["app*", "system_logs"]
```

## Sections

{{< sections >}}

## Pages

{{< pages >}}

[cue]: https://cuelang.org
[glob]: https://en.wikipedia.org/wiki/Glob_(programming)
[json]: https://json.org
[jsonnet]: https://jsonnet.org
[toml]: https://github.com/toml-lang/toml
[yaml]: https://yaml.org
[ytt]: https://carvel.dev/ytt/
