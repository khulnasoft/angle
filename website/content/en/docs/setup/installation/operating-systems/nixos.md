---
title: Install Angle on NixOS
short: NixOS
supported_installers: ["Nix", "Docker"]
weight: 6
---

[NixOS] is a Linux distribution built on top of the Nix package manager. This
page covers installing and managing Angle on NixOS.

Nixpkgs has a [community maintained package][nixpkg-angle] for Angle. It can
be installed on a NixOS system with the following snippet in
`configuration.nix`:

```nix
environment.systemPackages = [
  pkgs.angle
];
```

See also the [Nix] package page.

## Supported installers

{{< supported-installers >}}

[nixos]: https://www.nixos.org
[nixpkg-angle]: https://github.com/NixOS/nixpkgs/tree/master/pkgs/tools/misc/angle
[nix]: /docs/setup/installation/package-managers/nix
