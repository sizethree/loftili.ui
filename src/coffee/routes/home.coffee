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
        resolve:
          AuthState: new AuthProvider.resolver('any').validator

    @$inject = ['$routeProvider', 'AuthProvider']

  ng.module('lft').config HomeRoute
