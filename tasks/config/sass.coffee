path = require "path"
paths = require "./paths"
neat = require "node-neat"

module.exports = {
  debug:
    options:
      include: [
        "bower_components/foundation-sites/scss"
      ].concat neat.includePaths
      comments: true
    files: [{
      cwd: path.join paths.src, "sass"
      expand: true
      src: ["app.sass"]
      dest: path.join paths.dist, "css"
      ext: ".css"
    }]
  release:
    options:
      include: [
        "bower_components/foundation-sites/scss"
      ].concat neat.includePaths
    files: [{
      cwd: path.join paths.src, "sass"
      expand: true,
      src: ["app.sass"],
      dest: path.join paths.dist, "css"
      ext: ".css"
    }]
}
