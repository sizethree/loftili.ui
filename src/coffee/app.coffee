requirejs.config
  baseUrl: '/js'
  paths:
    ng: '/js/vendor/angular/angular'
    ngRoute: '/js/vendor/angular-route/angular-route'
    ngResource: '/js/vendor/angular-resource/angular-resource'
  shim:
    ng:
      exports: 'angular'
    ngRoute:
      deps: ['ng']
    ngResource:
      deps: ['ng']

define ['ng', 'ngRoute', 'ngResource'], (ng, ngRoute, ngResource) ->

  lft = ng.module 'lft', ['ngRoute', 'ngResource']

  bootstrap = () ->
    ng.bootstrap document, ['lft']

  autoload = [
    'config/location'
    'routes/home'
  ]

  require autoload, bootstrap
