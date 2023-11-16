package metadata

administration: interfaces: rpm: {
	title:       "RPM"
	description: """
		[RPM Package Manager](\(urls.rpm)) is a free and open-source package
		management system for installing and managing software on Fedora, CentOS,
		OpenSUSE, OpenMandriva, Red Hat Enterprise Linux, and other
		related Linux-based systems.
		"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	package_manager_name: administration.package_managers.rpm.name
	paths: {
		bin:         "/usr/bin/angle"
		bin_in_path: true
		config:      "/etc/angle/angle.{config_format}"
	}

	role_implementations: [Name=string]: {
		commands: role_implementations._systemd_commands & {
			install:   "sudo rpm -i https://packages.timber.io/angle/{version}/angle-{version}-1.{arch}.rpm"
			uninstall: "sudo rpm -e angle"
			upgrade:   null
		}

		tutorials: {
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
			arch: ["x86_64", "aarch64", "armv7"]
			version: true
		}
	}

	role_implementations: {
		agent:      role_implementations._journald_agent
		aggregator: role_implementations._angle_aggregator
	}
}
