path = require "path"
paths = require "./paths"

module.exports = {
  scripts: [
    path.join paths.dist, "js"
  ],
  css: [
    path.join paths.dist, "css"
  ],
  img: [
    path.join paths.dist, "img"
  ],
  index: [
    path.join paths.dist, "index.html"
  ],
  obj: [paths.temp]
}
