deasync = require('deasync')

class RemotePrompt

  done: true

  constructor: ({@server, @callback, @format}) ->
    @cli.on 'value', (input) =>
      @callback input.join(' '), @chain()

  chain: ->
    {next: @open, stop: @close}

  open: =>
    @done = false
    @server.open()
    deasync.runLoopOnce() until @done

  type: (input) ->
    @cli.emit 'value', input.split(' ')

  close: =>
    @cli.readline.close()
    @done = true

module.exports = RemotePrompt
