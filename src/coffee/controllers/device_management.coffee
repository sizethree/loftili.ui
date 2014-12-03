DeviceManagementController = ($scope, Api, device, permissions, device_queue, DeviceManager) ->
  $scope.device = device
  $scope.permissions = permissions
  $scope.queue = device_queue
  $scope.manager = new DeviceManager $scope.device

DeviceManagementController.$inject = [
  '$scope',
  'Api',
  'device',
  'permissions',
  'device_queue',
  'DeviceManager'
]

lft.controller 'DeviceManagementController', DeviceManagementController
