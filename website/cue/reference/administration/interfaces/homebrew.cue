package metadata

administration: interfaces: homebrew: {
	title:       "Homebrew"
	description: """
		[Homebrew](\(urls.homebrew)) is a free and open-source package
		management system that manage software installation and management for
		Apple's macOS operating system and other supported Linux systems.
		"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	package_manager_name: administration.package_managers.homebrew.name

	paths: {
		bin:         "/usr/local/bin/angle"
		bin_in_path: true
		config:      "/etc/angle/angle.{config_format}"
	}

	role_implementations: [Name=string]: {
		commands: {
			install:   "brew tap khulnasoft/brew && brew install angle"
			logs:      "tail -f /usr/local/var/log/angle.log"
			reload:    "killall -s SIGHUP angle"
			restart:   "brew services restart angle"
			start:     "brew services start angle"
			stop:      "brew services stop angle"
			uninstall: "brew remove angle"
			upgrade:   "brew update && brew upgrade angle"
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
	}

	role_implementations: {
		agent:      role_implementations._file_agent
		aggregator: role_implementations._angle_aggregator
	}
}
