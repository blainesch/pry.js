net = require("net")
chalk = require("chalk")
deasync = require("deasync")

done = false
chalk.enabled = true

server = net.createServer (socket) ->
  history = []
  console.log "server connected", socket.remoteAddress
  socket.on "end", ->
    console.log "server disconnected"
    done = true

  socket.on "data", (data) ->
    socket.write JSON.stringify(output: chalk.red("I am blue")) + "\u0000"
    true

  socket.pipe socket

server.listen 8124, ->
  console.log "server bound"

deasync.runLoopOnce() until done
server.close()
