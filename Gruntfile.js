var grunt = require('grunt'),
    dotenv = require('dotenv'),
    btoa = require('btoa'),
    path = require('path'),
    config = require('./tasks/config'),
    helpers = require('./tasks/helpers');

module.exports = function() {

  dotenv.load();

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-sass');
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
      ].join(' ');

  if(process.env['TRAVIS_COMMIT'])
    pkg_info.commit = process.env['TRAVIS_COMMIT'].substr(0, 8);
  
  grunt.initConfig({

    pkg: pkg_info,

    clean: {
      scripts: [config.js.dest],
      css: [config.css.dest],
      templates: [config.html.dest],
      img: ['public/img'],
      index: ['public/index.html'],
      obj: ['obj']
    },

    uglify: {
      options: { 
        banner: banner
      },
      release: {
        files: [{
          src: path.join(config.js.dest, 'app.js'),
          dest: path.join(config.js.dest, 'app.min.js')
        }]
      }
    },

    cssmin: {
      release: {
        expand: true,
        cwd: 'public/css/',
        src: ['*.css'],
        dest: 'public/css/',
        ext: '.min.css'
      }
    },

    html2js: {
      templates: {
        options: {
          module: 'lft.templates',
          rename: function(filename) {
            var rel = filename.replace(/jade\/templates\/(.*)\.jade/, '$1');
            return rel.replace(/\//g, '.');
          }
        },
        src: config.jade.files.in,
        dest: config.jade.files.out
      }
    },

    jade: {
      index: {
        options: {
          data: function() {
            return {debug: true};
          }
        },
        files: {
          'public/index.html': 'src/jade/index.jade'
        }
      },
      indexmin: {
        options: {
          data: function() {
            return {debug: false};
          }
        },
        files: {
          'public/index.html': 'src/jade/index.jade'
        }
      }
    },

    coffee: {
      options: {
        join: true
      },
      debug: {
        files: config.coffee.files
      }
    },

    concat: {
      options: {
        separator: ';',
      },
      dist: {
        src: config.js.vendor_libs.concat(['obj/js/**/*.js']),
        dest: path.join(config.js.dest, 'app.js')
      }
    },

    watch: {
      scripts: {
        files: [config.js.src + '/**/*.coffee'],
        tasks: ['clean:scripts', 'js'],
      },
      templates: {
        files: [config.html.src + '/**/*.jade'],
        tasks: ['clean:scripts', 'js']
      },
      sass: {
        files: [config.css.src + '/**/*.sass'],
        tasks: ['sass']
      },
      index: {
        files: ['src/jade/index.jade'],
        tasks: ['jade:index']
      }
    },

    copy: {
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
      build: {
        options: {
          loadPath: config.sass.load_paths
        },
        files: config.sass.files
      }
    }

  });
  
  grunt.registerTask('templates', ['html2js:templates']);
  grunt.registerTask('js', ['coffee:debug', 'templates', 'concat']);
  grunt.registerTask('css', ['sass']);
  grunt.registerTask('img', ['copy:img']);
  grunt.registerTask('icons', ['copy:icons']);
  grunt.registerTask('default', ['clean', 'jade:index', 'css', 'js', 'img', 'icons']);
  grunt.registerTask('release', ['default', 'uglify', 'cssmin', 'jade:indexmin']);

};
