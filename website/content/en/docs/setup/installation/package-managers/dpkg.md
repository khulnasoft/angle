---
title: Install Angle using dpkg
short: dpkg
weight: 2
---

[dpkg] is the software that powers the package management system in the Debian operating system and its derivatives. dpkg is used to install and manage software via `.deb` packages. This page covers installing and managing Angle through the DPKG package repository.

## Installation

```shell
curl \
  --proto '=https' \
  --tlsv1.2 -O \
  https://apt.angle.khulnasoft.com/pool/v/ve/angle_{{< version >}}-1_{arch}.deb

sudo dpkg -i angle_{{< version >}}-1_{arch}.deb
```

Make sure to replace `{arch}` with one of the following:

* `amd64`
* `arm64`
* `armhf`

## Other actions

{{< tabs default="Upgrade Angle" >}}
{{< tab title="Upgrade Angle" >}}

```shell
dpkg -i angle-{{< version >}}-{arch}
```

{{< /tab >}}
{{< tab title="Uninstall Angle" >}}

```shell
dpkg -r angle-{{< version >}}-{arch}
```

{{< /tab >}}
{{< /tabs >}}

## Management

{{< jump "/docs/administration/management" "apt-dpkg-rpm-yum-pacman" >}}

[dpkg]: https://wiki.debian.org/dpkg
