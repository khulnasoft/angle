package metadata

administration: interfaces: [string]: role_implementations: _file_sidecar: {
	variables: config: {
		sources: {
			logs: {
				type:    components.sources.file.type
				include: [string, ...string] | *["/var/log/my-app*.log"]
			}
			host_metrics: type:     components.sources.host_metrics.type
			internal_metrics: type: components.sources.internal_metrics.type
		}
	}
	description: #"""
		The sidecar role is designed to collect data from a single process on the same host. By
		default, we recommend using the [`file` source](\#(urls.angle_file_source)) to tail the
		logs for that individual process, but you could use the [`stdin`
		source](\#(urls.angle_stdin_source)), [`socket` source](\#(urls.angle_socket_source)), or
		[`http` source](\#(urls.angle_http_source)). We recommend adjusting your pipeline as
		necessary using Angle's [sources](\#(urls.angle_sources)),
		[transforms](\#(urls.angle_transforms)), and [sinks](\#(urls.angle_sinks)).
		"""#
	title:       "Sidecar"
}
