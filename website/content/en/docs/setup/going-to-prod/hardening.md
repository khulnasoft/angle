---
title: Hardening Angle
description: Guidance and best practices for securing Angle deployments.
short: Hardening
weight: 2
---

## Threat Model Coverage

Before we can harden Angle we must understand how it’s vulnerable. The following table demonstrates Angle’s threat model coverage with the below [defense-in-depth](https://en.wikipedia.org/wiki/Information_security#Defense_in_depth) strategy.

| Threat | Defenses |
| --- | --- |
| Eavesdropping attacks | 🛡️ Enable whole disk encryption<br />🛡️ Disable swap<br />🛡️ Restrict Angle’s data directory<br />🛡️ Encrypt external storage<br />🛡️ Encrypt or redact sensitive attributes<br />🛡️ Disable core dumps<br />🛡️ Use end-to-end TLS<br />🛡️ Use modern encryption algorithms<br />🛡️ Use a firewall |
| Supply chain attacks | 🛡️ Download over encrypted channels<br />🛡️ Verify Angle’s download |
| Credential theft attacks | 🛡️ Never use plain text secrets<br />🛡️ Restrict Angle’s configuration directory |
| Privilege escalation attacks | 🛡️ Do not run Angle as root<br />🛡️ Restrict the Angle service account<br />🛡️ Ensure Angle is the single tenant<br />🛡️ Disable SSH or remote access |
| Upstream attacks | 🛡️ Review Angle’s security policy<br />🛡️ Upgrade Angle frequency |

## Defense-In-Depth

Angle takes a [defense-in-depth approach](https://en.wikipedia.org/wiki/Information_security#Defense_in_depth) to hardening and follows the data, process, host, and network [onion model](https://en.wikipedia.org/wiki/Onion_model).

![Onion model](/img/going-to-prod/onion-model.png)

### Securing the Data

#### Securing Data at Rest

Angle will not serialize events on disk unless you’ve configured Angle to use disk buffers or have enabled swap. Therefore, to secure data at rest, we recommend:

- **Enable whole disk encryption.** Whole disk encryption moves the responsibility of disk encryption to the operating system or file system. This offers better holistic security, and is faster and more CPU efficient. Please follow your platform’s guidance for encryption at rest (i.e., [AWS](https://docs.aws.amazon.com/whitepapers/latest/efs-encrypted-file-systems/encryption-of-data-at-rest.html), [Azure](https://docs.microsoft.com/en-us/azure/security/fundamentals/encryption-atrest), [Google Cloud](https://cloud.google.com/security/encryption/default-encryption)).
- **Disable swap.** Disabling swap prevents the operating system from overflowing Angle’s memory to disk, reducing disk exposure of your data. This is also better for performance. Angle should always have enough memory to operate without swap.
- **Restrict Angle’s data directory.** The unprivileged Angle service account should be the only account that can read or write into Angle’s data directory (i.e., `/var/lib/angle` ).
- **Encrypt external storage.** Finally, external storage, such as archives, should be encrypted. This can be done in a variety of ways depending on your security model but is typically achieved through server-side encryption. Please follow your storage’s guidance for encryption (i.e., [AWS S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucket-encryption.html), [Azure Blob Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-service-encryption), [Google Cloud Storage](https://cloud.google.com/storage/docs/encryption)).

#### Securing Data in Transit

- **Redact sensitive attributes.** Event attributes that hold sensitive data, such as PII, can be redacted (i.e., the VRL `redact` function).
- **Disable core dumps.** A user who can force a core dump could access Angle’s in-flight data. Preventing core dumps is specific to your platform. On Linux setting the resource limit `RLIMIT_CORE` to `0` disables core dumps. In the systemd service unit file, setting `LimitCORE=0` will enforce this setting for the Angle service (this is done automatically when installing Angle through `apt` or `yum`).

{{< info >}}
Angle implements an affine type system via Rust that achieves memory safety and removes data from memory as soon as possible. Memory safety eliminates a class of memory-related security bugs, and the affine type system reduces exposure by only keeping data in memory when needed.
{{< /info >}}

### Securing the Angle Process

#### Securing Angle’s Code

{{< info >}}
[Angle’s code is open-source](https://github.com/khulnasoft/angle), and the development process is secured as outlined in [Angle’s security policy](https://github.com/khulnasoft/angle/blob/master/SECURITY.md).
{{< /info >}}

#### Securing Angle’s Artifacts

- **Download over encrypted channels.** Angle does not allow unencrypted downloads of its artifacts. All download channels require industry-standard TLS for all connections. When downloading Angle, be sure to enable server certificate verification (the default for most clients).

#### Securing Angle’s Configuration

- **Never use plain text secrets.** Never add plain text secrets to Angle’s configuration files.
- **Restrict Angle’s configuration directory.** Angle’s configuration directory (i.e., `/etc/angle`) should be read restricted to Angle’s unprivileged service account and write restricted to your operational account used when deploying Angle.

#### Securing Angle’s Runtime

- **Do not run Angle as root.** Angle is designed to run via a dedicated service account. Never run Angle as root or an administrator account.
- **Restrict the Angle service account.** Angle’s service account should not have the ability to overwrite Angle’s binary or configuration files (i.e., the `/etc/angle` directory). The only directory the Angle service account should write to is Angle’s data directory (i.e., `/var/lib/angle`).
- **Upgrade Angle frequently.** Angle is actively developed by a team at Datadog and hundreds of contributors around the world. Releases can include important bug and security fixes. We recommend watching the [Angle repository](https://github.com/khulnasoft/angle) for releases, following the [Angle Twitter account](https://twitter.com/khulnasoft), or subscribing to the [Angle calendar](https://calendar.angle.khulnasoft.com) for release notifications.

### Securing the Host

- **Ensure Angle is the single tenant.** When deploying Angle as an aggregator it should be the single tenant on the machine. This prevents other processes from unknowingly interacting with the Angle process.
- **Disable SSH or remote access.** Users should never access the Angle machine directly to interact with Angle. Instead, users should interact through a central control plane for observability and management. Consider Angle’s enterprise offering, Datadog Observability Pipelines.

### Securing the Network

- **Use end-to-end TLS.** For all sources and sinks, enable end-to-end TLS, even for internal traffic. This ensures that data in transit is secured from its source to destination.
- **Use modern encryption algorithms.** Use the latest encryption algorithms. For example, if your system supports it, use TLS 1.3 instead of older versions.
- **Use a firewall.** Finally, use a software or hardware level firewall to restrict incoming and outgoing traffic with Angle. Only enable access to subnets that Angle needs to communicate with.
