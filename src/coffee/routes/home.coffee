define [
  'ng'
  'services/auth'
  'controllers/home'
], (ng) ->

  class HomeRoute

    constructor: ($routeProvider, AuthProvider) ->
      route =
        templateUrl: '/html/views/home.html'
        controller: 'HomeController'
        resolve:
          _Auth: AuthProvider.filter('guest').validator

      $routeProvider.when '/', route

    @$inject = ['$routeProvider', 'AuthProvider']

  ng.module('lft').config HomeRoute
