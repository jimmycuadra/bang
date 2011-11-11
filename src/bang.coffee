program = require "commander"
fs      = require "fs"
path    = require "path"

bang = process.env.HOME + "/.bang"
data = {}


exports = class Bang
  constructor: ->
    @data = @getData()

  start: (args = process.argv) ->
    program.version("0.0.1")
            .usage("[options] [key] [value]")
            .option("-d, --delete", "delete the specified key")
            .parse(args)

    [key, value] = program.args

    if key and program.delete
      remove key
    else if key and value
      set key, value
    else if key
      get key
    else
      console.log program.helpInformation()

  dataPath: process.env.HOME + "/.bang"

  getData: ->
    return @data if @data

    if path.existsSync @dataPath
      JSON.parse(fs.readFileSync @dataPath)
    else
      {}

  save: ->
    fs.writeFileSync @dataPath, JSON.stringify(@data)

  get: (key) ->
    console.log @data[key] if @data[key]

  set: (key, value) ->
    @data[key] = @data[value]
    save()

  remove: (key) ->
    delete @data[key]
    save()
