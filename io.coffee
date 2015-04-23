readline = require 'readline'
nx = require './nexus'

readline_interface = readline.createInterface
	input: process.stdin
	output: process.stdout


IO = (read, output, input) ->
	cell = new nx.Cell
	cell['<-'] [read, output], (read, output) ->
		if read
			readline_interface.question output, (line) ->
				input.value = line
		else
			do readline_interface.close
			console.log output

module.exports = IO
