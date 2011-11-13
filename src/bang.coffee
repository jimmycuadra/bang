{Command} = require "commander"
fs      = require "fs"
path    = require "path"
{exec}  = require "child_process"

# [Bang](https://github.com/jimmycuadra/bang) is a program
# for storing and retrieving text snippets on the command line.
module.exports = class Bang
  # Initializes Bang's data store.
  constructor: ->
    @data = @getData()

  # Entry point for the CLI. Processes arguments and delegates
  # to the appropriate methods.
  start: (args) ->
    program = new Command

    program.version("0.1.2")
      .usage("[options] [key] [value]")
      .option("-d, --delete", "delete the specified key")
      .option("-h, --help", "get help")
      .parse(args)

    [key, value] = program.args

    if program.help
      @log program.helpInformation()
    else if key and program.delete
      @delete key
    else if key and value
      @set key, value
    else if key
      @get key
    else if Object.keys(@data).length is 0
      @log program.helpInformation()
    else
      @list()

  # Data is persisted to disk at `~/.bang`.
  dataPath: process.env.HOME + "/.bang"

  # Loads an existing data store or creates a new one.
  getData: ->
    return @data if @data

    if path.existsSync @dataPath
      JSON.parse(fs.readFileSync @dataPath)
    else
      {}

  # Wraps `console.log` for testing purposes.
  log: (args...) ->
    console.log args...

  # Writes the data store to disk as JSON.
  save: ->
    fs.writeFileSync @dataPath, JSON.stringify(@data)

  # Retrieves a key's value.
  get: (key) ->
    value = @data[key]

    return unless value

    @copy value
    @log value

    value

  # Sets the value of a key.
  set: (key, value) ->
    @data[key] = value
    @save()

    this

  # Deletes a key.
  delete: (key) ->
    delete @data[key]
    @save()

    this

  # Lists all keys and their values.
  list: ->
    amount = 0

    for key of @data
      amount = key.length if key.length > amount

    for key of @data
      @log "#{@pad(key, amount)}#{key}: #{@data[key]}"

    this

  # Copies a value to the clipboard.
  copy: (value) ->
    copyCommand = switch process.platform
      when "darwin" then "pbcopy"
      when "win32"  then "clip"
      else "xclip -selection clipboard"

    if process.platform is "win32"
      exec "echo #{value.replace(/\'/g, "\\'")} | #{copyCommand}"
    else
      exec "printf '#{value.replace(/\'/g, "\\'")}' | #{copyCommand}"

    this

  # Pads a string by the given amount to line up items nicely.
  pad: (item, amount) ->
    out = ""
    i = amount - item.length

    while i > 0
      out += " "
      i--

    out
