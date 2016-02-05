path = require "path"
paths = require "./paths"

module.exports = {
  options:
    join: true
  debug:
    files: [{
      expand: true
      cwd: path.join paths.src, "coffee"
      src: ["**/*.coffee"]
      dest: path.join paths.temp, "js"
      ext: ".js"
    }]
}
