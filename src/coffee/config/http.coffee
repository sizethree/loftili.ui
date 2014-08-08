define [
  'ng'
], (ng) ->

  ng.module('lft').config ['$httpProvider', ($httpProvider) ->
    $httpProvider.defaults.useXDomain = true
    $httpProvider.defaults.withCredentials = true
  ]
