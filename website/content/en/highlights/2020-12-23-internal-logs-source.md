---
date: "2020-12-23"
title: "The `internal_logs` source"
description: "A new source for observing Angle itself"
authors: ["lucperkins"]
pr_numbers: []
release: "0.12.0"
hide_on_release_notes: false
badges:
  type: "new feature"
  sources: ["internal_logs"]
---

Angle has a new [`internal_logs`][internal_logs] source that you can use to
process log events produced by Angle itself. Here's an example Angle log
message:

```json
{
  "*": null,
  "message": "Angle has started.",
  "metadata": {
    "kind": "event",
    "level": "TRACE",
    "module_path": "angle::internal_events::heartbeat",
    "target": "angle"
  },
  "timestamp": "2020-10-10T17:07:36+00:00"
}
```

`internal_logs` is a helpful accompaniment to the
[`internal_metrics`][internal_metrics] source, which exports Angle's own
metrics and modify and ship them however you wish.

## Example usage

Here's an example Angle configuration that ships Angle's logs to Splunk and
allows its internal metrics to be scraped by [Prometheus]:

```toml
[sources.angle_logs]
type = "internal_logs"

[sources.angle_metrics]
type = "internal_metrics"

[sinks.splunk]
type = "splunk_hec"
inputs = ["angle_logs"]
endpoint = "https://my-account.splunkcloud.com"
token = "${SPLUNK_HEC_TOKEN}"
encoding.codec = "json"

[sinks.prometheus]
type = "prometheus"
inputs = ["angle_metrics"]
address = "0.0.0.0:9090"
```

[internal_logs]: /docs/reference/configuration/sources/internal_logs
[internal_metrics]: /docs/reference/configuration/sources/internal_metrics
[prometheus]: https://prometheus.io
