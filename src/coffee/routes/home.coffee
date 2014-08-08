define [
  'ng'
  'services/auth'
  'controllers/home'
], (ng) ->

  class HomeRoute

    constructor: ($routeProvider, AuthProvider) ->
      $routeProvider.when '/', HomeRoute.register(AuthProvider)

    @register: (AuthProvider) ->
      route =
        templateUrl: '/html/views/home.html'
        controller: 'HomeController'

    @$inject = ['$routeProvider', 'AuthProvider']

  ng.module('lft').config HomeRoute
