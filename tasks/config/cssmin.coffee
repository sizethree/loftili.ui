paths = require "./paths"
path = require "path"

module.exports = {
  release:
    expand: true
    cwd: path.join paths.dist, "css"
    src: ["*.css"]
    dest: path.join paths.dist, "css"
    ext: ".min.css"
}
