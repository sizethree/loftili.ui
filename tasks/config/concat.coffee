paths = require "./paths"
path = require "path"

module.exports = {
  options:
    separator: ";"
  vendors:
    src: [
      path.join paths.vendor, "angular/angular.js"
      path.join paths.vendor, "angular-route/angular-route.js"
      path.join paths.vendor, "angular-resource/angular-resource.js"
      path.join paths.vendor, "soundmanager/script/soundmanager2.js"
      path.join paths.vendor, "socket.io/index.js"
      path.join paths.vendor, "analytics/index.js"
      path.join paths.vendor, "zeroclipboard/dist/ZeroClipboard.js"
    ]
    dest: path.join paths.dist, "js", "vendor.bundle.js"
  scripts:
    src: [
      path.join paths.temp, "js", "**/*.js"
      path.join paths.temp, "templates", "**/*.js"
    ],
    dest: path.join paths.dist, "js", "app.js"
}
