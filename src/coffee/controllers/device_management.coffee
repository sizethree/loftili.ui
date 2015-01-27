_factory = ($scope, Api, device, permissions, device_queue, DeviceManager) ->

  $scope.device = device
  $scope.permissions = permissions
  $scope.queue = device_queue
  $scope.manager = new DeviceManager $scope.device

_factory.$inject = [
  '$scope',
  'Api',
  'device',
  'permissions',
  'device_queue',
  'DeviceManager'
]

lft.controller 'DeviceManagementController', _factory
