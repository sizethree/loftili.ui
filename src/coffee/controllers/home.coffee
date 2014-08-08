define [
  'ng'
  'directives/login_form'
  'directives/signup_form'
], (ng) ->

  HomeController = ($scope) ->

    $scope.credentials =
      email: ''
      password: ''

  HomeController['$inject'] = ['$scope']

  ng.module('lft').controller 'HomeController', HomeController
