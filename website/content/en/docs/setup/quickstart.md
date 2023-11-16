---
title: Angle quickstart
description: Get up and running
short: Quickstart
weight: 1
aliases: ["/docs/setup/getting-started", "/docs/setup/guides/getting-started"]
---

Welcome to Angle! Angle is a high-performance observability data pipeline that enables you to collect, transform, and route all of your logs and metrics.

In this quickstart guide, we walk you through using Angle for the first time. We'll install Angle and create our first observability data pipeline so that you can begin to see what Angle can do.

## Install Angle

We can install Angle using an installation script or Docker:

{{< tabs default="Script" >}}
{{< tab title="Script" >}}

```shell
curl --proto '=https' --tlsv1.2 -sSfL https://sh.angle.khulnasoft.com | bash
```

{{< /tab >}}
{{< tab title="Docker" >}}

```shell
docker pull timberio/angle:{{< version >}}-debian
```

In addition to `debian`, `distroless-libc`, `distroless-static`, and `alpine` distributions are also available.

If you install Angle using Docker, we recommend using an alias to run the commands throughout this tutorial:

```shell
alias angle='docker run -i -v $(pwd)/:/etc/angle/ --rm timberio/angle:{{< version >}}-debian'
```

{{< /tab >}}
{{< /tabs >}}

Other [installation methods][install] are available.

Once Angle is installed, let's check to make sure that it's working correctly:

```shell
angle --version
```

## Configure Angle

Angle topologies are defined using a [configuration file][config] that tells it which [components] to run and how they should interact. Angle topologies are made up of three types of components:

* [Sources] collect or receive data from observability data sources into Angle
* [Transforms] manipulate or change that observability data as it passes through your topology
* [Sinks] send data onwards from Angle to external services or destinations

Let's create a configuration file called `angle.yaml`:

```yaml filename="angle.yaml"
sources:
  in:
    type: "stdin"

sinks:
  out:
    inputs:
      - "in"
    type: "console"
    encoding:
      codec: "text"
```

Each component has a unique id and is prefixed with the type of the component, for example `sources` for a source. Our first component, `sources.in`, uses the [`stdin` source][stdin], which tells Angle to receive data over stdin and is given the ID `in`.

Our second component, `sinks.out`, uses [`console` sink][console], which tells Angle to print the data to stdout, while the `encoding.codec` option tells Angle to print data as plain text (unencoded).

The `inputs` option of the `sinks.out` component tells Angle where this sink's events are coming from. In our case, events are received from our other component, the source with ID `in`.

## Hello world!

That's it for our first config. Now let's pipe an event through it:

```shell
echo 'Hello world!' | angle
```

The `echo` statement sends a single log to Angle via stdin. The `angle...` command starts Angle with our previously created config file.

The event we've just sent is received by our `sources.in` component, then sent onto the `sinks.out` component, which in turn echoes it back to the console:

```shell
... some logs ...
Hello World!
```

{{< info title="JSON encoding" >}}
If you want to see something cool, try setting `encoding.codec = "json"` in the sink config.
{{< /info >}}

## Hello Syslog!

Echoing events into the console isn't terribly exciting. Let's see what we can do with some real observability data by collecting and processing Syslog events. To do that, we'll add two new components to our configuration file. Here's our updated `angle.yaml` configuration file:

```yaml filename="angle.yaml"
sources:
  generate_syslog:
    type:   "demo_logs"
    format: "syslog"
    count:  100

transforms:
  remap_syslog:
    inputs:
      - "generate_syslog"
    type:   "remap"
    source: |
            structured = parse_syslog!(.message)
            . = merge(., structured)

sinks:
  emit_syslog:
    inputs:
      - "remap_syslog"
    type: "console"
    encoding:
      codec: "json"
```

The first component uses the [`demo_logs` source][demo_logs], which creates sample log data that enables you to simulate different types of events in various formats.

{{< warning >}}
Wait, I thought you said "real" observability data? We choose generated data here because it's hard for us to know which platform you're trying Angle on. That means it's also hard to document a single way for everyone to get data into Angle.
{{< /warning >}}

The second component is a transform called [`remap`][remap]. The `remap` transform is at the heart of what makes Angle so powerful for processing observability data. The transform exposes a simple language called [Angle Remap Language][vrl] that allows you to parse, manipulate, and decorate your event data as it passes through Angle. Using `remap`, you can turn static events into informational
data that can help you ask and answer questions about your environment's state.

You can see we've added the `sources.generated_syslog` component. The `format` option tells the `demo_logs` source which type of logs to emit, here `syslog`, and the `count` option tells the `demo_logs` source how many lines to emit, here 100.

In our second component, `transforms.remap_syslog`, we've specified an `inputs` option of `generate_syslog`, which means it will receive events from our `generate_syslog` source. We've also specified the type of transform: `remap`.

Inside the `source` option of the `remap_syslog` component is where we start to see Angle's power. The `source` contains the list of remapping transformations to apply to each event Angle receives. We're only performing one operation: [`parse_syslog`][parse_syslog]. We're passing this function a single field called `message`, which contains the Syslog event we're generating. This all-in-one function takes a Syslog-formatted message, parses its contents, and emits it as a structured event. Wait, I can hear you saying? What have you done with my many lines of Syslog parsing regular expressions? Remap removes the need for this and allows you to focus on the event's value, not on how to extract that value.

{{< success >}}
We support parsing a variety of logging formats. Of course, if you have an event format that we don't support, you can also specify your own custom regular expression using `remap` too! The `!` after the `parse_syslog` function tells Angle to emit an error if the message fails to parse, meaning you'll know if some non-standard Syslog is received, and you can adjust your remapping to accommodate it!
{{< /success >}}

Lastly, we've updated the ID of our sink component to `emit_syslog`, updated the `inputs` option to process events generated by the `remap_syslog` transform, and specified that we want to emit events in JSON-format.

Let's re-run Angle. This time we don't need to echo any data to it; just run in on the command line. It'll process
100 lines of generated Syslog data, emit the processed data as JSON, and exit:

```shell
angle
```

Now you should have a series of JSON-formatted events, something like this:

```json
{"appname":"benefritz","facility":"authpriv","hostname":"some.de","message":"We're gonna need a bigger boat","msgid":"ID191","procid":9473,"severity":"crit","timestamp":"2021-01-20T19:38:55.329Z"}
{"appname":"meln1ks","facility":"local1","hostname":"for.com","message":"Take a breath, let it go, walk away","msgid":"ID451","procid":484,"severity":"debug","timestamp":"2021-01-20T19:38:55.329Z"}
{"appname":"shaneIxD","facility":"uucp","hostname":"random.com","message":"A bug was encountered but not in Angle, which doesn't have bugs","msgid":"ID428","procid":3093,"severity":"alert","timestamp":"2021-01-20T19:38:55.329Z"}
```

We can see that Angle has parsed the Syslog message and created a structured event containing all of the Syslog fields. All with one line of Angle's remap language. This example is just the beginning of Angle's capabilities. You can receive logs and events from dozens of sources. You can use Angle and remap to change data, add fields to decorate data, convert logs into metrics, drop fields, and dozens of other tasks you use daily to process your observability data. You can then route and output your events to dozens of destinations.

## What's next?

We're just scratching the surface in this post. To get your hands dirty with Angle check out:

* All of Angle's [sources][sources], [transforms][transforms], and [sinks][sinks].
* The [Angle Remap Language][vrl], the heart of data processing in Angle.
* Finally, [deploying Angle][deployment] to launch Angle in your production environment.

[components]: /components
[console]: /docs/reference/configuration/sinks/console
[config]: /docs/reference/configuration
[deployment]: /docs/setup/deployment
[demo_logs]: /docs/reference/configuration/sources/demo_logs
[install]: /docs/setup/installation
[parse_syslog]: /docs/reference/vrl/functions/#parse_syslog
[remap]: /docs/reference/configuration/transforms/remap
[sinks]: /docs/reference/configuration/sinks
[sources]: /docs/reference/configuration/sources
[stdin]: /docs/reference/configuration/sources/stdin
[transforms]: /docs/reference/configuration/transforms
[vrl]: /docs/reference/vrl
