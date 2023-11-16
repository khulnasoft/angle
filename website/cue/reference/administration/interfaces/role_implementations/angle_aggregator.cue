package metadata

administration: interfaces: [string]: role_implementations: _angle_aggregator: {
	variables: config: {
		sources: {
			angle: type:           components.sources.angle.type
			internal_metrics: type: components.sources.internal_metrics.type
		}
	}
	description: #"""
		The aggregator role is designed to receive and process data from multiple upstream agents.
		Those agents are typically other Angle instances but could also be non-Angle data sources.
		By default, we recommend the [`angle` source](\#(urls.angle_source)) since it supports all
		data types, but we recommend that you adjust your pipeline as necessary using Angle's
		[sources](\#(urls.angle_sources)), [transforms](\#(urls.angle_transforms)), and
		[sinks](\#(urls.angle_sinks)).
		"""#
	title:       "Aggregator"
}
