---
title: Install Angle using Helm
short: Helm
weight: 3
---

[Helm] is a package manager for Kubernetes that facilitates the deployment and management of applications and services on Kubernetes clusters. This page covers installing and managing the Angle chart.

## Adding the Helm repo

If you haven't already, start by adding the Angle repo:

```shell
helm repo add angle https://helm.angle.khulnasoft.com
helm repo update
```

## Agent

The Angle [Agent] lets you collect data from your [sources] and then deliver it to a variety of destinations with [sinks].

### Configuring

To check available Helm chart configuration options:

```shell
helm show values angle/angle
```

This example configuration file deploys Angle as an Agent, the full default configuration can be found [here](https://github.com/khulnasoft/helm-charts/blob/develop/charts/angle/templates/configmap.yaml). For more information about configuration options, see the [configuration] docs page.

```yaml
cat <<-'VALUES' > values.yaml
role: Agent
VALUES
```

### Installing

Once you add the Angle Helm repo, and added a Angle configuration file, install the Angle Agent:

```shell
helm install angle angle/angle \
  --namespace angle \
  --create-namespace \
  --values values.yaml
```

### Updating

Or to update the Angle Agent:

```shell
helm repo update && \
helm upgrade angle angle/angle \
  --namespace angle \
  --reuse-values
```

## Aggregator

The Angle [Aggregator] lets you [transform] and ship data collected by other agents. For example, it can insure that the data you are collecting is scrubbed of sensitive information, properly formatted for downstream consumers, sampled to reduce volume, and more.

### Configuring

To check available Helm chart configuration options:

```shell
helm show values angle/angle
```

The chart deploys an Aggregator by default, the full configuration can be found [here](https://github.com/khulnasoft/helm-charts/blob/develop/charts/angle/templates/configmap.yaml). For more information about configuration options, see the [Configuration] docs page.

### Installing

Once you add the Angle Helm repo, install the Angle Aggregator:

```shell
helm install angle angle/angle \
  --namespace angle \
  --create-namespace
```

### Updating

Or to update the Angle Aggregator:

```shell
helm repo update && \
helm upgrade angle angle/angle \
  --namespace angle \
  --reuse-values
```

## Uninstalling Angle

To uninstall the Angle helm chart:

```shell
helm uninstall angle --namespace angle
```

## View Helm Chart Source

If you'd like to clone the charts, file an Issue or submit a Pull Request, please take a look at [khulnasoft/helm-charts](https://github.com/khulnasoft/helm-charts).

## Management

{{< jump "/docs/administration/management" "helm" >}}

[helm]: https://helm.sh
[Configuration]: /docs/reference/configuration/
[Agent]: /docs/setup/deployment/roles/#agent
[sources]: /docs/reference/configuration/sources/
[sinks]: /docs/reference/configuration/sinks/
[Aggregator]: /docs/setup/deployment/roles/#aggregator
[transform]: /docs/reference/configuration/transforms/
