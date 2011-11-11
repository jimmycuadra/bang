program = require "commander"
fs      = require "fs"
path    = require "path"

bang = process.env.HOME + "/.bang"
data = {}

if path.existsSync bang
  data = JSON.parse(fs.readFileSync bang)

save = ->
  fs.writeFileSync bang, JSON.stringify(data)

get = (key) ->
  console.log data[key] if data[key]

set = (key, value) ->
  data[key] = value
  save()

remove = ->
  delete data[key] if data[key]
  save()

exports.start = ->
  program.version("0.0.1")
          .usage("[options] [key] [value]")
          .option("-d, --delete", "delete the specified key")
          .parse(process.argv)

  [key, value] = program.args

  if key and program.delete
    remove key
  else if key and value
    set key, value
  else if key
    get key
  else
    console.log program.helpInformation()
