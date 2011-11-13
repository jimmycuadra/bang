(function() {
  var Bang, exec, fs, pad, path;

  fs = require("fs");

  path = require("path");

  exec = require("child_process").exec;

  module.exports = Bang = (function() {

    function Bang() {
      this.loadData();
    }

    Bang.prototype.loadData = function() {
      var dataPath;
      dataPath = process.env.HOME + "/.bang";
      return this.data = path.existsSync(dataPath) ? JSON.parse(fs.readFileSync(dataPath)) : {};
    };

    Bang.prototype.save = function() {
      return fs.writeFileSync(this.dataPath, JSON.stringify(this.data));
    };

    Bang.prototype.get = function(key) {
      return this.data[key];
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
      var amount, key, lines;
      lines = [];
      amount = 0;
      for (key in this.data) {
        if (key.length > amount) amount = key.length;
      }
      for (key in this.data) {
        lines.push("" + (pad(key, amount)) + key + ": " + this.data[key]);
      }
      return lines.join("\n");
    };

    return Bang;

  })();

  pad = function(item, amount) {
    var i, out;
    out = "";
    i = amount - item.length;
    while (i > 0) {
      out += " ";
      i--;
    }
    return out;
  };

}).call(this);
