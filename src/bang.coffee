fs      = require "fs"
path    = require "path"
{exec}  = require "child_process"

# [Bang](https://github.com/jimmycuadra/bang) is a program
# for storing and retrieving text snippets on the command line.
module.exports = class Bang
  constructor: ->
    @loadData()

  # Initializes Bang's data store.
  loadData: ->
    dataPath = process.env.HOME + "/.bang"

    @data = if path.existsSync dataPath
      JSON.parse fs.readFileSync dataPath
    else
      {}

  # Writes the data store to disk as JSON.
  save: ->
    fs.writeFileSync @dataPath, JSON.stringify(@data)

  # Retrieves a key's value.
  get: (key) ->
    @data[key]

  # Sets the value of a key.
  set: (key, value) ->
    @data[key] = value
    @save()

  # Deletes a key.
  delete: (key) ->
    delete @data[key]
    @save()

  # Lists all keys and their values.
  list: ->
    lines = []
    amount = 0

    for key of @data
      amount = key.length if key.length > amount

    for key of @data
      lines.push "#{pad(key, amount)}#{key}: #{@get key}"

    lines.join "\n"

# Helper function to left-pad a string with spaces.
pad = (item, amount) ->
  out = ""
  i = amount - item.length

  while i > 0
    out += " "
    i--

  out
