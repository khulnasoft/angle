---
title: The Angle API
short: API
weight: 3
---

Angle ships with a [GraphQL] API that allows you to interact with a running Angle instance. This page covers how to configure and enable Angle's API.

## Configuration

{{< api/config >}}

## Endpoints

{{< api/endpoints >}}

## How it works

### GraphQL

Angle chose [GraphQL] for its API because GraphQL is self-documenting and type safe. We believe that this offers a superior client experience and makes Angle richly programmable through its API.

### Playground

Angle's GraphQL API ships with a built-in playground that allows you to explore the available commands and manually run queries against the API. This can be accessed at the `/playground` path.

[graphql]: https://graphql.org
