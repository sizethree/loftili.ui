var grunt = require('grunt');

module.exports = {

  srcFiles: function(srcdir, destdir, wildcard, extension) {
    var path = require('path'),
        files = {};

    grunt.file.expand({cwd: srcdir}, wildcard).forEach(function(relpath) {
      destname = relpath.replace(/\.\w+$/ig, '.' + extension);
      files[path.join(destdir, destname)] = path.join(srcdir, relpath);
    });

    return files;
  }

};
