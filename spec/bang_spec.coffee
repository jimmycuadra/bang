Bang = require "bang"

describe "Bang", ->
  beforeEach ->
    @bang = new Bang
    spyOn(@bang, "getData").andReturn {}
    spyOn(@bang, "save")

  it "sets keys when called with a key and a value", ->
    @bang.start ["node", "bang.js", "paul", "rooster"]
    expect(@bang.data.paul).toEqual "rooster"

  it "gets keys when called with only a key", ->
    spyOn(@bang, "log")
    @bang.data.mathilda = "cow"
    value = @bang.start ["node", "bang.js", "mathilda"]
    expect(@bang.log).toHaveBeenCalledWith("cow")

  it "removes keys when called with -d and a key", ->
    @bang.data.theGreatLeon = "lion"
    @bang.start ["node", "bang.js", "-d", "theGreatLeon"]
    expect(@bang.data.theGreatLeon).not.toBeDefined()

  it "outputs help when called with no arguments", ->
    spyOn(@bang, "log")
    @bang.start ["node", "bang.js"]
    expect(@bang.log).toHaveBeenCalled();

  it "saves data when a key is set or removed", ->
    @bang.set "barney", "sabertooth tiger"
    @bang.remove "barney"
    expect(@bang.save.callCount).toBe 2
