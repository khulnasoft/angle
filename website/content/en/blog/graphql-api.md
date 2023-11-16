---
title: "The new GraphQL API for Angle"
description: "Extending observability into your own apps and infrastructure."
date: "2020-12-08"
authors: ["leebenson"]
badges:
  type: announcement
  domains: ["graphql api", "observability"]
tags: ["graphql", "api", "metrics"]
---

Although Angle is an observability tool, it's nonetheless important to be able
to observe Angle itself, especially in production environments where it serves
as critical infrastructure. That's why we're excited to announce the new [Angle
GraphQL API](https://angle.khulnasoft.com/docs/reference/api/), available in
[v0.11.0](https://angle.khulnasoft.com/releases/0.11.0/).

The API enables ad-hoc querying of:

- Your Angle topology, including
  [`sources`](https://angle.khulnasoft.com/docs/reference/sources/),
  [`transforms`](https://angle.khulnasoft.com/docs/reference/transforms/) and
  [`sinks`](https://angle.khulnasoft.com/docs/reference/sinks/).
- Uptime and health information.
- Event processing, byte processing, and error metrics, both per component and
  in aggregate across the Angle instance.
- Changes to your pipeline configuration, in real time.

This is just the beginning. In the near future, the API will enable you to both
observe _and_ control Angle remotely, programmatically, and on demand. Stay
tuned!

## Take it for a spin in the Angle playground

Start up Angle locally with the following config:

```toml
[api]
enabled = true

[sources.demo]
type = "demo_logs"
format = "json"
interval = 1.0

[sinks.console]
type = "console"
inputs = ["demo"]
encoding.codec = "text"
```

You can then access
[http://localhost:8686/playground](http://localhost:8686/playground) to get
a live GraphQL playground to experiment with.

Here are a few queries you can try:

### Health and uptime

See how long it's been since Angle last restarted, with streaming uptime that
updates every second:

```graphql
subscription {
  uptime {
    seconds
    timestamp
  }
}
```

### Get configured topology + metrics

Get sources, transforms, and sinks configured by
[`angle.toml`](https://angle.khulnasoft.com/docs/setup/configuration/), along with
metrics such as the number of events or bytes processed by the component:

```graphql
query {
  # Get the first 5 sources.
  sources(first: 5) {
    # See https://relay.dev/graphql/connections.htm
    edges {
      node {
        componentId
        metrics {
          # Total events that the source has received.
          receivedEventsTotal {
            receivedEventsTotal
          }
        }
      }
    }
  }

  # Get transforms (defaults to the first 10 when a limit isn't specified)
  transforms {
    edges {
      node {
        componentId
        metrics {
          # Total events that the transform has sent out.
          sentEventsTotal {
            sentEventsTotal
          }
        }
      }
    }
  }

  # Get the last 3 sinks.
  sinks(last: 3) {
    edges {
      node {
        componentId
        metrics {
          # Total bytes sent by this sink.
          sentBytesTotal {
            sentBytesTotal
          }
        }
      }
    }
  }
}
```

### Hardware metrics

Get insight into the hardware Angle's running on, from memory and CPU usage to
network activity and more.

```graphql
query {
  hostMetrics {
    memory {
      totalBytes
      freeBytes
      usedBytes
      activeBytes
      availableBytes
      inactiveBytes
      buffersBytes
      cachedBytes
      sharedBytes
      wiredBytes
    }
    network {
      receiveBytesTotal
      receiveErrsTotal
      receivePacketsTotal
      transmitBytesTotal
      transmitErrsTotal
      transmitPacketsDropTotal
      transmitPacketsTotal
    }
    filesystem {
      freeBytes
      totalBytes
      usedBytes
    }
    cpu {
      cpuSecondsTotal
    }
    swap {
      freeBytes
      totalBytes
      usedBytes
      swappedInBytesTotal
      swappedOutBytesTotal
    }
    loadAverage {
      load1
      load5
      load15
    }
    disk {
      readBytesTotal
      readsCompletedTotal
      writtenBytesTotal
      writesCompletedTotal
    }
  }
}
```

## Enabling the Angle GraphQL API

The API is an opt-in feature that spawns an HTTP server to accept queries.

To enable, open your `angle.toml`, and add the following:

```toml
[api]
  enabled = true
  address = "127.0.0.1:8686" # optional. Change IP/port if required
```

After restarting Angle, you can access an API playground at
[http://localhost:8686/playground](http://localhost:8686/playground).

## Why we chose GraphQL

The Angle API uses [GraphQL](https://graphql.org), a simple, type-safe,
flexible query language.

We chose GraphQL over REST or gRPC for a few reasons:

- It's type safe. Clients can introspect schema and discern whether a query is
  valid before it's executed.
- Relational data (like Angle topology) is natural to model and query for.
- Data can be streamed via subscriptions over WebSockets, making it ideal for
  high-frequency metrics and a pub/sub pattern for observing topology changes.
- Data is returned in pure JSON, making it simple, readable, and easy to parse.
- There's [great language/library
  tooling](https://github.com/chentsulin/awesome-graphql), making it trivial to
  interop with existing applications.
- Compile-time type safety in Rust, via
  [async-graphql](https://github.com/async-graphql/async-graphql) (server) and
  [graphql-client](https://github.com/graphql-rust/graphql-client).
- Universal browser support, making it an ideal protocol for web usage (or
  apps!).

## Our first API client: `top`

To help you visualize your Angle instance in action,
[v0.11.0](https://angle.khulnasoft.com/releases/0.11.0/) also brings you `angle top`, our
new terminal dashboard CLI tool powered by the Angle GraphQL API.

To enable it, run:

```bash
angle top # pass --url <http://path/to/graphql> for remote observability
```

On Linux, Windows and macOS, you'll get an interface like this:

![Angle top](/img/blog/angle-top.png)

This will display your configured components and metrics, updating every second
(pass a millisecond `--interval` to adjust). If you run Angle in [watch
mode](https://angle.khulnasoft.com/docs/reference/cli/#angle_watch_config), it'll even
pick up topology changes automatically.

I'll be telling you more about `angle top` soon in a dedicated blog post.

## What's next?

This release introduces the API and a sample client, but we're just getting
started. In future releases, we'll be expanding the API's capabilities to
include:

- Validating and changing configuration programmatically. So far, all of our
  queries have been read-only. Future versions will include GraphQL mutations
  that allow changes to a running Angle pipeline (think: HTTP POST-style
  requests).

- An exciting new web UI for visualising and interacting with topology.

- Component-specific types and metrics that can provide much deeper and more
  granular insight into what's happening in your topology

Follow us at [@khulnasoft](https://twitter.com/khulnasoft) to be notified of
updates.

## Further reading

GraphQL is an API protocol introduced by Facebook. You can learn more at
[https://graphql.org](https://graphql.org)

For clients and language support, check out [Awesome
GraphQL](https://github.com/chentsulin/awesome-graphql), a curated list of
libraries and other helpers.

For a deeper dive into the currently supported fields in the Angle API, your
best source of information is the "Docs" sidebar in the API playground. As a
type-safe interface, GraphQL is self-documenting. Review the inline comments to
learn more about what a field returns. We'll eventually add to this with
dedicated API docs, but this is a great way to get started.

In future posts we'll be exploring the GraphQL ecosystem in more detail and
explaining the mechanics of what made GraphQL a winning choice for the Angle
API, over some of the alternatives such as REST or gRPC &dash; including a deep
dive into Rust libs and code snippets.

Stay tuned!
