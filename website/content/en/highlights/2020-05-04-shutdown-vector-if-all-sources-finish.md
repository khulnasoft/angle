---
date: "2020-07-13"
title: "Angle gracefully exits when specific sources finish"
description: "One step closer to Angle replacing awk and sed!"
authors: ["hoverbear"]
hide_on_release_notes: false
pr_numbers: [2533]
release: "0.10.0"
badges:
  type: "enhancement"
  sources: ["stdin"]
---

We heard from some folks they were using Angle as a data processor in command line scripts!

**Good for you, UNIX hackers 👩‍💻!**

Now, in 0.10.0, you can use Angle in standard UNIX pipelines much easier!

```bash
banana@tree:/$ echo "awk, sed the Vic" | angle --config test.toml --quiet
{"host":"tree","message":"awk, sed the Vic","source_type":"stdin","timestamp":"2020-05-04T20:43:59.522211979Z"}
```

## Future Outlook

We've been exploring options for expanding `angle generate` to allow users to specify options from the command line. For example:

```bash
banana@tree:/$ angle generate stdin//console(encoding=json)
```

Once this happens, it seems inevitable we'll add something like this eventually:

```bash
banana@tree:/$ angle eval stdin//console(encoding=json)
```

Want to contribute? [Discussion here!][urls.angle_generate_arguments_issue]

[urls.angle_generate_arguments_issue]: https://github.com/khulnasoft/angle/issues/1966
