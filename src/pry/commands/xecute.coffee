Command = require('../command')
Range = require('../range')
Compiler = require('../compiler')

class Xecute extends Command

  name: ''

  last_error: null

  args: new Range(1, Infinity)

  constructor: ->
    super
    isCoffee = @find_file().name?.slice(-6) is 'coffee'
    @compiler = new Compiler({@scope, isCoffee})

  execute: (input, chain) ->
    return @switch_mode(chain) if input[0] == 'mode'
    @execute_code input.join(' ')
    chain.next()

  execute_code: (code, language = null) ->
    try
      @output.send @compiler.execute(code, language)
    catch err
      @last_error = err
      @output.send err

  switch_mode: (chain) ->
    @compiler.toggle_mode()
    @output.send "Switched mode to '#{@compiler.mode()}'."
    chain.next()

  # Should always fallback to this
  match: (input) ->
    [input, input]

module.exports = Xecute
