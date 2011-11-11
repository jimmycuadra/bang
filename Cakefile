{spawn, exec} = require "child_process"
watch   = require "nodewatch"

task "spec", "Runs the Jasmine specs.", ->
  header()

  jasmine = spawn "node", ["node_modules/jasmine-node/lib/jasmine-node/cli.js", "--coffee", "-i", "src", "spec"]

  jasmine.stdout.on "data", (data) ->
    process.stdout.write data
  jasmine.stderr.on "data", (data) ->
    process.stderr.write data

  jasmine.stdin.end()

task "watch", "Watches for file changes, recompiling CoffeeScript and running the Jasmine specs.", ->
  console.log "Watching Bang for changes...\n"

  invoke "spec"

  watch.add("src").add("spec").onChange (file, prev, cur) ->
    exec "coffee -co lib src", (error, stdout, stderr) ->
      throw error if error

    invoke "spec"

header = ->
  divider = "------------"
  console.log divider, new Date, divider
