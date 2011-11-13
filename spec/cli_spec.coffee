CLI = require "cli"

describe "CLI", ->
  beforeEach ->
    spyOn CLI.prototype, "log"

  describe "#start", ->
    describe "when called with no arguments", ->
      describe "when there is no data", ->
        it "displays the help information", ->
          @cli = new CLI []
          @cli.start()
          (expect @cli.log.mostRecentCall.args).toMatch /Usage/

      describe "when there is data", ->
        it "delegates to #list", ->
          @cli new CLI []
          @cli.start()
          (expect @cli.bang.list).toHaveBeenCalled()

    describe "when called with a key", ->
      describe "and the -d option", ->
        it "delegates to delete", ->
          @cli new CLI []
          @cli.start()
          (expect @cli.bang.delete).toHaveBeenCalled()

      it "delegates to get", ->
        @cli new CLI []
        @cli.start()
        (expect @cli.bang.get).toHaveBeenCalled()

    describe "when called with a key and value", ->
      it "delegates to set", ->
        @cli new CLI []
        @cli.start()
        (expect @cli.bang.set).toHaveBeenCalled()
