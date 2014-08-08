var path = require('path');

module.exports = (function() {

  var out_dir = 'public',
      src_dir = 'src',
      sass_vendor_dirs = path.join('vendor/sass'),
      neat_path = require('node-neat').includePaths,
      config = {
        html: {
          dest: path.join(out_dir, 'html'),
          src: path.join(src_dir, 'jade', 'templates')
        },
        css: {
          dest: path.join(out_dir, 'css'),
          src: path.join(src_dir, 'sass')
        },
        js: {
          dest: path.join(out_dir, 'js'),
          src: path.join(src_dir, 'coffee'),
          vendor_libs: [
            'requirejs/require.js',
            'jquery/dist/jquery.js',
            'angular/angular.js',
            'angular-route/angular-route.js',
            'angular-resource/angular-resource.js'
          ]
        },
        sass: {
          files: {},
          load_paths: neat_path.concat(sass_vendor_dirs)
        }
      },
      sass_in = path.join(config.css.src, 'app.sass'),
      sass_out = path.join(config.css.dest, 'app.css');

  config['sass']['files'][sass_out] = sass_in;

  return config;

})();
