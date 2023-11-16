package metadata

components: sinks: angle: {
	_port: 6000

	title: "Angle"

	description: """
		Sends data to another downstream Angle instance via the Angle source.
		"""

	classes: {
		commonly_used: false
		delivery:      "best_effort"
		development:   "stable"
		egress_method: "batch"
		service_providers: []
		stateful: false
	}
	features: {
		acknowledgements: true
		auto_generated:   true
		healthcheck: enabled: true
		send: {
			batch: {
				enabled:      true
				common:       false
				max_bytes:    10_000_000
				timeout_secs: 1.0
			}
			compression: enabled: false
			encoding: enabled:    false
			request: {
				enabled: true
				headers: false
			}

			tls: {
				enabled:                true
				can_verify_certificate: true
				can_verify_hostname:    true
				enabled_default:        false
				enabled_by_scheme:      false // sink allows both scheme or `enabled` to be used
			}
			to: {
				service: services.angle

				interface: {
					socket: {
						direction: "outgoing"
						protocols: ["http"]
						ssl: "optional"
					}
				}
			}
		}
	}

	support: {
		requirements: []
		warnings: []
		notices: []
	}

	input: {
		logs: true
		metrics: {
			counter:      true
			distribution: true
			gauge:        true
			histogram:    true
			summary:      true
			set:          true
		}
		traces: true
	}

	configuration: base.components.sinks.angle.configuration

	how_it_works: components.sources.angle.how_it_works

	telemetry: metrics: {
		protobuf_decode_errors_total: components.sources.internal_metrics.output.metrics.protobuf_decode_errors_total
	}
}
