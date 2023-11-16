---
date: "2021-06-02"
title: "Switching to the system allocator"
description: "Angle has switched from using jemalloc to the system allocator"
authors: ["jszwedko"]
pr_numbers: [6781]
release: "0.14.0"
hide_on_release_notes: false
badges:
  type: "announcement"
  domains: ["performance"]
---

Since version 0.2.0, Angle has used [jemalloc] as its memory allocator on *nix-based OSes. As part of
some ongoing performance work, we've made the decision to switch to the system allocator provided by the platform
Angle is deployed on. This will be either the [GNU Allocator][gnu_allocator] for `glibc`-based builds (like
Debian) or the [`musl` allocator][musl_allocator] for `musl`-based builds (like Alpine Linux).

In environments where Angle has access to multiple CPUs, we recommend using the `glibc`-based builds as, at the time of
writing, [we have observed that the GNU allocator performs
better][performance] when running on multiple threads.

If you are installing one of the packages or release assets listed on the [release page][0_14],
then you will be getting a `glibc` build. `musl` builds are available through the [full release asset
listing][0_14_full].

If you are running Angle in Docker, we recommend using the `v0.14.0-distroless-libc` image for a light-weight Angle
image; however the `v0.14.0-debian` image will also be using the GNU Allocator. The `v0.14.0-alpine` and
`v0.14.0-static` images use `musl` as `glibc` is not available there.

This change was made largely because we had insufficient evidence and motivation to use anything other than the system
allocator which is a sensible default otherwise. As we have a better understanding of Angle's allocation profile, it is
likely we will revisit this decision.

[0_14]: /releases/0.14.0
[0_14_full]: https://packages.timber.io/angle/v0.14.0
[gnu_allocator]: https://www.gnu.org/software/libc/manual/html_node/The-GNU-Allocator.html
[jemalloc]: https://github.com/jemalloc/jemalloc
[musl_allocator]: https://musl.libc.org/releases.html
[performance]: https://github.com/khulnasoft/angle/issues/1985#issuecomment-670667972
