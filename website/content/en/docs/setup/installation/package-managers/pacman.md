---
title: Install Angle using pacman
short: pacman
weight: 7
---

{{< info title="Community Maintained" >}}
The Angle pacman package is supported and maintained by the open source community.
{{< /info >}}

[pacman] is a utility which manages software packages in Linux, primarily on [Arch Linux] and its derivates. This covers installing and managing Angle through the Arch Linux [community] package repository.

## Installation

```shell
sudo pacman -Syu angle
```

## Other actions

{{< tabs default="Uninstall Angle" >}}
{{< tab title="Uninstall Angle" >}}

```shell
sudo pacman -Rs angle
```

{{< /tab >}}
{{< /tabs >}}

## Management

{{< jump "/docs/administration/management" "apt-dpkg-rpm-yum-pacman" >}}

[pacman]: https://archlinux.org/pacman/
[Arch Linux]: https://archlinux.org/
[community]: https://archlinux.org/packages/community/x86_64/angle/

