module.exports = function(grunt) {

  grunt.registerMultiTask('keyfile', 'creates a keyfile for angular', function() {
    var keyfile = this.data['dest'],
        module = this.data['module'],
        amd = this.data['amd'],
        name = this.data['name'],
        generator = this.data['generator'],
        key = this.data['key'] || generator(),
        content,
        content_gen;

    function angularGen() {
      return ["angular.module(\"", module, "\").value(\"", name ,"\", (function(a){ return atob(a); })(\"", key, "\"));"].join('');
    }

    function varGen() {
      return ['var ', name, ' = "', key, '";'].join('');
    }

    function requireGen() {
      return ['define([], function() { return "', key, '"; });'].join('');
    }

    if(amd) {
      content_gen = requireGen;
    } else if(module) {
      content_gen = angularGen;
    } else {
      content_gen = varGen;
    }

    content = content_gen();
    grunt.file.write(keyfile, content);

    grunt.log.ok("created " + keyfile);
  });

};
