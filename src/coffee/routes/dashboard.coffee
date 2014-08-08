define [
  'ng'
  'services/auth',
  'controllers/dashboard'
], (ng) ->

  class DashboardRoute

    constructor: ($routeProvider, AuthProvider) ->
      route =
        templateUrl: '/html/views/dashboard.html'
        controller: 'DashboardController'
        resolve:
          ActiveUser: AuthProvider.filter('active').validator

      $routeProvider.when '/dashboard', route

    @$inject = ['$routeProvider', 'AuthProvider']

  ng.module('lft').config DashboardRoute
