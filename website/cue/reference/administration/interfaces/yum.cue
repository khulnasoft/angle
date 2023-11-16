package metadata

administration: interfaces: yum: {
	title:       "YUM"
	description: """
		The [Yellowdog Updater](\(urls.yum)), Modified (YUM) is a free and
		open-source command-line package-manager for Linux operating system
		using the RPM Package Manager.

		Our Yum repositories are provided by
		[Cloudsmith](\(urls.cloudsmith)) and you
		can find [instructions for manually adding
		the repositories](\(urls.cloudsmith_yum)).
		"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	package_manager_name: administration.package_managers.yum.name
	paths: {
		bin:         "/usr/bin/angle"
		bin_in_path: true
		config:      "/etc/angle/angle.{config_format}"
	}

	role_implementations: [Name=string]: {
		commands: role_implementations._systemd_commands & {
			add_repo: #"""
				curl -1sLf \
					'https://repositories.timber.io/public/angle/cfg/setup/bash.rpm.sh' \
					| sudo -E bash
				"""#
			install:   "sudo yum install angle"
			uninstall: "sudo yum remove angle"
			upgrade:   "sudo yum upgrade angle"
		}

		tutorials: {
			installation: [
				{
					title:   "Add the Angle repo"
					command: commands.add_repo
				},
				{
					title:   "Install Angle"
					command: commands.install
				},
				{
					title:   "Configure Angle"
					command: commands.configure
				},
				{
					title:   "Restart Angle"
					command: commands.restart
				},
			]
		}
	}

	role_implementations: {
		agent:      role_implementations._journald_agent
		aggregator: role_implementations._angle_aggregator
	}
}
