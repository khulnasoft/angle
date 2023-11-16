---
title: Install Angle using Homebrew
short: Homebrew
weight: 4
---

[Homebrew] is a free and open source package management system for Apple's macOS operating system and some supported Linux systems. This page covers installing and managing Angle using the Homebrew package repository.

## Installation

```shell
brew tap khulnasoft/brew && brew install angle
```

## Other actions

{{< tabs default="Upgrade Angle" >}}
{{< tab title="Upgrade Angle" >}}

```shell
brew update && brew upgrade angle
```

{{< /tab >}}
{{< tab title="Uninstall Angle" >}}

```shell
brew remove angle
```

{{< /tab >}}
{{< /tabs >}}

## Management

{{< jump "/docs/administration/management" "homebrew" >}}

[homebrew]: https://brew.sh
