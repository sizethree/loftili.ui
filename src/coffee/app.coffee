run = (global) ->

  lft = angular.module 'lft', ['ngRoute', 'ngResource', 'lft.templates']

  loaded_config = (response) ->
    data = response.data
    lft.value 'CONFIG', data
    lft.value 'URLS', data.urls
    lft.value 'GOOGLE', data.google

    angular.bootstrap document, ['lft']

  failed_config = () ->

  injector = angular.injector ['ng']
  http = injector.get '$http'
  http.get('/app.conf.json').then loaded_config, failed_config

  global.lft = lft

run @
