---
date: "2020-11-25"
title: "JSON and YAML config formats are now supported"
description: "We've added support for JSON and YAML config formats."
authors: ["binarylogic"]
pr_numbers: [4856, 5144]
release: "0.11.0"
hide_on_release_notes: false
badges:
  type: "new feature"
  domains: ["config"]
---

To ensure Angle fits into existing workflows, like Kubernetes, we've added
support for JSON and YAML config formats in addition to TOML. TOML will
continue to be our default format, but users are welcome to use JSON and YAML
as they see fit.

## Use cases

### Kubernetes

YAML is the preferred language in the K8s ecosystem, and to ensure Angle
does not feel awkward in the Kubernetes platform we now support YAML for
our pipeline definitions.

### Data templating languages

A bonus to supporting JSON is the enablement of data templating languages like
[Jsonnet][jsonnet] and [Cue][cue]. For example, a Angle user has already
built an [unofficial Jsonnet library][jsonnet_library] for Angle.

## Get Started

Use Angle as you normally work, but pass it `yaml` or `json` config files:

```bash
angle --config /etc/angle/angle.json
```

Angle will infer the format from the extension. This is especially useful
when passing multiple config files via globs:

```bash
angle --config /etc/angle/*
```

Additionally, we've provided format specific flags for edge cases:

```bash
angle --config-json /etc/angle/angle.json
```

Head over to the [configuration docs][config] for more info.

[config]: /docs/reference/configuration
[cue]: https://cuelang.org/
[jsonnet]: https://jsonnet.org/
[jsonnet_library]: https://github.com/xunleii/angle_jsonnet
