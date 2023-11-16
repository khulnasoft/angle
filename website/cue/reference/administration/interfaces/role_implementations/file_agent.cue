package metadata

administration: interfaces: [string]: role_implementations: _file_agent: {
	variables: config: {
		sources: {
			logs: {
				type:    components.sources.file.type
				include: [string, ...string] | *["/var/log/**/*.log"]
			}
			host_metrics: type:     components.sources.host_metrics.type
			internal_metrics: type: components.sources.internal_metrics.type
		}
	}
	description: #"""
		The agent role is designed to collect all data on a single host. Angle runs as a background
		process and interfaces with a host-level APIs for data collection. By default, Angle
		collects logs via Angle's [`file` source](\#(urls.angle_journald_source)) and metrics via
		the [`host_metrics` source](\#(urls.angle_host_metrics_source)), but we recommend that you
		adjust your pipeline as necessary using Angle's [sources](\#(urls.angle_sources)),
		[transforms](\#(urls.angle_transforms)), and [sinks](\#(urls.angle_sinks)).
		"""#
	title:       "Agent"
}
