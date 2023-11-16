---
title: Data model
description: How Angle understands data
weight: 1
tags: ["data model", "logs", "metrics", "events"]
---

{{< svg "img/data-model-event.svg" >}}

The individual units of data flowing through Angle are known as **events**. Events must fall into one of Angle's defined observability types.

## Event types

Angle defines subtypes for events. This is necessary to establish domain-specific requirements enabling interoperability with existing monitoring and observability systems.

{{< jump "/docs/about/under-the-hood/architecture/data-model/log" >}}
{{< jump "/docs/about/under-the-hood/architecture/data-model/metric" >}}

## FAQ

### Why not *just* events?

We *really* like the idea of an event-only world in which every service is perfectly instrumented with events that contain rich data and context. But in reality, services often emit logs and metrics of varying quality. By designing Angle to meet services where they are, we serve as a bridge to newer standards. This is why we place events at the top of our data model, whereas logs and metrics are derived categories.

Finally, a sophisticated data model that accounts for the various data types allows for correct interoperability between observability systems. For example, a pipeline with a statsd source and a prometheus sink would not be possible without the correct internal metrics data types.
