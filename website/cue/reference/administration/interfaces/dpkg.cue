package metadata

administration: interfaces: dpkg: {
	title:       "DPKG"
	description: """
		[Dpkg](\(urls.dpkg)) is the software that powers the package management
		system in the Debian operating system and its derivatives. Dpkg is used
		to install and manage software via `.deb` packages.
		"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	package_manager_name: administration.package_managers.dpkg.name

	paths: {
		bin:         "/usr/bin/angle"
		bin_in_path: true
		config:      "/etc/angle/angle.{config_format}"
	}

	role_implementations: [Name=string]: {
		commands: role_implementations._systemd_commands & {
			install: #"""
				curl --proto '=https' --tlsv1.2 -O https://packages.timber.io/angle/{version}/angle_{version}-1_{arch}.deb && \
					sudo dpkg -i angle_{version}-1_{arch}.deb
				"""#
			uninstall: "sudo dpkg -r angle"
			upgrade:   null
		}
		tutorials: {
			_commands: _
			installation: [
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
		variables: {
			arch: ["amd64", "arm64", "armhf"]
			version: true
		}
	}

	role_implementations: {
		agent:      role_implementations._journald_agent
		aggregator: role_implementations._angle_aggregator
	}
}
