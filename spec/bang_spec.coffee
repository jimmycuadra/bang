Bang = require "bang"

describe "Bang", ->
  beforeEach ->
    @bang = new Bang
    spyOn(@bang, "getData").andReturn {}
    spyOn(@bang, "save")
    spyOn(@bang, "log")

  it "sets keys when called with a key and a value", ->
    @bang.start ["node", "bang.js", "paul", "rooster"]
    expect(@bang.data.paul).toEqual "rooster"

  it "gets keys when called with only a key", ->
    @bang.data.mathilda = "cow"
    value = @bang.start ["node", "bang.js", "mathilda"]
    expect(@bang.log).toHaveBeenCalledWith "cow"

  it "removes keys when called with -d and a key", ->
    @bang.data.theGreatLeon = "lion"
    @bang.start ["node", "bang.js", "-d", "theGreatLeon"]
    expect(@bang.data.theGreatLeon).not.toBeDefined()

  it "saves data when a key is set or removed", ->
    @bang.set "barney", "sabertooth tiger"
    @bang.remove "barney"
    expect(@bang.save.callCount).toBe 2

  it "lists keys when called with no arguments and there is data", ->
    @bang.data.foo = "bar"
    spyOn(@bang, "list")
    @bang.start ["node", "bang.js"]
    expect(@bang.list).toHaveBeenCalled()

  it "outputs help when called with no arguments are there is no data", ->
    @bang.start ["node", "bang.js"]
    console.log @bang.data
    expect(@bang.log.mostRecentCall.args).toMatch /Usage/

  it "aligns keys in list output by padding their left edges with spaces", ->
    @bang.data.foo = "bar"
    @bang.data.blah = "bleh"
    @bang.list()
    expect(@bang.log.argsForCall[0][0]).toEqual " foo: bar"
