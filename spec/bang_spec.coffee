Bang = require "bang"

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
    it "logs the value of the key", ->
      @bang.data.mathilda = "cow"
      @bang.get("mathilda")
      expect(@bang.log).toHaveBeenCalledWith "cow"

  describe "#remove", ->
    beforeEach ->
      @bang.data["the great leon"] = "lion"
      @bang.remove("the great leon")

    it "removes the key", ->
      expect(@bang.data["the great leon"]).not.toBeDefined()

    it "saves the data", ->
      expect(@bang.save).toHaveBeenCalled()

  describe "#list", ->
    it "logs an aligned list of keys and values", ->
      @bang.data.paul = "mathilda"
      @bang.data["the great leon"] = "barney"
      @bang.list()
      expect(@bang.log.argsForCall[0][0]).toEqual "          paul: mathilda"
