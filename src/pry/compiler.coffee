coffee = require('coffee-script')
pry = require('../pry')

class Compiler

  mode_id: 0

  modes: ['js', 'coffee']

  constructor: ({@scope, isCoffee}) ->
    @mode_id = 1 if isCoffee

  mode: ->
    @modes[@mode_id]

  toggle_mode: ->
    @mode_id = (@mode_id + 1) % @modes.length

  execute: (code, language = @modes[@mode_id]) ->
    @["execute_#{language}"](code)

  execute_coffee: (code) ->
    linesOfJs = coffee.compile(code, bare: true).split("\n")
    @execute_js(linesOfJs.filter((l) -> l.length > 0 and l.trim()[0..2] isnt 'var').join("\n"))

  execute_js: (code) ->
    @scope(code)

module.exports = Compiler
