lft.controller 'DeviceManagementController', ['$scope', 'Api', 'device', 'permissions', 'device_queue', ($scope, Api, device, permissions, device_queue) ->

  $scope.device = device
  $scope.permissions = permissions
  $scope.queue = device_queue

]
