program = require "commander"
fs      = require "fs"
path    = require "path"

module.exports = class Bang
  constructor: ->
    @data = @getData()

  start: (args) ->
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
      if Object.keys(@data).length is 0
        @log program.helpInformation()
      else
        @list()

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

  list: ->
    amount = 0

    for key of @data
      amount = key.length if key.length > amount

    for key of @data
      @log "#{@pad(key, amount)}#{key}: #{@data[key]}"

  pad: (item, amount) ->
    out = ""
    i = amount - item.length

    while i > 0
      out += " "
      i--

    out
