{Command} = require "commander"
fs      = require "fs"
path    = require "path"
{exec}  = require "child_process"
os      = require "os"

module.exports = class Bang
  constructor: ->
    @data = @getData()

  start: (args) ->
    program = new Command

    program.version("0.1.0")
            .usage("[options] [key] [value]")
            .option("-d, --delete", "delete the specified key")
            .parse(args)

    [key, value] = program.args

    if key and program.delete
      @delete key
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
    value = @data[key]
    return unless value
    @copy value
    @log value

  set: (key, value) ->
    @data[key] = value
    @save()

  delete: (key) ->
    delete @data[key]
    @save()

  list: ->
    amount = 0

    for key of @data
      amount = key.length if key.length > amount

    for key of @data
      @log "#{@pad(key, amount)}#{key}: #{@data[key]}"

  copy: (value) ->
    copyCommand = if os.type().match /darwin/i then "pbcopy" else "xclip -selection clipboard"
    exec "printf '#{value.replace(/\'/g, "\\'")}' | #{copyCommand}", (error, stdout, stderr) ->
      throw error if error

  pad: (item, amount) ->
    out = ""
    i = amount - item.length

    while i > 0
      out += " "
      i--

    out
