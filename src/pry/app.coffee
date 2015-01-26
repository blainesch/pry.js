SyncPrompt = require('./sync_prompt')
RemotePrompt = require('./sync_prompt')
Server = require('./server.coffee')
Output = require('./output/local_output')
commands = require('./commands')

class App

  _commands: []

  constructor: (@scope) ->

  local: ->
    @output = new Output()
    @prompt = new SyncPrompt(
      callback: @find_command
      typeahead: @typeahead
    )

  remote: ->
    @output = new RemoteOutput()
    server = new Server()
    @prompt = new RemotePrompt(
      server: server
      callback: @find_command
    )

  commands: ->
    if @_commands.length is 0
      @_commands.push new command({@output, @scope}) for i,command of commands
    @_commands

  typeahead: (input = '') =>
    items = []
    for command in @commands()
      items = items.concat(command.typeahead(input))
    if input
      items = items.filter (item) ->
        item.indexOf(input) is 0
    [items, input]

  find_command: (input, chain) =>
    for command in @commands()
      if match = command.match(input.trim())
        args = String(match[1]).trim().split(' ')
        return command.execute.call command, args, chain
    false

  open: ->
    @prompt.type('whereami')

module.exports = App
