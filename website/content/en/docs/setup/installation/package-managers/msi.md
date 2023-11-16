---
title: Install Angle using MSI
short: MSI
weight: 5
---

MSI is the file format and command line utility for the [Windows Installer][installer]. Windows Installer (previously known as Microsoft Installer) is an interface for Microsoft Windows that's used to install and manage software on Windows systems. This page covers installing and managing Angle through the MSI package repository.

## Installation

```powershell
powershell Invoke-WebRequest https://packages.timber.io/angle/{{% version %}}/angle-x64.msi -OutFile angle-{{% version %}}-x64.msi
msiexec /i angle-{{% version %}}-x64.msi
```

## Management

{{< jump "/docs/administration/management" "windows" >}}

[installer]: https://en.wikipedia.org/wiki/Windows_Installer
