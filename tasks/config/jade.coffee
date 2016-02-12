path = require "path"
paths = require "./paths"

module.exports = (pkg_info) ->
  config = {
    index:
      options:
        data: ->
          return {
            debug: true
            commit: pkg_info.commit || (new Date()).getTime()
          }
      files: [{
        src: path.join paths.src, "jade", "index.jade"
        dest: path.join paths.dist, "index.html"
      }]
    indexmin:
      options:
        data:   ->
          return {
            debug: false,
            commit: pkg_info.commit || (new Date()).getTime()
          }
      files: [{
        src: path.join paths.src, "jade", "index.jade"
        dest: path.join paths.dist, "index.html"
      }]
  }
