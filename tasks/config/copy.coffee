path = require "path"
paths = require "./paths"

module.exports = {
  zeroclipboard:
    expand: true
    cwd: path.join paths.vendor, "zeroclipboard/dist"
    src: ["**/*.swf"]
    dest: "public/swf"
  soundmanager:
    expand: true,
    cwd: path.join paths.vendor, "soundmanager/swf"
    src: ["**/*.swf"]
    dest: "public/swf"
  icons:
    expand: true,
    cwd: paths.vendor
    src: ["ionicons/css/**/*", "ionicons/fonts/**/*"]
    dest: "public/vendor"
  img:
    expand: true
    cwd: "src/img"
    src: "**/*"
    dest: "public/img"

}
