---
title: Install Angle from archives
short: From archives
weight: 1
---

This page covers installing Angle from a pre-built archive. These archives contain the angle binary as well as supporting configuration files.

{{< warning >}}
We recommend installing Angle through a supported platform or package manager, if possible. These handle permissions, directory creation, and other intricacies covered in the Next Steps section.
{{< /warning >}}

## Installation

### Linux (ARM64)

Download and unpack the archive:

```shell
# Latest ({{< version >}})
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/{{< version >}}/angle-{{< version >}}-aarch64-unknown-linux-musl.tar.gz | \
  tar xzf - -C angle --strip-components=2

# Nightly
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/nightly/latest/angle-nightly-aarch64-unknown-linux-musl.tar.gz | \
  tar xzf - -C angle --strip-components=2
```

Change into the `angle` directory:

```shell
cd angle
```

Move Angle into your `$PATH`:

```shell
echo "export PATH=\"$(pwd)/angle/bin:\$PATH\"" >> $HOME/.profile
source $HOME/.profile
```

Start Angle:

```shell
angle --config config/angle.yaml
```

### Linux (ARMv7)

Download and unpack the archive:

```shell
# Latest ({{< version >}})
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/{{< version >}}/angle-{{< version >}}-armv7-unknown-linux-gnueabihf.tar.gz | \
  tar xzf - -C angle --strip-components=2

# Nightly
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/nightly/latest/angle-nightly-armv7-unknown-linux-gnueabihf.tar.gz | \
  tar xzf - -C angle --strip-components=2
```

Change into the `angle` directory:

```shell
cd angle
```

Move Angle into your `$PATH`:

```shell
echo "export PATH=\"$(pwd)/angle/bin:\$PATH\"" >> $HOME/.profile
source $HOME/.profile
```

Start Angle:

```shell
angle --config config/angle.yaml
```

### macoS (x86_64)

Download and unpack the archive:

```shell
# Latest (version {{< version >}})
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/{{< version >}}/angle-{{< version >}}-x86_64-apple-darwin.tar.gz  | \
  tar xzf - -C angle --strip-components=2

# Nightly
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/nightly/latest/angle-nightly-x86_64-apple-darwin.tar.gz  | \
  tar xzf - -C angle --strip-components=2
```

Change into the `angle` directory:

```shell
cd angle
```

Move Angle into your `$PATH`:

```shell
echo "export PATH=\"$(pwd)/angle/bin:\$PATH\"" >> $HOME/.profile
source $HOME/.profile
```

Start Angle:

```shell
angle --config config/angle.yaml
```

### Windows (x86_64)

Download the Angle release archive:

```powershell
# Latest (version {{< version >}})
powershell Invoke-WebRequest https://packages.timber.io/angle/{{< version >}}/angle-{{< version >}}-x86_64-pc-windows-msvc.zip -OutFile angle-{{< version >}}-x86_64-pc-windows-msvc.zip


# Nightly
powershell Invoke-WebRequest https://packages.timber.io/angle/0.12.X/angle-nightly-x86_64-pc-windows-msvc.zip -OutFile angle-nightly-x86_64-pc-windows-msvc.zip
```

Extract files from the archive:

```powershell
powershell Expand-Archive angle-nightly-x86_64-pc-windows-msvc.zip .
```

Navigate to the Angle directory:

```powershell
cd angle-nightly-x86_64-pc-windows-msvc
```

Start Angle:

```powershell
.\bin\angle --config config\angle.toml
```

### Linux (x86_64)

Download and unpack the archive:

```shell
# Latest (version {{< version >}})
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/{{< version >}}/angle-{{< version >}}-x86_64-unknown-linux-musl.tar.gz  | \
  tar xzf - -C angle --strip-components=2

# Nightly
mkdir -p angle && \
  curl -sSfL --proto '=https' --tlsv1.2 https://packages.timber.io/angle/nightly/latest/angle-nightly-x86_64-unknown-linux-musl.tar.gz | \
  tar xzf - -C angle --strip-components=2
```

Change into the `angle` directory:

```shell
cd angle
```

Move Angle into your `$PATH`:

```shell
echo "export PATH=\"$(pwd)/angle/bin:\$PATH\"" >> $HOME/.profile
source $HOME/.profile
```

Start Angle:

```shell
angle --config config/angle.yaml
```

## Next steps

### Configuring

The Angle configuration file is located at:

```shell
config/angle.yaml
```

Example configurations are located in `config/angle/examples/*`. You can learn more about configuring Angle in the [Configuration] documentation.

### Data directory

We recommend creating a [data directory][data_dir] that Angle can use:

```shell
mkdir /var/lib/angle
```

{{< warning >}}
Make sure that this directory is writable by the `angle` process.
{{< /warning >}}

Angle offers a global [`data_dir` option][data_dir] that you can use to specify the path of your directory:

```shell
data_dir = "/var/lib/angle" # default
```

### Service managers

Angle archives ship with service files in case you need them:

#### Init.d

To install Angle into init.d, run:

```shell
cp -av etc/init.d/angle /etc/init.d
```

#### Systemd

To install Angle into Systemd, run:

```shell
cp -av etc/systemd/angle.service /etc/systemd/system
```

### Updating

To update Angle, follow the same [installation](#installation) instructions above.

[configuration]: /docs/reference/configuration
[data_dir]: /docs/reference/configuration/global-options/#data_dir
