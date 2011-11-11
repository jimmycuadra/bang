(function() {
  var Bang, fs, path, program;
  var __slice = Array.prototype.slice;

  program = require("commander");

  fs = require("fs");

  path = require("path");

  module.exports = Bang = (function() {

    function Bang() {
      this.data = this.getData();
    }

    Bang.prototype.start = function(args) {
      var key, value, _ref;
      program.version("0.0.1").usage("[options] [key] [value]").option("-d, --delete", "delete the specified key").parse(args);
      _ref = program.args, key = _ref[0], value = _ref[1];
      if (key && program["delete"]) {
        return this["delete"](key);
      } else if (key && value) {
        return this.set(key, value);
      } else if (key) {
        return this.get(key);
      } else {
        if (Object.keys(this.data).length === 0) {
          return this.log(program.helpInformation());
        } else {
          return this.list();
        }
      }
    };

    Bang.prototype.dataPath = process.env.HOME + "/.bang";

    Bang.prototype.getData = function() {
      if (this.data) return this.data;
      if (path.existsSync(this.dataPath)) {
        return JSON.parse(fs.readFileSync(this.dataPath));
      } else {
        return {};
      }
    };

    Bang.prototype.log = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return console.log.apply(console, args);
    };

    Bang.prototype.save = function() {
      return fs.writeFileSync(this.dataPath, JSON.stringify(this.data));
    };

    Bang.prototype.get = function(key) {
      if (this.data[key]) return this.log(this.data[key]);
    };

    Bang.prototype.set = function(key, value) {
      this.data[key] = value;
      return this.save();
    };

    Bang.prototype["delete"] = function(key) {
      delete this.data[key];
      return this.save();
    };

    Bang.prototype.list = function() {
      var amount, key, _results;
      amount = 0;
      for (key in this.data) {
        if (key.length > amount) amount = key.length;
      }
      _results = [];
      for (key in this.data) {
        _results.push(this.log("" + (this.pad(key, amount)) + key + ": " + this.data[key]));
      }
      return _results;
    };

    Bang.prototype.pad = function(item, amount) {
      var i, out;
      out = "";
      i = amount - item.length;
      while (i > 0) {
        out += " ";
        i--;
      }
      return out;
    };

    return Bang;

  })();

}).call(this);
