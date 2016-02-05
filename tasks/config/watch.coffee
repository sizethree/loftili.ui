path = require "path"
paths = require "./paths"

module.exports = {
  scripts:
    files: [
      path.join paths.src, "jade", "**/*.jade"
      path.join paths.src, "coffee", "/**/*.coffee"
    ]
    tasks: [
      "clean:scripts"
      "coffee:debug"
      "html2js:debug"
      "concat:scripts"
      "concat:vendors"
    ]
  sass:
    files: [
      path.join paths.src, "sass", "**/*.sass"
    ]
    tasks: ["sass:debug"]
  index:
    files: ["src/jade/index.jade"]
    tasks: ["jade:index"]
}
