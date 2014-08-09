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
          obj: path.join(out_dir, '..', 'obj', 'js'),
          vendor_libs: [
            'bower_components/jquery/dist/jquery.js',
            'bower_components/angular/angular.js',
            'bower_components/angular-route/angular-route.js',
            'bower_components/angular-resource/angular-resource.js'
          ]
        },
        sass: {
          files: {},
          load_paths: neat_path.concat(sass_vendor_dirs)
        },
        coffee: {
          files: {}
        }
      },
      sass_in = path.join(config.css.src, 'app.sass'),
      sass_out = path.join(config.css.dest, 'app.css'),
      coffee_out = path.join(config.js.obj, 'app.js'),
      coffee_in = [path.join(config.js.src, '**/*.coffee')];

  config['sass']['files'][sass_out] = sass_in;
  config['coffee']['files'][coffee_out] = coffee_in;

  return config;

})();
