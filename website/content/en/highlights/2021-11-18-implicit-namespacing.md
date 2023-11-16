---
date: "2021-11-18"
title: "Automatic namespacing for configuration files"
description: "New automatic namespacing functionality to better organize your Angle configuration files"
authors: ["barieom"]
pr_numbers: [9378]
release: "0.18.0"
hide_on_release_notes: false
badges:
  type: new feature
---

We've released automatic namespacing for configuration files, which simplifies namespace configuration for your pipelines.

As Angle continues to evolve, releasing more configuration-heavy functionality
such as an aggregator role and pipelines features, there's often a proliferation
in the amount of configuration necessary to run Angle. The ability to organize
Angle across multiple files was also lacking in any concrete recommendations
for collaboration and navigation; Angle users may have dozens of Angle
configuration files, from multiple source files to countless sink files, in
a single directory.

Let's look at how we can refactor an existing set of Angle configuration files.

Assuming Angle is loaded using the configuration via `--config-dir /etc/angle`:

```text
/etc/angle/
│   file001.toml
│   file002.toml
│   file003.toml
│   ...
│   file022.toml
│   file023.toml
```

We can update this using Angle's new  _automatic namespacing_ to organize the
configuration into separate files based on Angle's configuration directory
structure. This makes it easy for users like you to split up your configuration
files and collaborate with others on their team.

When using `--config-dir` to provide Angle's configuration, it will look for
subdirectories with the component types (e.g. `transforms`, or `sources`) and
automatically infer that the files in these directories refer to that type of
component. Further, Angle will use filenames of the configuration files as
their component ID. The end result is that you have to specify less
configuration as Angle can infer the component type and id from the directory
structure.

Using the above example, now with _automatic namespacing_, you can update this
to look like:

```text
/etc/angle/
└───sources/
│   │   file001.toml
│   │   ...
│   │   file005.toml
│
└───transforms/
│   │   file006.toml
│   │   ...
│   │   file016.toml
│
└───sinks/
    │   file017.toml
    │   file022.toml
```

The configuration files become simplified from:

``` toml
# /etc/angle/file017.toml
[sinks.foo]
type = "anything"
```

to:

``` toml
# /etc/angle/sinks/file017.toml
type = "anything"
```

This can similarly be applied to the newly added [`enrichment_tables`][enrichment_tables] and [`tests`][tests] as well.

If you any feedback for us, let us know on our [Discord chat] or on [Twitter].

[enrichment_tables]: /docs/reference/configuration/global-options/#enrichment_tables
[tests]: /docs/reference/configuration/unit-tests
[Discord chat]: https://discord.com/invite/dX3bdkF
[Twitter]: https://twitter.com/khulnasoft
