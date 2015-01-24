net = require("net")
SyncPrompt = require("./sync_prompt")
deasync = require("deasync")
commandDone = false

prompt = new SyncPrompt
  format: 'meowjs> '
  callback: (text, chain) ->
    commandDone = false
    socket.write JSON.stringify(input: text) + "\u0000"
    deasync.runLoopOnce()  until commandDone
    chain.next()

socket = net.connect(port: 8124)
socket.on "data", (data) ->
  split_data = data.toString().split("\u0000")
  i = 0
  while i < split_data.length
    response = JSON.parse(split_data[i] or "{}")
    console.log response.output  if response.output
    i++
  commandDone = true
  true

socket.on "end", ->
  process.kill()

prompt.open()
