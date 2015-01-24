App = require('./pry/app')

class Pry

  constructor: ->
    @it = "(#{@_pry_local.toString()}).call(this)"

  _pry_local: ->
    pry.open_local ((input) -> eval(input)).bind(@)

  open_local: (scope) ->
    app = new App(scope)
    app.local()
    app.open()

  _pry_remote: ->
    pry.open ((input) -> eval(input)).bind(@)

  open_remote: (scope) ->
    app = new App(scope)
    app.remote()
    app.open()

module.exports = new Pry
