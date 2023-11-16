package metadata

administration: interfaces: apt: {
	title:       "Apt"
	description: """
		[Advanced Package Tool](\(urls.apt)), or APT, is a free package manager that handles the
		installation and removal of software on [Debian](\(urls.debian)), [Ubuntu](\(urls.ubuntu)),
		and other Linux distributions.

		Our APT repositories are provided by [Cloudsmith](\(urls.cloudsmith)). We recommend
		consulting the official instructions for [manually adding
		repositories](\(urls.cloudsmith_apt)).
		"""

	archs: ["x86_64", "ARM64", "ARMv7"]
	package_manager_name: administration.package_managers.apt.name
	paths: {
		bin:         "/usr/bin/angle"
		bin_in_path: true
		config:      "/etc/angle/angle.{config_format}"
	}

	role_implementations: [string]: {
		commands: role_implementations._systemd_commands & {
			add_repo:
				#"""
					# One of the following:

					# Use repository installation script
					curl -1sLf \
					  'https://repositories.timber.io/public/angle/cfg/setup/bash.deb.sh' \
					  | sudo -E bash

					# Use extrepo
					sudo apt install extrepo
					sudo extrepo enable angle
					"""#
			install:   "sudo apt-get install angle"
			uninstall: "sudo apt remove angle"
			upgrade:   "sudo apt-get upgrade angle"
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
		variables: {}
	}

	role_implementations: {
		agent:      role_implementations._journald_agent
		aggregator: role_implementations._angle_aggregator
	}
}
