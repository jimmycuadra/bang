CLI = require "../lib/cli"
Bang = require "../lib/bang"

cliArgs = (args) ->
  ["node", "bang"].concat args

describe "CLI", ->
  beforeEach ->
    spyOn CLI.prototype, "log"
    (spyOn Bang.prototype, "loadData").andCallFake ->
      @data = {}

  describe "#start", ->
    describe "when called with no arguments", ->
      describe "when there is no data", ->
        it "displays the help information", ->
          @cli = new CLI cliArgs([]), new Bang
          @cli.start()
          (expect @cli.log.mostRecentCall.args).toMatch /Usage/

      describe "when there is data", ->
        it "delegates to #list", ->
          bang = new Bang
          spyOn bang, "save"
          bang.set "foo", "bar"
          spyOn bang, "list"
          @cli = new CLI cliArgs([]), bang
          @cli.start()
          (expect @cli.bang.list).toHaveBeenCalled()

    describe "when called with a key", ->
      describe "and the -d option", ->
        it "delegates to delete", ->
          @cli = new CLI cliArgs(["-d", "foo"]), new Bang
          spyOn @cli.bang, "delete"
          @cli.start()
          (expect @cli.bang.delete).toHaveBeenCalled()

      it "delegates to get", ->
        @cli = new CLI cliArgs(["foo"]), new Bang
        spyOn @cli.bang, "get"
        @cli.start()
        (expect @cli.bang.get).toHaveBeenCalled()

    describe "when called with a key and value", ->
      it "delegates to set", ->
        @cli = new CLI cliArgs(["foo", "bar"]), new Bang
        spyOn @cli.bang, "set"
        @cli.start()
        (expect @cli.bang.set).toHaveBeenCalled()
