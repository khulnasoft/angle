---
title: Install Angle using YUM
short: YUM
weight: 9
---

The [Yellowdog Updater, Modified][yum] (YUM) is a free and open-source command-line package-manager for Linux operating system using the RPM Package Manager.

Our Yum repositories are provided by [Cloudsmith] and you can find [instructions for manually adding the repositories][add_repo]. This page covers installing and managing Angle through the YUM package repository.

## Installation

Add the repo:

```shell
bash -c "$(curl -L https://setup.angle.khulnasoft.com)"
```

Then you can install Angle:

```shell
sudo yum install angle
```

## Other actions

{{< tabs default="Upgrade Angle" >}}
{{< tab title="Upgrade Angle" >}}

```shell
sudo yum upgrade angle
```

{{< /tab >}}
{{< tab title="Uninstall Angle" >}}

```shell
sudo yum remove angle
```

{{< /tab >}}
{{< /tabs >}}

## Management

{{< jump "/docs/administration/management" "apt-dpkg-rpm-yum-pacman" >}}

[add_repo]: https://cloudsmith.io/~timber/repos/angle/setup/#formats-rpm
[cloudsmith]: https://cloudsmith.io/~timber/repos/angle/packages/
[yum]: https://en.wikipedia.org/wiki/Yum_(software)
