#!/usr/bin/env coffee

net = require("net")
chalk = require("chalk")
deasync = require("deasync")

chalk.enabled = true

class Server

  server: null

  data: null

  constructor: ->

    @server = net.createServer (socket) =>

      socket.on "end", =>
        console.log "server disconnected"
        @data = 'kill'
        @server.close()

      socket.on "data", (@data) =>

      socket.pipe socket

    @server.listen 8124, ->
      console.log "server bound"

  open: ->
    @data = null
    deasync.runLoopOnce() until @data

module.exports = Server
