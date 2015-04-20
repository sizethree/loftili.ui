var grunt = require('grunt'),
    dotenv = require('dotenv'),
    btoa = require('btoa'),
    path = require('path'),
    neat = require('node-neat'),
    sass = require('node-sass'),
    helpers = require('./tasks/helpers');

module.exports = function() {

  dotenv.load();

  var paths = {
    src: path.join(__dirname, 'src'),
    dist: path.join(__dirname, 'public'),
    temp: path.join(__dirname, 'obj'),
    vendor: path.join(__dirname, 'bower_components')
  };

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

  if(process.env['TRAVIS_COMMIT'])
    pkg_info.commit = process.env['TRAVIS_COMMIT'].substr(0, 8);
  
  grunt.initConfig({

    pkg: pkg_info,

    clean: {
      scripts: [
        path.join(paths.dist, 'js')
      ],
      css: [
        path.join(paths.dist, 'css')
      ],
      img: [
        path.join(paths.dist, 'img')
      ],
      index: [
        path.join(paths.dist, 'index.html')
      ],
      obj: [
        paths.temp
      ]
    },

    uglify: {
      options: { 
        banner: banner
      },
      release: {
        files: [{
          src: [
            path.join(paths.dist, 'js', 'vendor.bundle.js'),
            path.join(paths.dist, 'js', 'app.js')
          ],
          dest: path.join(paths.dist, 'js', 'app.min.js')
        }]
      }
    },

    cssmin: {
      release: {
        expand: true,
        cwd: path.join(paths.dist, 'css'),
        src: ['*.css'],
        dest: path.join(paths.dist, 'css'),
        ext: '.min.css'
      }
    },

    html2js: {
      debug: {
        options: {
          module: 'lft.templates',
          rename: function(filename) {
            var rel = filename.replace(/jade\/templates\/(.*)\.jade/, '$1');
            return rel.replace(/\//g, '.');
          }
        },
        files: [{
          src: path.join(paths.src, 'jade', 'templates', '**/*.jade'),
          dest: path.join(paths.temp, 'js/templates.js')
        }]
      }
    },

    jade: {
      index: {
        options: {
          data: function() {
            return {
              debug: true,
              commit: pkg_info.commit || new Date().getTime()
            };
          }
        },
        files: [{
          src: path.join(paths.src, 'jade', 'index.jade'),
          dest: path.join(paths.dist, 'index.html')
        }]
      },
      indexmin: {
        options: {
          data: function() {
            return {
              debug: false,
              commit: pkg_info.commit || new Date().getTime()
            };
          }
        },
        files: [{
          src: path.join(paths.src, 'jade', 'index.jade'),
          dest: path.join(paths.dist, 'index.html')
        }]
      }
    },

    coffee: {
      options: {
        join: true
      },
      debug: {
        files: [{
          expand: true,
          cwd: path.join(paths.src, 'coffee'),
          src: ['**/*.coffee'],
          dest: path.join(paths.temp, 'js'),
          ext: '.js'
        }]
      }
    },

    concat: {
      options: {
        separator: ';',
      },
      vendors: {
        src: [
          path.join(paths.vendor, 'angular/angular.js'),
          path.join(paths.vendor, 'angular-route/angular-route.js'),
          path.join(paths.vendor, 'angular-resource/angular-resource.js'),
          path.join(paths.vendor, 'soundmanager/script/soundmanager2.js'),
          path.join(paths.vendor, 'socket.io/index.js'),
          path.join(paths.vendor, 'analytics/index.js')
        ],
        dest: path.join(paths.dist, 'js', 'vendor.bundle.js')
      },
      scripts: {
        src: [
          path.join(paths.temp, 'js', '**/*.js'),
          path.join(paths.temp, 'templates', '**/*.js')
        ],
        dest: path.join(paths.dist, 'js', 'app.js')
      }
    },

    watch: {
      scripts: {
        files: [
          path.join(paths.src, 'jade', '**/*.jade'),
          path.join(paths.src, 'coffee', '/**/*.coffee')
        ],
        tasks: [
          'clean:scripts', 
          'coffee:debug',
          'html2js:debug',
          'concat:scripts',
          'concat:vendors'
        ],
      },
      sass: {
        files: [
          path.join(paths.src, 'sass', '**/*.sass')
        ],
        tasks: ['sass']
      },
      index: {
        files: ['src/jade/index.jade'],
        tasks: ['jade:index']
      }
    },

    copy: {
      soundmanager: {
        expand: true,
        cwd: 'bower_components/soundmanager/swf',
        src: ['**/*.swf'],
        dest: 'public/swf'
      },
      icons: {
        expand: true,
        cwd: 'bower_components',
        src: ['ionicons/css/**/*', 'ionicons/fonts/**/*'],
        dest: 'public/vendor'
      },
      img: {
        expand: true,
        cwd: 'src/img',
        src: '**/*',
        dest: 'public/img'
      }
    },

    sass: {
      debug: {
        options: {
          include: neat.includePaths
        },
        files: [{
          cwd: path.join(paths.src, 'sass'),
          expand: true,
          src: ['app.sass'],
          dest: path.join(paths.dist, 'css'),
          ext: '.css'
        }]
      }
    }

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
          sass_config = { includePaths: data.options.include };

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

    if(files.length === 1)
      files.forEach(render);
    else
      failed('no sass file configuration detected');
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
    'copy:soundmanager'
  ]);

  grunt.registerTask('release', ['default', 'uglify', 'cssmin', 'jade:indexmin']);

};
