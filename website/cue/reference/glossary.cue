package metadata

#Term: {
	term:        !=""
	description: !=""
}

#Glossary: [#Term, ...#Term]

glossary: #Glossary & [
		{
		term:        "Batch"
		description: """
			A [batched payload](\(urls.angle_log)) within a [sink](#sink). It is a batch of events
			encoded into a payload that the downstream service understands.
			"""
	},
	{
		term:        "Benchmark"
		description: """
			A test designed to measure performance and resource usage. You can learn more about
			Angle's benchmarks in the Angle repo's [main README](\(urls.angle_readme)).
			"""
	},
	{
		term:        "Binary"
		description: "The static binary that Angle compiles to."
	},
	{
		term: "Buffer"
		description: """
			An ordered queue of events that's coupled with a [sink](#sink).
			"""
	},
	{
		term: "Component"
		description: """
			An umbrella term encompassing Angle [sources](#source), [transforms](#transform), and
			[sinks](#sink). Angle components can be assembled together into a Angle
			[pipeline](#pipeline) for processing observability data in a flexible and configurable
			way.
			"""
	},
	{
		term:        "Configuration"
		description: """
			The settings and options used to control Angle's behavior. You can learn more about
			Angle's configuration on the [Configuration](\(urls.angle_configuration)) page.
			"""
	},
	{
		term: "Durability"
		description: """
			The ability to retain data across exceptional events. In the context of Angle, this
			typically refers to the ability to retain data across restarts.
			"""
	},
	{
		term:        "Enrichment tables"
		description: """
			File-based information that you can use to enrich Angle [events](#event) in
			[`remap`](\(urls.angle_remap_transform)) transforms. [VRL](\(urls.vrl_reference))
			provides two functions for using enrichment tables:

			* [`find_enrichment_table_records`](\(urls.vrl_functions)/#find_enrichment_table_records)
			* [`get_enrichment_table_record`](\(urls.vrl_functions)/#get_enrichment_table_record)
			"""
	},
	{
		term:        "Event"
		description: """
			A single unit of data that flows through Angle. You can learn more about events on the
			[Data model](\(urls.angle_data_model)) page.
			"""
	},
	{
		term: "Filter"
		description: """
			A type of [transform](#transform) that filters events or fields on an event.
			"""
	},
	{
		term: "Flush"
		description: #"""
			The act of sending a batched payload to a downstream service. This is commonly used in
			conjunction with [buffering](#buffer).
			"""#
	},
	{
		term:        "GitHub"
		description: "The service used to host Angle's source code."
	},
	{
		term:        "Guide"
		description: """
			A tutorial or walkthrough of a specific subject. You can see Angle’s guides in the
			[Guides](\(urls.angle_guides)) section.
			"""
	},
	{
		term: "Log"
		description: """
			An individual log event. Logs are one of the core Angle [event types](#event),
			alongside [metrics](#metric).
			"""
	},
	{
		term: "Metric"
		description: """
			An individual data unit representing a point-in-time measurement. Metrics are one of the
			core Angle [event types](#event), alongside [logs](#log).
			"""
	},
	{
		term:        "Parser"
		description: "A [transform](#transform) that parses [event](#event) data."
	},
	{
		term: "Pipeline"
		description: """
			The end result of combining [sources](#source), [transforms](#transform), and
			[sinks](#sink).
			"""
	},
	{
		term: "Reducer"
		description: """
			A [transform](#transform) that reduces data into a [metric](#metric).
			"""
	},
	{
		term:        "Repo"
		description: """
			A Git repository, usually the [Angle Git repository](\(urls.angle_repo)).
			"""
	},
	{
		term:        "Role"
		description: """
			A capacity in which Angle is deployed. For more, see the listing of available
			[roles](\(urls.angle_roles)) for Angle.
			"""
	},
	{
		term: "Router"
		description: """
			Something that accepts and routes data to many destinations. Angle is commonly referred
			to as a router.
			"""
	},
	{
		term:        "Rust"
		description: """
			The [Rust programming language](\(urls.rust)). Angle is written exclusively in Rust and
			takes heavy advantage of Rust's core features, such as memory efficiency and memory
			safety.
			"""
	},
	{
		term: "Sample"
		description: """
			A [transform](#transform) that samples data (i.e. retains only a subset of a stream
			based on inclusion criteria).
			"""
	},
	{
		term:        "Sink"
		description: """
			One of the core [component](#component) types in Angle, **sinks** deliver observability
			to a variety of [available destinations](\(urls.angle_sinks)). Sinks are the terminus
			points for Angle [pipelines](#pipeline).
			"""
	},
	{
		term:        "Source"
		description: """
			One of the core [component](#component) types in Angle, **sources** take in
			observability data from a wide range of [available targets](\(urls.angle_sources)).
			Sources are the entry points for Angle [pipelines](#pipeline).
			"""
	},
	{
		term: "Structured log"
		description: """
			A [log](#log) represented in a structured form, such as a map. Structured logs are
			distinguished from *text* logs, which are represented as a single text string.
			"""
	},
	{
		term:        "Table"
		description: """
			The [TOML table type](\(urls.toml_table)), which is a collection of key/value pairs
			directly akin to data types like dicts (Python), objects (JavaScript), and hashes
			(Ruby).
			"""
	},
	{
		term:        "Topology"
		description: """
			A [deployment topology](\(urls.angle_topologies)) under which Angle is deployed.
			"""
	},
	{
		term: "Transform"
		description: """
			One of the core [component](#component) types in Angle, **transforms** perform some
			kind of action upon [events](#event) flowing through Angle [pipelines](#pipeline),
			such as [sampling](#sample), [filtering](#filter), or
			[modifying](#angle-remap-language) events.
			"""
	},
	{
		term:        "Angle Remap Language"
		description: """
			An expression-oriented domain-specific language (DSL) that you can use to modify
			observability data in Angle and also for other tasks, such as specifying Boolean
			conditions for [filtering](#filter) and [routing](\(urls.angle_route_transform))
			events. Also known as **VRL** for short.

			For more information, see the [`remap` transform](\(urls.angle_remap_transform)),
			the [announcement blog post](\(urls.vrl_announcement)), the [VRL
			overview](\(urls.vrl_reference)), the comprehensive listing of [VRL
			functions](\(urls.vrl_functions)), [errors](\(urls.vrl_errors_reference)), and
			[examples](\(urls.vrl_examples)), and the overview of [VRL
			expressions](\(urls.vrl_expressions)).
			"""
	},
]
