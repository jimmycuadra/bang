{spawn, exec} = require "child_process"
watch   = require "nodewatch"

task "spec", "Runs the Jasmine specs.", ->
  jasmine = spawn "node", ["node_modules/jasmine-node/lib/jasmine-node/cli.js", "--coffee", "spec"]

  jasmine.stdout.on "data", (data) ->
    process.stdout.write data
  jasmine.stderr.on "data", (data) ->
    process.stderr.write data

  jasmine.stdin.end()

task "watch", "Watches for file changes, recompiling CoffeeScript and running the Jasmine specs.", ->
  console.log "Watching Bang..."

  divider = "------------"

  watch.add("src").add("spec").onChange (file, prev, cur) ->
    console.log divider, new Date, divider

    exec "coffee -co lib src", (error, stdout, stderr) ->
      throw error if error

    invoke "spec"
