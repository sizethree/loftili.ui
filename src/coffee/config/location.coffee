define [
  'ng'
], (ng) ->

  class LocationConfig

    constructor: ($locationProvider) ->
      $locationProvider.html5Mode true

    @$inject = ['$locationProvider']

  ng.module('lft').config LocationConfig
