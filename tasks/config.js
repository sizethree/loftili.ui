var path = require('path');

module.exports = (function() {

  var out_dir = 'public',
      src_dir = 'src',
      sass_vendor_dirs = path.join('vendor/sass'),
      neat_path = require('node-neat').includePaths,
      vendor_js_dir = 'bower_components',
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
            path.join(vendor_js_dir, 'angular/angular.js'),
            path.join(vendor_js_dir, 'angular-route/angular-route.js'),
            path.join(vendor_js_dir, 'angular-resource/angular-resource.js'),
            path.join(vendor_js_dir, 'analytics/index.js')
          ]
        },
        sass: {
          files: {},
          load_paths: neat_path.concat(sass_vendor_dirs)
        },
        coffee: {
          files: {}
        },
        jade: {
          files: {}
        }
      },
      sass_in = path.join(config.css.src, 'app.sass'),
      sass_out = path.join(config.css.dest, 'app.css'),
      jade_out = path.join(config.js.obj, 'templates.js'),
      jade_in = path.join(config.html.src, '**/*.jade'),
      coffee_out = config.js.obj,
      coffee_in = '**/*.coffee';

  config['jade']['files']['in'] = jade_in;
  config['jade']['files']['out'] = jade_out;
  config['sass']['files'][sass_out] = sass_in;
  config['coffee']['files'] = [{
    expand: true,
    cwd: config.js.src,
    src: [coffee_in],
    dest: coffee_out,
    ext: '.js'
  }];

  return config;

})();
