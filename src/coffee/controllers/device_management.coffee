lft.controller 'DeviceManagementController', ['$scope', 'Api', 'device', 'permissions', ($scope, Api, device, permissions) ->

  $scope.device = device
  $scope.permissions = permissions


]
