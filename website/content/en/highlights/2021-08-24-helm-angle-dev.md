---
date: "2021-08-24"
title: "Introducing helm.angle.khulnasoft.com"
description: "A new home for Angle's Helm charts"
authors: ["spencergilbert"]
pr_numbers: []
release: "0.16.0"
hide_on_release_notes: false
badges:
  type: "deprecation"
  platforms: ["helm"]
---

Angle's new home for helm charts is at https://helm.angle.khulnasoft.com!

We made this change as part of migrating the helm charts from our old AWS S3 bucket hosting to
GitHub Pages via [khulnasoft/helm-charts](https://github.com/khulnasoft/helm-charts). This new domain
will also allow us to swap hosting in the future without any user impact.

Angle’s 0.16.x release will be the last version that publishes charts to both
https://packages.timber.io/helm/latest and https://packages.timber.io/helm/nightly repositories.

The new repository contains all released charts from the previous `latest` repository.
Moving forward we will be releasing charts at their own pace as we work towards the stable
releases for the _angle-agent_ and _angle-aggregator_ charts.

Development and issue tracking will be migrated to https://github.com/khulnasoft/helm-charts
in the coming days.

## Upgrade Guide

The new repository can be added with:

```shell
helm repo add angle https://helm.angle.khulnasoft.com
helm repo update
```

Once added the _angle-agent_ chart can be installed with:

```shell
helm install angle angle/angle-agent \
  --namespace angle \
  --create-namespace \
```

Or upgraded with:

```shell
helm upgrade angle angle/angle-agent \
  --namespace angle \
  --reuse-values
```
