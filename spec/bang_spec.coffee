Bang = require "bang"

cliArgs = (args) ->
  ["node", "bang.js"].concat args

describe "Bang", ->
  beforeEach ->
    spyOn(Bang.prototype, "getData").andReturn {}
    spyOn(Bang.prototype, "save")
    spyOn(Bang.prototype, "log")

    @bang = new Bang

  describe "#set", ->
    beforeEach ->
      @bang.set("paul", "rooster")

    it "stores the given value", ->
      expect(@bang.data.paul).toEqual "rooster"

    it "saves the data", ->
      expect(@bang.save).toHaveBeenCalled()

  describe "#get", ->
    it "copies the value of the key to the clipboard", ->
      @bang.data.mathilda = "cow"
      spyOn(@bang, "copy")
      @bang.get("mathilda")
      expect(@bang.copy).toHaveBeenCalledWith "cow"

    it "logs the value of the key", ->
      @bang.data.mathilda = "cow"
      @bang.get("mathilda")
      expect(@bang.log).toHaveBeenCalledWith "cow"

  describe "#delete", ->
    beforeEach ->
      @bang.data["the great leon"] = "lion"
      @bang.delete("the great leon")

    it "deletes the key", ->
      expect(@bang.data["the great leon"]).not.toBeDefined()

    it "saves the data", ->
      expect(@bang.save).toHaveBeenCalled()

  describe "#list", ->
    it "logs an aligned list of keys and values", ->
      @bang.data.paul = "mathilda"
      @bang.data["the great leon"] = "barney"
      @bang.list()
      expect(@bang.log.argsForCall[0][0]).toEqual "          paul: mathilda"

  describe "#start", ->
    describe "when called with no arguments", ->
      describe "when there is no data", ->
        it "displays the help information", ->
          @bang.start cliArgs([])
          expect(@bang.log.mostRecentCall.args).toMatch /Usage/

      describe "when there is data", ->
        it "delegates to #list", ->
          spyOn(@bang, "list")
          @bang.data.foo = "bar"
          @bang.start cliArgs([])
          expect(@bang.list).toHaveBeenCalled()

    describe "when called with a key", ->
      describe "and the -d option", ->
        it "delegates to delete", ->
          spyOn(@bang, "delete")
          @bang.start cliArgs(["-d", "foo"])
          expect(@bang.delete).toHaveBeenCalled()

      it "delegates to get", ->
        spyOn(@bang, "get")
        @bang.start cliArgs(["foo"])
        expect(@bang.get).toHaveBeenCalled()

    describe "when called with a key and value", ->
      it "delegates to set", ->
        spyOn(@bang, "set")
        @bang.start cliArgs(["foo", "bar"])
        expect(@bang.set).toHaveBeenCalled()
