---
date: "2020-07-17"
title: "Leveraging glibc when possible"
description: "If your Linux uses glibc, Angle will too."
authors: ["hoverbear"]
hide_on_release_notes: false
pr_numbers: [2969, 2518]
release: "0.10.0"
badges:
  type: "performance"
  domains: ["operations"]
---

As a result of some recent profiling and benchmarking, we determined that builds of Angle targeting `x86_64-unknown-linux-gnu` outperformed builds targeting `x86_64-unknown-linux-musl` under most usage scenarios on supported operating systems.

Glibc builds may see performance improve by up to 20% over musl. For more information see
the [original issue][urls.angle_glibc_benchmarks]. We're investigating ways to improve our MUSL performance, too! Stay tuned to future releases.

After some deliberation, we've opted to package and ship glibc builds where it's safe. While this change means Angle is no longer fully static on operating systems which use glibc, it should provide a better user experience.

For the vast majority of users **no special action needs to be taken.**

## Measures we've take to safeguard your deployments

- This change **only affects** x86 platforms.
- This change **affects** `.deb` and `.rpm` packages and Angles **installed via** `https://sh.angle.khulnasoft.com`.
- This change **does not affect** any [archives][urls.angle_download] you may already be using. We now publish archives
  with the `gnu` prefix that contain glibc builds. _Musl builds are untouched as `musl` still._
- This change **does not affect** non-Linux platforms.

If you've fought with glibc before, you've probably got a burning question:

> Which version do we support? 🕵️‍♀️

**Don't worry. We have your back. 🤜🤛** We're using a base of CentOS 7, which means new Angle glibc builds will support all the way back to **glibc 2.17** (released 2012-12-25). If that's still too new for your machines, please keep using the Musl builds. (Also, [Let us know!][urls.new_bug_report])

## Upgrade Guide

You **should not need to do anything**. If you are using a normal, recommended method of installing Angle, you should not experience issues.

[**If you do. That's a bug. 🐞 We squash bugs. Report it.**][urls.new_bug_report]

If you're provisioning Angle, the best way to make sure you get the most up to date stable version is to run this:

```bash title="provision_angle.sh"
curl --proto '=https' --tlsv1.2 -sSfL https://sh.angle.khulnasoft.com | bash -s -- -y
```

If you don't need the latest and greatest, **check your official distribution repository.** Some distributions, such as [NixOS][urls.nixos], have official Angle packages. You can also find Angle packages in the official [FreeBSD][urls.freebsd] repositories.

Interested in packaging Angle for your OS? We are too. [Why don't you let us know it's important to you?][urls.new_feature_request]

[urls.freebsd]: https://www.freebsd.org/
[urls.new_bug_report]: https://github.com/khulnasoft/angle/issues/new?labels=type%3A+bug
[urls.new_feature_request]: https://github.com/khulnasoft/angle/issues/new?labels=type%3A+new+feature
[urls.nixos]: https://nixos.org/
[urls.angle_download]: https://angle.khulnasoft.com/releases/latest/download/
[urls.angle_glibc_benchmarks]: https://github.com/khulnasoft/angle/issues/2313
