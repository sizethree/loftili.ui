StreamManagementController = ($scope, Api, resolved) ->

  $scope.manager = resolved

StreamManagementController.$inject = [
  '$scope'
  'Api'
  'resolved'
]

lft.controller 'StreamManagementController', StreamManagementController
