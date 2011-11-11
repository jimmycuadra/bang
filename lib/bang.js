(function() {
  var Bang, bang, data, exports, fs, path, program;

  program = require("commander");

  fs = require("fs");

  path = require("path");

  bang = process.env.HOME + "/.bang";

  data = {};

  exports = Bang = (function() {

    function Bang() {
      this.data = this.getData();
    }

    Bang.prototype.start = function(args) {
      var key, value, _ref;
      if (args == null) args = process.argv;
      program.version("0.0.1").usage("[options] [key] [value]").option("-d, --delete", "delete the specified key").parse(args);
      _ref = program.args, key = _ref[0], value = _ref[1];
      if (key && program["delete"]) {
        return remove(key);
      } else if (key && value) {
        return set(key, value);
      } else if (key) {
        return get(key);
      } else {
        return console.log(program.helpInformation());
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

    Bang.prototype.save = function() {
      return fs.writeFileSync(this.dataPath, JSON.stringify(this.data));
    };

    Bang.prototype.get = function(key) {
      if (this.data[key]) return console.log(this.data[key]);
    };

    Bang.prototype.set = function(key, value) {
      this.data[key] = this.data[value];
      return save();
    };

    Bang.prototype.remove = function(key) {
      delete this.data[key];
      return save();
    };

    return Bang;

  })();

}).call(this);
