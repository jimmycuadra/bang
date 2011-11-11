program = require "commander"
fs      = require "fs"
path    = require "path"

module.exports = class Bang
  constructor: ->
    @data = @getData()

  start: (args = process.argv) ->
    program.version("0.0.1")
            .usage("[options] [key] [value]")
            .option("-d, --delete", "delete the specified key")
            .parse(args)

    [key, value] = program.args

    if key and program.delete
      @remove key
    else if key and value
      @set key, value
    else if key
      @get key
    else
      @log program.helpInformation()

  dataPath: process.env.HOME + "/.bang"

  getData: ->
    return @data if @data

    if path.existsSync @dataPath
      JSON.parse(fs.readFileSync @dataPath)
    else
      {}

  log: (args...) ->
    console.log args...

  save: ->
    fs.writeFileSync @dataPath, JSON.stringify(@data)

  get: (key) ->
    @log @data[key] if @data[key]

  set: (key, value) ->
    @data[key] = value
    @save()

  remove: (key) ->
    delete @data[key]
    @save()
