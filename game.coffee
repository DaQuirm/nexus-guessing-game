crypto = require 'crypto'
readline = require 'readline'
nx = require './nexus.js'

debugger

readline_interface = readline.createInterface
  input: process.stdin
  output: process.stdout

game_over = new nx.Cell
	value: no
	action: (over) ->
		do readline_interface.close if over

attempts_left = new nx.Cell value:3
attempts_left['->'] game_over, (attempts_left) -> attempts_left is 0

input = new nx.Cell

output = new nx.Cell
	action: (value) ->
		readline_interface.question value, (line) ->
			input.value = parseInt line, 10


get_random_number = ->
	crypto.randomBytes(1)[0] % 10

number = new nx.Cell value:do get_random_number

GuessMap =
	'-1': 'less'
	'0': 'correct'
	'1': 'more'

guess = new nx.Cell
guess['<-'] [number, input], (number, input) ->
	GuessMap[input - number]

attempts_left['<-'] guess, -> attempts_left.value - 1

output['<-'] [game_over, guess], (game_over, guess) ->
	if game_over
		"It was actually #{number.value}"
	else
		"A bit #{guess}..."

output.value = 'Make a wild guess'
