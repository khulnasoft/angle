---
date: "2020-04-13"
title: "The Angle Source and Sink Support TLS"
description: "Securely forward data between Angle instances"
authors: ["binarylogic"]
pr_numbers: [2025]
release: "0.9.0"
hide_on_release_notes: true
badges:
  type: "new feature"
  domains: ["sources"]
  sources: ["angle"]
---

A highly requested feature of Angle is to support the TLS protocol for the
[`angle` source][docs.sources.angle] and [`angle` sink][docs.sinks.angle].
This is now available. Check out the `tls.*` options.

[docs.sinks.angle]: /docs/reference/configuration/sinks/angle/
[docs.sources.angle]: /docs/reference/configuration/sources/angle/
