---
date: "2021-08-20"
title: "Version 2 of the Angle source/sink released"
description: ""
authors: ["JeanMertz"]
pr_numbers: []
release: "0.16.0"
hide_on_release_notes: false
badges:
  type: "announcement"
---

We've released a new major version (`v2`) of our `angle` [source][]/[sink][]
components. This release resolves several issues and limitations we experienced
with our previous (`v1`) TCP-based implementation of these two components:

- `angle` sink does not work in k8s with dynamic IP addresses ([#2070][])
- Allow for HTTP in the angle source and sinks ([#5124][])
- Allow Angle Source and Sink to Communicate over GRPC ([#6646][])
- RFC 5843 - Encoding/Decoding for Angle to Angle Communication ([#6032][])

The new version transitions to using gRPC over HTTP as its communication
protocol, which resolves those limitations.

To allow operators to transition at their leisure, this new release of Angle
still defaults to `v1`. In `0.20.0` we'll require operators to explicitly state
which version they want to use, but continue to support `v1`. In `0.22.0` we'll
drop `v1` completely, and default to `v2`. We will also no longer require you to
explicitly set the version since there will only be one supported going forward.

If you want to opt in to the new (stable!) `v2` version, you can do so as
follows:

```diff
[sinks.angle]
  type = "angle"
+ version = "2"

[sources.angle]
  type = "angle"
+ version = "2"
```

There are a couple of things to be aware of:

#### Removed options

There are some configuration options that are no longer valid with version 2 of
the source and sink:

- `angle` source: `keepalive` and `receive_buffer_bytes`
- `angle` sink: `keepalive` and `send_buffer_bytes`

As these were specific to the TCP-based version 1 of the protocol.

#### Upgrade both the source _and_ sink

You **have** to upgrade **both** the source and sink to `v2`, or none at all,
you cannot update one without updating the other. Doing so will result in a loss
of events.

#### Zero-downtime deployment

If you want to do a zero-downtime upgrade to `v2`, you'll have to introduce the
new source/sink versions next to the existing versions, before removing the
existing one.

First, deploy the configuration that defines the source:

```diff
  [sources.angle]
    address = "0.0.0.0:9000"
    type = "angle"
+   version = "1"

+ [sources.angle]
+   address = "0.0.0.0:5000"
+   type = "angle"
+   version = "2"
```

Then, deploy the sink configuration, switching it over to the new version:

```diff
  [sinks.angle]
-   address = "127.0.1.2:9000"
+   address = "127.0.1.2:5000"
    type = "angle"
+   version = "2"
```

Once the sink is deployed, you can do another deploy of the source, removing the
old version:

```diff
- [sources.angle]
-   address = "0.0.0.0:9000"
-   type = "angle"
-   version = "1"
-
  [sources.angle]
    address = "0.0.0.0:5000"
    type = "angle"
    version = "2"
```

That's it! You are now using the new transport protocol for Angle-to-Angle
communication.

[source]: https://angle.khulnasoft.com/docs/reference/configuration/sources/angle/
[sink]: https://angle.khulnasoft.com/docs/reference/configuration/sinks/angle/
[#2070]: https://github.com/khulnasoft/angle/issues/2070
[#5124]: https://github.com/khulnasoft/angle/issues/5124
[#6646]: https://github.com/khulnasoft/angle/issues/6646
[#6032]: https://github.com/khulnasoft/angle/pull/6032
