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
  grunt.loadTasks('tasks');
  
  grunt.initConfig({

    clean: {
      scripts: [config.js.dest],
      css: [config.css.dest],
      templates: [config.html.dest],
      index: ['public/index.html']
    },

    keyfile: {
      api: {
        dest: path.join(config.js.dest, 'var/api_home.js'),
        amd: true,
        name: 'API_HOME',
        key: api_home
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
      debug: {
        expand: true,
        flatten: false,
        cwd: config.js.src,
        src: ['**/*.coffee'],
        dest: config.js.dest,
        ext: '.js'
      }
    },

    copy: {
      vendor: {
        files: [{
          cwd: 'bower_components',
          expand: true,
          src: config.js.vendor_libs,
          dest: 'public/js/vendor'
        }]
      }
    },

    watch: {
      scripts: {
        files: [config.js.src + '/**/*.coffee'],
        tasks: ['clean:scripts', 'coffee:debug', 'copy:vendor']
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
  
  grunt.registerTask('js', ['coffee:debug', 'copy:']);
  grunt.registerTask('css', ['sass']);
  grunt.registerTask('templates', ['jade:templates']);
  grunt.registerTask('default', ['jade:index', 'css', 'js', 'templates', 'keyfile']);
  grunt.registerTask('release', ['default']);

};
