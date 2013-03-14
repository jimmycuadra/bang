{Command} = require "commander"
Bang      = require "./bang"
{exec}  = require "child_process"
packageInfo = require "../package.json"

# Command line interface to [Bang](https://github.com/jimmycuadra/bang).
module.exports = class CLI
  # Initializes a Bang instance and a Commander instance to process
  # arguments passed from the shell. The optional second argument
  # is an instance of Bang with methods stubbed out for testing
  # purposes.
  constructor: (args, mockBang) ->
    @bang     = mockBang or new Bang
    @program  = new Command

    @program.version(packageInfo.version, "-v, --version")
      .usage("[options] [key] [value]")
      .option("-d, --delete", "delete the specified key")
      .parse(args)

  # Delegates to Bang methods determined by
  # arguments passed from the command line.
  start: ->
    [key, value] = @program.args

    if key and @program.delete
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
