(function() {
  var bang, data, fs, get, path, program, remove, save, set;

  program = require("commander");

  fs = require("fs");

  path = require("path");

  bang = process.env.HOME + "/.bang";

  data = {};

  if (path.existsSync(bang)) data = JSON.parse(fs.readFileSync(bang));

  save = function() {
    console.log("save called");
    return fs.writeFileSync(bang, JSON.stringify(data));
  };

  get = function(key) {
    if (data[key]) return console.log(data[key]);
  };

  set = function(key, value) {
    data[key] = value;
    return save();
  };

  remove = function() {
    if (data[key]) delete data[key];
    return save();
  };

  exports.start = function() {
    var key, value, _ref;
    program.version("0.0.1").usage("[options] [key] [value]").option("-d, --delete", "delete the specified key").parse(process.argv);
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

}).call(this);
