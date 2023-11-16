package metadata

administration: interfaces: nix: {
	title:       "Nix"
	description: """
				[Nix](\(urls.nix)) is a cross-platform package manager
				implemented on a functional deployment model where software is
				installed into unique directories generated through
				cryptographic hashes, it is also the name of the programming
				language.
				"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	package_manager_name: administration.package_managers.nix.name

	paths: {
		bin:         "/usr/bin/angle"
		bin_in_path: true
		config:      "/etc/angle/angle.{config_format}"
	}

	role_implementations: [Name=string]: {
		commands: {
			install:   "nix-env --file https://github.com/NixOS/nixpkgs/archive/master.tar.gz --install --attr angle"
			logs:      null
			reload:    "killall -s SIGHUP angle"
			restart:   null
			start:     #"angle --config \#(paths.config)"#
			stop:      null
			uninstall: "nix-env --uninstall angle"
			upgrade:   "nix-env --file https://github.com/NixOS/nixpkgs/archive/master.tar.gz --upgrade angle"
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
		agent:      role_implementations._journald_agent
		aggregator: role_implementations._angle_aggregator
	}
}
