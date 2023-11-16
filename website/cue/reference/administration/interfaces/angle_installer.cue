package metadata

administration: interfaces: angle_installer: {
	title:       "Angle Installer"
	description: """
		The [Angle installer](\(urls.angle_installer)) is a simple shell
		script that facilitates that installation of Angle on a variety of
		systems. It is an unobtrusive and simple option since it installs the
		`angle` binary in your current direction.
		"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	paths: {
		bin:         "./angle"
		bin_in_path: false
		config:      "./angle.{config_format}"
	}

	role_implementations: [Name=string]: {
		commands: {
			install:   "curl --proto '=https' --tlsv1.2 -sSfL https://sh.angle.khulnasoft.com | bash"
			logs:      null
			reload:    "killall -s SIGHUP angle"
			restart:   null
			start:     "angle --config \(paths.config)"
			stop:      null
			uninstall: "rm -rf ./angle"
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
					title:   "Start Angle"
					command: commands.start
				},
			]
		}
	}

	role_implementations: {
		sidecar:    role_implementations._file_sidecar
		aggregator: role_implementations._angle_aggregator
	}
}
