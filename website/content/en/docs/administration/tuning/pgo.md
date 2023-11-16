---
title: Profile-Guided Optimization
description: How to optimize Angle performance with Profile-Guided Optimization
short: PGO
weight: 3
tags: ["pgo", "tuning", "rust", "performance"]
---

Profile-Guided Optimization (PGO) is a compiler optimization technique where a program is optimized based on the runtime profile.

According to the [tests], we see improvements of up to 15% more processed log events per second on some Angle workloads. The performance benefits depend on your typical workload - you can get better or worse results.

More information about PGO in Angle you can read in the corresponding GitHub [issue].

### How to build Angle with PGO?

There are two major kinds of PGO: Instrumentation and Sampling (also known as AutoFDO). In this guide, is described the Instrumentation PGO with Angle. In this guide we use [cargo-pgo] for building Angle with PGO.

* Install [cargo-pgo].
* Check out the Angle repository.
* Go to the Angle source directory and run `cargo pgo build`. It will build the instrumented Angle version.
* Run instrumented Angle on your test load like `cargo pgo run -- -- -c angle.toml` and wait for some time to collect enough information from your workload. Usually, waiting several minutes is enough (but your case can be different).
* Stop Angle instance. The profile data will be generated in the `target/pgo-profiles` directory.
* Run `cargo pgo optimize`. It will build Angle with PGO optimization.

A more detailed guide on how to apply PGO is in the Rust [documentation].

[tests]: https://github.com/khulnasoft/angle/issues/15631#issue-1502073978
[issue]: https://github.com/khulnasoft/angle/issues/15631
[documentation]: https://doc.rust-lang.org/rustc/profile-guided-optimization.html
[cargo-pgo]: https://github.com/Kobzol/cargo-pgo
