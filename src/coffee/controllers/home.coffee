define [
  'ng'
], (ng) ->

  HomeController = ($scope) ->

    $scope.credentials =
      email: ''
      password: ''

  HomeController['$inject'] = ['$scope']

  ng.module('lft').controller 'HomeController', HomeController
