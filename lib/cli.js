(function() {
  var Bang, CLI, Command, exec;
  var __slice = Array.prototype.slice;

  Command = require("commander").Command;

  Bang = require("./bang");

  exec = require("child_process").exec;

  module.exports = CLI = (function() {

    function CLI(args, mockBang) {
      this.bang = mockBang || new Bang;
      this.program = new Command;
      this.program.version("0.2.0").usage("[options] [key] [value]").option("-d, --delete", "delete the specified key").option("-h, --help", "get help").parse(args);
    }

    CLI.prototype.start = function() {
      var key, value, _ref;
      _ref = this.program.args, key = _ref[0], value = _ref[1];
      if (this.program.help) {
        return this.log(this.program.helpInformation());
      } else if (key && this.program["delete"]) {
        return this.bang["delete"](key);
      } else if (key && value) {
        return this.bang.set(key, value);
      } else if (key) {
        value = this.bang.get(key);
        if (value) {
          this.log(value);
          return this.copy(value);
        }
      } else if (Object.keys(this.bang.data).length === 0) {
        return this.log(this.program.helpInformation());
      } else {
        return this.log(this.bang.list());
      }
    };

    CLI.prototype.log = function() {
      var args;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return console.log.apply(console, args);
    };

    CLI.prototype.copy = function(value) {
      var copyCommand;
      copyCommand = (function() {
        switch (process.platform) {
          case "darwin":
            return "pbcopy";
          case "win32":
            return "clip";
          default:
            return "xclip -selection clipboard";
        }
      })();
      if (process.platform === "win32") {
        return exec("echo " + (value.replace(/\'/g, "\\'")) + " | " + copyCommand);
      } else {
        return exec("printf '" + (value.replace(/\'/g, "\\'")) + "' | " + copyCommand);
      }
    };

    return CLI;

  })();

}).call(this);
