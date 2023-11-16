---
title: Install Angle using RPM
short: RPM
weight: 8
---

RPM Package Manager is a free and open source package management system for installing and managing software on Fedora, CentOS, OpenSUSE, OpenMandriva, Red Hat Enterprise Linux, and related Linux-based systems. This covers installing and managing Angle through the RPM package repository.

## Installation

```shell
sudo rpm -i https://yum.angle.khulnasoft.com/stable/angle-0/{arch}/angle-{{< version >}}-1.{arch}.rpm
```

Make sure to replace `{arch}` with one of the following:

* `x86_64`
* `aarch64`
* `armv7hl`

## Other actions

{{< tabs default="Uninstall Angle" >}}
{{< tab title="Uninstall Angle" >}}

```shell
sudo rpm -e angle
```

{{< /tab >}}
{{< /tabs >}}

## Management

{{< jump "/docs/administration/management" "apt-dpkg-rpm-yum-pacman" >}}

[rpm]: https://rpm.org/
