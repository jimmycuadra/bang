{Command} = require "commander"
Bang      = require "./bang"
{exec}  = require "child_process"

# Command line interface to Bang.
module.exports = class CLI
  # Initializes a Bang instance and a Commander instance
  # to process arguments passed from the shell.
  constructor: (args, mockBang) ->
    @bang     = mockBang or new Bang
    @program  = new Command

    @program.version("0.1.2")
      .usage("[options] [key] [value]")
      .option("-d, --delete", "delete the specified key")
      .option("-h, --help", "get help")
      .parse(args)

  # Delegates to Bang methods determined by
  # arguments passed from the command line.
  start: ->
    [key, value] = @program.args

    if @program.help
      @log @program.helpInformation()
    else if key and @program.delete
      @bang.delete key
    else if key and value
      @bang.set key, value
    else if key
      value = @bang.get key
      if value
        @log value
        @copy value
    else if Object.keys(@bang.data).length is 0
      @log @program.helpInformation()
    else
      @log @bang.list()

  # Wraps `console.log` for testing purposes.
  log: (args...) ->
    console.log args...

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
