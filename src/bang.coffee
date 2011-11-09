program = require "commander"

get = ->

set = ->

remove = ->

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
