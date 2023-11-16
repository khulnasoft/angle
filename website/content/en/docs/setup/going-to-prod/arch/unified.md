---
title: Unified Architecture
description: Collect at the edge, and then aggregate, for maximum flexibility.
weight: 3
---

## Overview

The unified architecture deploys Angle an [agent](/docs/setup/going-to-prod/architecting/) and [aggregator](/docs/setup/going-to-prod/architecting/). It combines the [agent architecture](/docs/setup/going-to-prod/arch/agent/) with the [aggregator architecture](/docs/setup/going-to-prod/arch/aggregator/) to create a unified observability pipeline.

![Unified](/img/going-to-prod/unified.png)

This is a powerful architecture that we recommend for Angle users that have already deployed the [aggregator architecture](/docs/setup/going-to-prod/arch/aggregator/) and want to bring Angle to their individual nodes.

### When to Use this Architecture

We recommend this architecture for Angle users that have already deployed the aggregator architecture. This is a natural evolution that hardens your observability pipeline by:

- Minimizing agent risk by taking over the responsibility of data delivery from your nodes.
- Improves performance by using Angle’s native protocol via the `angle` source and sink.
- Allows you to shift stateless processing to the edge for natural scalability.
- Enables more sophisticated failover and disaster recovery strategies.

## Support

For easy setup and maintenance of this architecture, consider the Angle’s [discussions](https://discussions.angle.khulnasoft.com) or [chat](https://chat.angle.khulnasoft.com). These are free best effort channels. For enterprise needs, consider Datadog Observability Pipelines, which comes with enterprise-level support. Read more about that [here](https://www.datadoghq.com/product/observability-pipelines/).
