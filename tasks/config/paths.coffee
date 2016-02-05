path = require "path"

module.exports =
  src: path.join __dirname, "../../src"
  dist: path.join __dirname, "../../public"
  temp: path.join __dirname, "../../obj"
  vendor: path.join __dirname, "../../bower_components"
