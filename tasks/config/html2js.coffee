paths = require "./paths"
path = require "path"

module.exports = {
  debug:
    options:
      module: "lft.templates",
      rename: (filename) ->
        rel = filename.replace /jade\/templates\/(.*)\.jade/, "$1"
        rel.replace /\//g, "."
    files: [{
      src: path.join paths.src, "jade", "templates", "**/*.jade"
      dest: path.join paths.temp, "js/templates.js"
    }]
}
