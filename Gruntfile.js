var grunt = require('grunt'),
    dotenv = require('dotenv'),
    btoa = require('btoa'),
    path = require('path'),
    config = require('./tasks/config'),
    helpers = require('./tasks/helpers');

module.exports = function() {

  dotenv.load();

  var api_home = process.env['API_HOME'] || 'http://api.lofti.li';

  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-sass');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadTasks('tasks');
  
  grunt.initConfig({

    clean: {
      scripts: [config.js.dest],
      css: [config.css.dest],
      templates: [config.html.dest],
      index: ['public/index.html'],
      obj: ['obj']
    },

    keyfile: {
      api: {
        dest: 'obj/js/api_home.js',
        module: 'lft',
        name: 'API_HOME',
        key: api_home,
        encrypt: false
      }
    },

    uglify: {
      options: { },
      release: {
        files: [{
          expand: true,
          cwd: config.js.dest,
          src: '**/*.js',
          dest: config.js.dest
        }]
      }
    },

    jade: {
      templates: {
        files: helpers.srcFiles(config.html.src, config.html.dest, '**/*.jade', 'html')
      },
      index: {
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
        src: config.js.vendor_libs.concat(['obj/js/app.js', 'obj/js/**/*.js']),
        dest: path.join(config.js.dest, 'app.js')
      }
    },

    watch: {
      scripts: {
        files: [config.js.src + '/**/*.coffee'],
        tasks: ['clean:scripts', 'coffee:debug', 'keyfile']
      },
      templates: {
        files: [config.html.src + '/**/*.jade'],
        tasks: ['jade:templates']
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

    sass: {
      build: {
        options: {
          loadPath: config.sass.load_paths
        },
        files: config.sass.files
      }
    }

  });
  
  grunt.registerTask('js', ['coffee:debug', 'concat']);
  grunt.registerTask('css', ['sass']);
  grunt.registerTask('templates', ['jade:templates']);
  grunt.registerTask('default', ['jade:index', 'css', 'keyfile', 'js', 'templates']);
  grunt.registerTask('release', ['default', 'uglify']);

};
