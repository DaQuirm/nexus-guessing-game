crypto = require 'crypto'
nx = require './nexus'
IO = require './io'

input = new nx.Cell
output = new nx.Cell
read = new nx.Cell value:yes
IO read, output, input

game_over = new nx.Cell value:no
game_over['->'] read, (over) -> not over

attempts_left = new nx.Cell value:3
attempts_left['->'] game_over, (attempts_left) -> attempts_left is 0

get_random_number = ->
	crypto.randomBytes(1)[0] % 10
number = new nx.Cell value:do get_random_number

GuessMap =
	'-1': 'more'
	'0': 'correct'
	'1': 'moar'

guess = new nx.Cell
guess['<-'] [number, input], (number, input) ->
	GuessMap[Math.sign(number - parseInt(input, 10))]

guess['->'] attempts_left, -> attempts_left.value - 1

output['<-'] guess, (guess) ->
	if game_over.value
		"It was actually #{number.value}\n"
	else if guess is 'correct'
		"Correct! It's really #{number.value}\n"
	else
		"A bit #{guess}...\n"

output.value = 'Make a wild guess\n'
