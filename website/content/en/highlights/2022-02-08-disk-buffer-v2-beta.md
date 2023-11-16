---
date: "2022-02-08"
title: "Beta release of Angle's new disk buffer implementation"
description: "More consistent performance and resource usage for disk buffers"
authors: ["tobz"]
pr_numbers: [9476]
release: "0.20.0"
hide_on_release_notes: false
badges:
  type: enhancement
---

As the first major milestone in our work to improve buffering support in Angle, we're excited
to announce the beta release of a new disk buffer implementation.  Angle's new disk buffer is
faster, more consistent, and uses less resources. With 0.20.0, you can opt into these new disk
buffers via a simple configuration update. We need your help to try it out and give us feedback as
this new feature stabilises and becomes Angle's default disk buffer implementation.

You can [skip below](#trying-out-the-new-disk-buffer-implementation-today) to see how to opt in, or
continue reading to learn about the history of buffers in Angle, and about why we've decided to
rewrite our disk buffer support.

## Buffering in Angle

In Angle, buffers serve the main purpose of temporarily absorbing spikes in load.  All sinks use
some form of buffer between their inputs and the sink itself, and by default, an in-memory buffer is
used.  While great for providing the lowest possible latency and highest throughput, in-memory
buffers lack the ability to provide _data durability._ If any events are still in an in-memory
buffer and Angle experiences an error that terminates the process, or the system running Angle
itself crashes, those buffered events would be permanently lost.  As an alternative to in-memory
buffers, we provide disk buffers, which allow writing the events to disk, providing durability and
persistence, regardless of issues with Angle and the host system.

You may already be familiar with disk buffers if you have a sink configuration that looks like this:

```toml
[sinks.http]
# ...
buffer.type = "disk"
```

## Current disk buffer implementation

The initial disk buffer implementation in Angle was based on [LevelDB][leveldb]. LevelDB can unquestionably meet the "durability" guarantees that Angle wants to provide, but falls short at providing _consistent_ performance.  LevelDB's design, to write to many files, and then eventually merge them back together in the background, is overkill for our needs: Angle only ever writes events to its buffer in a sequential fashion, and paying the cost of this merging and write amplification is a cost that we'd rather not pay.  It not only reduces the consistency of Angle's performance, but can cause issues with resource consumption as well.

As an example, we currently use a forked version of LevelDB because, by default, LevelDB might load up to 1000 files, via mmap, into a Angle process.  Having to figure this out _after_ a user experiences a confusing out-of-memory process crash is not fun for us or our users.  As well, integrating LevelDB into Angle, is suboptimal on two fronts: integrating a C/C++ dependency involves multiple crates and build script tweaks for ensuring builds work on different platforms, and marrying the synchronous design of LevelDB with the asynchronous design of Angle is tricky at best.

## Redesigned disk buffer implementation

In order to address these issues, and more, we've written a new disk buffer implementation that is better suited for Angle's specific needs.  At a high level, the new disk buffer implementation works more like an actual log -- files being written once, and read sequentially -- and not at all like a database. This means we perform no LevelDB-specific operations such as compaction, and in turn, we don't pay the additional cost of doing so.  Our design was built from the ground up to fit within Angle rather than having to be molded into something that would work.  This has enabled the new disk buffer to provide more consistent throughput and latency, as well as memory and CPU consumption.

## The road to a stable release

While we're excited to have you try out the new disk buffer for your own workloads, it is still a
**beta** feature: in general, there are no known issues, but you may encounter an issue that could cause data loss or
cause Angle to become unresponsive. We're working hard to continue testing and hardening the new
disk buffer implementation for a planned stable release in 0.21.

## Trying out the new disk buffer implementation today

With all of that said, we're interested in users trying out the new disk buffer implementation and
letting us know how it goes.  Switching your configuration to use it is easy, but first, there are a
few caveats you should know before using it:

- this is a beta release, which means data loss can and may occur
- existing buffer data is not automatically migrated

Given the constraints around trying out the new disk buffer implementation, users who already follow
a stateless deployment model (not updating Angle instances in place, basically) will likely find it
easiest to do.  We're planning work to allow Angle to automatically migrate buffers to the new
implementation as part of the stable release in 0.21, which should alleviate the pains of switching
for those who don't utilize a stateless deployment process as mentioned above.

With all of that said, changing Angle to use the new disk buffer implementation is as simple as
changing a single line:

```toml
# From this:
[sinks.http]
# ...
buffer.type = "disk"

# To this:
[sinks.http]
# ...
buffer.type = "disk_v2"
```

## Let us know what you think!

We're excited about the performance improvements to disk buffers, including future work to make them
go even _faster_.  If you have any feedback for us, whether it's related to the new disk buffers or
anything else, let us know on [Discord] or on [Twitter].

[leveldb]: https://github.com/google/leveldb
[Discord]: https://discord.com/invite/dX3bdkF
[Twitter]: https://twitter.com/khulnasoft
