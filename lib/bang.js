(function() {
  var Bang, Command, exec, fs, os, path;
  var __slice = Array.prototype.slice;

  Command = require("commander").Command;

  fs = require("fs");

  path = require("path");

  exec = require("child_process").exec;

  os = require("os");

  module.exports = Bang = (function() {

    function Bang() {
      this.data = this.getData();
    }

    Bang.prototype.start = function(args) {
      var key, program, value, _ref;
      program = new Command;
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
      var value;
      value = this.data[key];
      if (!value) return;
      this.copy(value);
      return this.log(value);
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

    Bang.prototype.copy = function(value) {
      var copyCommand;
      copyCommand = os.type().match(/darwin/i) ? "pbcopy" : "xclip -selection clipboard";
      return exec("printf '" + (value.replace(/\'/g, "\\'")) + "' | " + copyCommand, function(error, stdout, stderr) {
        if (error) throw error;
      });
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
