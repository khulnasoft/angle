---
title: VRL example reference
short: Examples
weight: 3
---

Here you'll find a comprehensive list of all VRL program examples. These
examples demonstrate the breadth of the language and its observability-focused
facilities.

## Try Using the VRL subcommand

You can run these examples using the `angle vrl` subcommand with `--input` (input is newline
delimited JSON file representing a list of events).  and `--program` (VRL program) to pass in the
example input and program as well as `--print-object` to show the modified object. The below
examples show pretty-printed JSON for the input events, so collapse these to single lines when
passing in via `--input`.

For example: `angle vrl --input input.json --program program.vrl --print-object`. This closely
matches how VRL will receive the input in a running Angle instance.

### VRL REPL

Additionally, if `angle vrl` is run without any arguments, it will spawn a **REPL**
(Read–eval–print loop).

Assuming you have Angle installed, you can run `angle vrl` to start the REPL.
From there, you can type `help` and press return to get further help.

The REPL behaves nearly identical to the programs you write for your Angle
configuration, and can be used to test individual snippets of complex programs
before you commit them to your production configuration.

The `angle vrl` command has many other capabilities, run the command using
`angle vrl --help` to see more information.

## Real world examples

{{< vrl/real-world-examples >}}

{{< vrl/examples >}}
