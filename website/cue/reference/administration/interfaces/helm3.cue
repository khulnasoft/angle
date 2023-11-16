package metadata

administration: interfaces: "helm3": {
	title:       "Helm 3"
	description: """
		[Helm](\(urls.helm)) is a package manager for Kubernetes that
		facilitates the deployment and management of applications and services
		on Kubernetes clusters.
		"""

	archs: ["x86_64", "ARM64"]

	paths: {
		bin:         null
		bin_in_path: null
		config:      null
	}

	package_manager_name: administration.package_managers.helm.name
	platform_name:        "kubernetes"

	role_implementations: [Name=string]: {
		commands: {
			_repo_name:                string | *"angle"
			_chart_name:               string
			_namespace:                string | *"angle"
			_release_name:             string | *"angle"
			_controller_resource_type: string
			_controller_resource_name: string | *_chart_name
			add_repo:                  #"helm repo add \#(_repo_name) https://helm.angle.khulnasoft.com/"#
			helm_values_show:          #"helm show values \#(_repo_name)/\#(_chart_name)"#
			configure: #"""
				cat <<-'VALUES' > values.yaml
				# The Angle Kubernetes integration automatically defines a
				# kubernetes_logs source that is made available to you.
				# You do not need to define a log source.
				sinks:
				  # Adjust as necessary. By default we use the console sink
				  # to print all data. This allows you to see Angle working.
				  # https://angle.khulnasoft.com/docs/reference/sinks/
				  stdout:
				    type: console
				    inputs: ["kubernetes_logs"]
				    target: "stdout"
				    encoding: "json"
				VALUES
				"""#
			install:   #"helm install --namespace \#(_namespace) --create-namespace \#(_release_name) \#(_repo_name)/\#(_chart_name) --values values.yaml"#
			logs:      #"kubectl logs --namespace \#(_namespace) \#(_controller_resource_type)/\#(_controller_resource_name)"#
			reload:    null
			restart:   #"kubectl rollout restart --namespace \#(_namespace) \#(_controller_resource_type)/\#(_controller_resource_name)"#
			start:     null
			stop:      null
			top:       null
			uninstall: #"helm uninstall --namespace \#(_namespace) \#(_release_name)"#
			upgrade:   #"helm repo update && helm upgrade --namespace \#(_namespace) \#(_release_name) \#(_repo_name)/\#(_chart_name) --reuse-values"#
		}
	}

	role_implementations: {
		agent: {
			title:       "Agent"
			description: #"""
						The agent role is designed to collect all Kubernetes
						log data on each Node. Angle runs as a
						[DaemonSet](\#(urls.kubernetes_daemonset)) and tails
						logs for the entire Pod, automatically enriching them
						with Kubernetes metadata via the
						[Kubernetes API](\#(urls.kubernetes_api)). Collection
						is handled automatically, and it is intended for you to
						adjust your pipeline as	necessary using Angle's
						[sources](\#(urls.angle_sources)),
						[transforms](\#(urls.angle_transforms)), and
						[sinks](\#(urls.angle_sinks)).
						"""#

			commands: {
				_chart_name:               "angle-agent"
				_controller_resource_type: "daemonset"
			}
			tutorials: installation: [
				{
					title:   "Add the Angle repo"
					command: commands.add_repo
				},
				{
					title:   "Check available Helm chart configuration options"
					command: commands.helm_values_show
				},
				{
					title:   "Configure Angle"
					command: commands.configure
				},
				{
					title:   "Install Angle"
					command: commands.install
				},
			]
			variables: config: sinks: out: inputs: ["kubernetes_logs"]
		}

		// aggregator: {
		//  title:       "Aggregator"
		//  description: #"""
		//      The aggregator role is designed to receive and
		//      process data from multiple upstream agents.
		//      Typically these are other Angle agents, but it
		//      could be anything, including non-Angle agents.
		//      By default, we recommend the [`angle` source](\#(urls.angle_source))
		//      since it supports all data types, but it is
		//      recommended to adjust your pipeline as necessary
		//      using Angle's [sources](\#(urls.angle_sources)),
		//      [transforms](\#(urls.angle_transforms)), and
		//      [sinks](\#(urls.angle_sinks)).
		//      """#

		//  commands: {
		//   _chart_name:               "angle-aggregator"
		//   _controller_resource_type: "statefulset"
		//  }
		//  tutorials: installation: [
		//   {
		//    title:   "Add the Angle repo"
		//    command: commands.add_repo
		//   },
		//   {
		//    title: "Configure Angle"
		//    command: commands.configure
		//   },
		//   {
		//    title:   "Install Angle"
		//    command: commands.install
		//   },
		//  ]
		//  variables: config: sources: in: type: "angle"
		// }
	}
}
