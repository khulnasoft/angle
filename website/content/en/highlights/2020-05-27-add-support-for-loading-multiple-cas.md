---
date: "2020-07-13"
title: "Support for loading multiple CAs"
description: "Complicated PEM? No PEM-blem with Angle!"
authors: ["hoverbear"]
hide_on_release_notes: false
pr_numbers: [2616]
release: "0.10.0"
badges:
  type: "enhancement"
  sources: ["socket"]
---

Working with `openssl` isn't very fun, and we don't want to inflict that on you. Angle can deal non-trivial certificate chains now. This means if you have a `.pem` file with 2 chains of 4 certs, well, Angle should be able to work it out.

This is particularly useful if you have a socket source:

```toml title="angle.toml"
[sources.tls]
  type = "socket"
  address = "0.0.0.0:6514"
  mode = "tcp"
  tls.enabled = true
  tls.crt_path = "cert.pfx"
  tls.ca_path = "ca.pem" # Now supported: More complicated PEMS!
  tls.verify_certificate = true
```

If it doesn't, that's a bug. [**Report it.**][urls.new_bug_report] We squash bugs.

[urls.new_bug_report]: https://github.com/khulnasoft/angle/issues/new?labels=type%3A+bug
