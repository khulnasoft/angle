---
title: Install Angle
description: Get up and running with Angle on your preferred platform
short: Installation
---

Angle compiles to a single static binary, which makes it easy to install.

On \*nix systems Angle's only dependency is [`libc`][libc]. Your operating system should generally provide this
dependency.

## Using static musl builds

We also release Angle artifacts that are statically linked with [`musl`][musl] for the [`libc`][libc] implementation,
which results in a static binary with no dependencies (these have `musl` in their name). These dependency-free
artifacts can be useful in stripped-down environments that don't provide a built-in `libc` implementation.

{{< warning title="musl performance issues" >}}
Please note that musl, as of this writing, has a significantly worse performance profile than [glibc] when Angle is
running in multiple threads (Angle defaults to the number of available cores). We recommend that you use [glibc] when
available _unless_ you're running Angle on a single CPU.

[glibc]: https://www.gnu.org/software/libc

{{< /warning >}}

## Installation script

This light-weight script detects your platform and determine the best method for installing Angle:

{{< easy-install-scripts >}}

You can use the `--prefix` option to specify a custom installation directory. This is
especially useful in automated environments (for example Dockerfiles).

The following command adds the required binaries to `$PATH` without modifying your profiles.

{{< docker-example-install-scripts >}}

## Other installation methods

If you prefer a more granular method for installing Angle, check out these subsections of the documentation for
alternatives:

{{< sections >}}

[libc]: https://man7.org/linux/man-pages/man7/libc.7.html
[musl]: https://musl.libc.org
