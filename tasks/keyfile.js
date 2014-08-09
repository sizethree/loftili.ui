module.exports = function(grunt) {

  grunt.registerMultiTask('keyfile', 'creates a keyfile for angular', function() {
    var keyfile = this.data['dest'],
        module = this.data['module'],
        amd = this.data['amd'],
        name = this.data['name'],
        generator = this.data['generator'],
        encrypt = this.data['encrypt'] === true,
        key = this.data['key'] || generator(),
        content,
        content_gen;

    function angularGen() {
      var return_str = encrypt ? 'atob(a)': 'a',
          module_str = ['angular.module("', module, '")'].join(''),
          value_str = ['value("', name ,'", (function(a){ return ',return_str,'; })("', key, '"));'].join('');

      return [module_str, value_str].join('.');
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
