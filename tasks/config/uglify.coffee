path = require "path"
paths = require "./paths"

module.exports = (banner) ->
  config = {
    options:
      banner: banner
    release:
      files: [{
        src: [
          path.join paths.dist, "js", "vendor.bundle.js"
          path.join paths.dist, "js", "app.js"
        ],
        dest: path.join paths.dist, "js", "app.min.js"
      }]
  }
  config
