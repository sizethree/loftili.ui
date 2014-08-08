define [
  'ng'
], (ng) ->

  DashboardController = (ActiveUser, $scope, Auth) ->
    $scope.logout = () ->
      Auth.logout()

  DashboardController['$inject'] = ['ActiveUser', '$scope', 'Auth']

  ng.module('lft').controller 'DashboardController', DashboardController
