var grunt = require('grunt'),
    dotenv = require('dotenv'),
    btoa = require('btoa'),
    path = require('path'),
    neat = require('node-neat'),
    sass = require('node-sass'),
    helpers = require('./tasks/helpers'),
    paths = require("./tasks/config/paths");

module.exports = function() {

  dotenv.load();

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-html2js');
  grunt.loadTasks('tasks');

  var pkg_info = grunt.file.readJSON('package.json'),
      banner = [
        '/*!', 
        '<%= pkg.name %>',
        [
          'v<%= pkg.version %>',
          '<% if(pkg.commit) { %>',
          '-<%= pkg.commit %>', 
          '<% } %>',
        ].join(''),
        '[<%= pkg.repository.url %>]',
        '*/'
      ].join(' '),
      artifact_name = [process.env['ARTIFACT_VERSION'] || 'latest', 'tar.gz'].join('.'),
      artifact_dest = process.env['ARTIFACT_DESTINATION'] || 'artifacts/loftili/ui',
      artifact_host = process.env['ARTIFACT_HOST'] || 'artifacts.sizethreestudios.com';

  if(process.env['GIT_COMMIT'])
    pkg_info.commit = process.env['GIT_COMMIT'].substr(0, 8);

  if(process.env['ARTIFACT_TAG'])
    pkg_info.commit = process.env['ARTIFACT_TAG'].substr(0, 8);
  
  grunt.initConfig({
    pkg: pkg_info,
    uglify: require("./tasks/config/uglify")(banner),
    cssmin: require("./tasks/config/cssmin"),
    clean: require("./tasks/config/clean"),
    html2js: require("./tasks/config/html2js"),
    jade: require("./tasks/config/jade")(pkg_info),
    coffee: require("./tasks/config/coffee"),
    concat: require("./tasks/config/concat"),
    watch: require("./tasks/config/watch"),
    copy: require("./tasks/config/copy"),
    sass: require("./tasks/config/sass")
  });

  grunt.registerMultiTask('sass', 'compiles sass via node native bindings', function() {
    var done = this.async(),
        files = this.files,
        is_failed = false,
        data = this.data;

    function failed(reason) {
      grunt.log.error(reason);

      if(!is_failed) {
        is_failed = true;
        done(false);
      }
    }

    function render(file) {
      var source = file.src,
          dest = file.dest,
          main_file, exists,
          sass_config = { includePaths: data.options.include, sourceComments: data.options.comments == true };

      if(source.length > 1 || is_failed)
        return failed('must specify only one source file when compiling sass');

      main_file = source[0];
      exists = grunt.file.exists(main_file);

      if(!exists)
        return failed('unable to locate the main source file['+main_file+']');

      grunt.log.ok('rendering['+main_file+'] to ['+dest+']');

      function finished(err, result) {
        var buffer = null;

        if(err)
          return failed(err);

        buffer = result.css;

        grunt.file.write(dest, buffer);
        grunt.log.ok('finished');

        done(true);
      }

      sass_config.file = main_file;
      sass.render(sass_config, finished);
    }

    if(files.length !== 1)
      return failed('no sass file configuration detected');

    files.forEach(render);
  });
  
  grunt.registerTask('publish', [
    'compress', 
    'ftpush'
  ]);

  grunt.registerTask('css', [
    'sass'
  ]);

  grunt.registerTask('img', ['copy:img']);
  grunt.registerTask('icons', ['copy:icons']);

  grunt.registerTask('default', [
    'clean', 
    'jade:index', 
    'sass:debug', 
    'coffee:debug',
    'html2js:debug',
    'concat:scripts',
    'concat:vendors',
    'img', 
    'icons', 
    'copy:soundmanager',
    'copy:zeroclipboard'
  ]);

  grunt.registerTask('release', [
    'default', 
    'uglify', 
    'sass:release', 
    'cssmin', 
    'jade:indexmin'
  ]);

};
