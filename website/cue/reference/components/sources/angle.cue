package metadata

components: sources: angle: {
	_port: 9000

	title: "Angle"

	description: """
		Receives data from another upstream Angle instance using the Angle sink.
		"""

	classes: {
		commonly_used: false
		delivery:      "at_least_once"
		deployment_roles: ["aggregator"]
		development:   "stable"
		egress_method: "stream"
		stateful:      false
	}

	features: {
		auto_generated:   true
		acknowledgements: true
		multiline: enabled: false
		receive: {
			from: {
				service: services.angle

				interface: socket: {
					direction: "incoming"
					port:      _port
					protocols: ["http"]
					ssl: "optional"
				}
			}
			receive_buffer_bytes: enabled: false
			keepalive: enabled:            true
			tls: {
				enabled:                true
				can_verify_certificate: true
				enabled_default:        false
			}
		}
	}

	support: {
		requirements: []
		warnings: []
		notices: []
	}

	installation: {
		platform_name: null
	}

	configuration: base.components.sources.angle.configuration

	output: {
		logs: event: {
			description: "A Angle event"
			fields: {
				source_type: {
					description: "The name of the source type."
					required:    true
					type: string: {
						examples: ["angle"]
					}
				}
				"*": {
					description: "Angle transparently forwards data from another upstream Angle instance. The `angle` source will not modify or add fields."
					required:    true
					type: "*": {}
				}
			}
		}
		metrics: {
			_extra_tags: {
				"source_type": {
					description: "The name of the source type."
					examples: ["angle"]
					required: true
				}
			}
			counter: output._passthrough_counter & {
				tags: _extra_tags
			}
			distribution: output._passthrough_distribution & {
				tags: _extra_tags
			}
			gauge: output._passthrough_gauge & {
				tags: _extra_tags
			}
			histogram: output._passthrough_histogram & {
				tags: _extra_tags
			}
			set: output._passthrough_set & {
				tags: _extra_tags
			}
		}
	}

	telemetry: metrics: {
		grpc_server_handler_duration_seconds: components.sources.internal_metrics.output.metrics.grpc_server_handler_duration_seconds
		grpc_server_messages_received_total:  components.sources.internal_metrics.output.metrics.grpc_server_messages_received_total
		grpc_server_messages_sent_total:      components.sources.internal_metrics.output.metrics.grpc_server_messages_sent_total
		protobuf_decode_errors_total:         components.sources.internal_metrics.output.metrics.protobuf_decode_errors_total
	}
}
