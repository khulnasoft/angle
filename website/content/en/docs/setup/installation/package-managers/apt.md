---
title: Install Angle using APT
short: APT
weight: 1
---

[Advanced Package Tool][apt], or **APT**, is a free package manager that handles the installation and removal of software on [Debian], [Ubuntu], and other [Linux] distributions.

Our APT repositories are provided by [Cloudsmith] and you can find [instructions][repos] for manually adding the repositories. This page covers installing and managing Angle through the [APT package repository][apt].

## Supported architectures

* x86_64
* ARM64
* ARMv7

## Installation

First, add the Angle repo:

```shell
bash -c "$(curl -L https://setup.angle.khulnasoft.com)"
```

Then you can install the `angle` package:

```shell
sudo apt-get install angle
```

## Other actions

{{< tabs default="Upgrade Angle" >}}
{{< tab title="Upgrade Angle" >}}

```bash
sudo apt-get upgrade angle
```

{{< /tab >}}
{{< tab title="Uninstall Angle" >}}

```bash
sudo apt remove angle
```

{{< /tab >}}
{{< /tabs >}}

## Management

{{< jump "/docs/administration/management" "apt-dpkg-rpm-yum-pacman" >}}

[apt]: https://en.wikipedia.org/wiki/APT_(software)
[cloudsmith]: https://cloudsmith.io/~timber/repos/angle/packages
[debian]: https://debian.org
[linux]: https://linux.org
[repos]: https://cloudsmith.io/~timber/repos/angle/setup/#formats-deb
[ubuntu]: https://ubuntu.com
