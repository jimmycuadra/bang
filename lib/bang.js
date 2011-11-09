(function() {
  var get, program, remove, set;

  program = require("commander");

  get = function() {};

  set = function() {};

  remove = function() {};

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
