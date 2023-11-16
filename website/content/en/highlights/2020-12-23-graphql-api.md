---
date: "2020-12-23"
title: "The GraphQL API for Angle"
description: "View Angle metrics and explore Angle topologies using GraphQL"
authors: ["lucperkins"]
pr_numbers: []
release: "0.12.0"
hide_on_release_notes: false
badges:
  type: "new feature"
  domains: ["api"]
---

Angle now has a [GraphQL] API that you can use for a variety of purposes:

* To view Angle's internal metrics
* To view metadata about the Angle instance
* To explore configured Angle topologies

We have plans to enhance the API in the coming releases by enabling you to, for
example, re-configure Angle via the API.

## How to use it

The GraphQL API for Angle is **disabled by default**. We want to keep Angle's
behavior as predictable and secure as possible, so we chose to make the feature
opt-in. To enable the API, add this to your Angle config:

```toml
[api]
enabled = true
address = "127.0.0.1:8686" # optional. Change IP/port if required
```

## Read more

For a more in-depth look at the API, check out:

* The recent [announcement post][post] for the API from esteemed Angle engineer [Lee Benson][lee].
* Our [official documentation]
* The [Rust code][code] behind the API

[code]: https://github.com/khulnasoft/angle/tree/master/src/api
[docs]: https://angle.khulnasoft.com/docs/reference/api
[graphql]: https://graphql.org
[lee]: https://github.com/LeeBenson
[post]: https://angle.khulnasoft.com/blog/graphql-api
