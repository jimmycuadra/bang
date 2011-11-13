Bang = require "bang"

describe "Bang", ->
  beforeEach ->
    (spyOn Bang.prototype, "loadData").andCallFake ->
      @data = {}
    spyOn Bang.prototype, "save"
    @bang = new Bang

  describe "#set", ->
    beforeEach ->
      @bang.set "paul", "rooster"

    it "stores the given value", ->
      (expect @bang.get "paul").toEqual "rooster"

    it "saves the data", ->
      (expect @bang.save).toHaveBeenCalled()

  describe "#get", ->
    beforeEach ->
      @bang.set "mathilda", "cow"

    it "returns the value of the key", ->
      (expect @bang.get "mathilda").toEqual "cow"

  describe "#delete", ->
    beforeEach ->
      @bang.set "the great leon", "lion"
      @bang.delete "the great leon"

    it "deletes the key", ->
      (expect @bang.get "the great leon").not.toBeDefined()

    it "saves the data", ->
      (expect @bang.save).toHaveBeenCalled()

  describe "#list", ->
    it "returns an aligned list of keys and values", ->
      @bang.set "paul", "mathilda"
      @bang.set "the great leon", "barney"
      (expect @bang.list()).toMatch /\s{10}paul: mathilda/
