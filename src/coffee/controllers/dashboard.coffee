define [
  'ng'
  'directives/login_form'
], (ng) ->

  DashboardController = (ActiveUser, $scope, Auth) ->
    $scope.logout = () ->
      Auth.logout()


  DashboardController['$inject'] = ['ActiveUser', '$scope', 'Auth']

  ng.module('lft').controller 'DashboardController', DashboardController
