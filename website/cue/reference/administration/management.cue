package metadata

// These CUE sources are the beginnings of an effort to re-architect some of the administration sources from a UI-first
// perspective.

administration: management: {
	#Interface: {
		#Command: {
			command?: string
			info?:    string
		}

		name:  string
		title: string | *name

		variables: {
			variants?: [string, ...string]

			config_formats: ["yaml", "toml", "json"]
		}

		manage?: {
			start?:   #Command
			stop?:    #Command
			reload?:  #Command
			restart?: #Command
			upgrade?: #Command
		}

		observe?: {
			logs?:    #Command
			metrics?: #Command
		}
	}

	#Interfaces: [Name=string]: #Interface & {name: Name}

	_interfaces: #Interfaces & {
		_systemd: {
			manage: {
				start: {
					command: "sudo systemctl start angle"
				}
				stop: {
					command: "sudo systemctl stop angle"
				}
				reload: {
					command: "systemctl kill -s HUP --kill-who=main angle.service"
				}
				restart: {
					command: "sudo systemctl restart angle"
				}
			}
		}

		apt: _systemd & {
			title: "APT"

			manage: {
				upgrade: {
					command: "sudo apt-get upgrade angle"
				}
			}

			observe: {
				logs: {
					info: """
						The Angle package from the APT repository installs Angle as a [systemd](\(urls.systemd))
						service. You can access Angle's logs using the [`journalctl`](\(urls.journalctl)) utility:

						```bash
						sudo journalctl -fu angle
						```
						"""
				}
			}
		}

		docker_cli: {
			title: "Docker CLI"

			variables: {
				variants: ["alpine", "debian", "distroless"]
			}

			manage: {
				start: {
					command: #"""
						docker run \
						  -d \
						  -v ~/angle.{config_format}:/etc/angle/angle.{config_format}:ro \
						  -p 8686:8686 \
						  timberio/angle:{version}-{variant}
						"""#
				}
				stop: {
					command: "docker stop timberio/angle"
				}
				reload: {
					command: "docker kill --signal=HUP timberio/angle"
				}
				restart: {
					command: "docker restart -f $(docker ps -aqf \"name=angle\")"
				}
			}

			observe: {
				logs: {
					info: """
						If you've started Angle with the `docker` CLI you can access Angle's logs using the
						`docker logs` command. First, find the Angle container ID:

						```bash
						docker ps | grep angle
						```

						Then copy Angle's container ID and use it to tail the logs:

						```bash
						docker logs -f <container-id>
						```

						If you started Angle with the [Docker Compose](\(urls.docker_compose)) CLI you can use this
						command to access Angle's logs:

						```bash
						docker-compose logs -f angle
						```

						Replace `angle` with the name of Angle's service if you've named it something else.
						"""
				}
			}
		}

		dpkg: _systemd & {
			observe: {
				logs: {
					info: """
						The Angle DEB package installs Angle as a Systemd service. Logs can be accessed using the
						`journalctl` utility:

						```bash
						sudo journalctl -fu angle
						```
						"""
				}
			}
		}

		homebrew: {
			title: "Homebrew"

			manage: {
				start: {
					command: "brew services start angle"
				}
				stop: {
					command: "brew services stop angle"
				}
				reload: {
					command: "killall -s SIGHUP angle"
				}
				restart: {
					command: "brew services restart angle"
				}
				upgrade: {
					command: "brew update && brew upgrade angle"
				}
			}

			observe: {
				logs: {
					info: """
						When Angle is started through [Homebrew](\(urls.homebrew)) the logs are automatically routed to
						`/usr/local/var/log/angle.log`. You can tail them using the `tail` utility:

						```bash
						tail -f /usr/local/var/log/angle.log
						```
						"""
				}
			}
		}

		msi: {
			title: "MSI"

			manage: {
				start: {
					command: #"""
						C:\Program Files\Angle\bin\angle \
						  --config C:\Program Files\Angle\config\angle.{config_format}
						"""#
				}
			}

			observe: {
				logs: {
					info: """
						The Angle MSI package doesn't install Angle into a process manager. Therefore, you need to
						start Angle by executing the Angle binary directly. Angle's logs are written to `STDOUT`. You
						are in charge of routing `STDOUT`, and this determines how you access Angle's logs.
						"""
				}
			}
		}

		nix: {
			title: "Nix"

			manage: {
				start: {
					command: "angle --config /etc/angle/angle.{config_format}"
				}

				reload: {
					command: "killall -s SIGHUP angle"
				}

				upgrade: {
					command: #"""
						nix-env \
						  --file https://github.com/NixOS/nixpkgs/archive/master.tar.gz \
						  --upgrade angle
						"""#
				}
			}

			observe: {
				logs: {
					info: """
						The Angle Nix package doesn't install Angle into a process manager. Therefore, Angle must be
						started by executing the Angle binary directly. Angle's logs are written to `STDOUT`. You are
						in charge of routing `STDOUT`, and this determines how you access Angle's logs.
						"""
				}
			}
		}

		rpm: _systemd & {
			title: "RPM"

			observe: {
				logs: {
					info: """
						The Angle RPM package installs Angle as a Systemd service.  You can access Angle's logs using
						the [`journalctl`](\(urls.journalctl)) utility:

						```bash
						sudo journalctl -fu angle
						```
						"""
				}
			}
		}

		angle_installer: {
			title: "Angle Installer"

			manage: {
				start: {
					command: "angle --config /etc/angle.{config_format}"
				}

				reload: {
					command: "killall -s SIGHUP angle"
				}
			}
		}

		yum: _systemd & {
			title: "YUM"

			manage: {
				upgrade: {
					command: "sudo yum upgrade angle"
				}
			}
		}
	}
}
