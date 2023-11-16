// One-liner installation commands. Currently displayed only on the main page.
package metadata

#Command: {
	title:   string
	command: string
}

administration: {
	install_commands: [#Command, ...#Command] & [
				{
			title:   "For humans"
			command: "curl --proto '=https' --tlsv1.2 -sSfL https://sh.angle.khulnasoft.com | bash"
		},
		{
			title:   "For machines"
			command: "curl --proto '=https' --tlsv1.2 -sSfL https://sh.angle.khulnasoft.com | bash -s -- -y"
		},
	]
}
