DeviceManagementController = ($scope, Api, DeviceManager, resolutions...) ->

  $scope.device = resolutions[0].device
  $scope.serial = resolutions[0].serial_number
  $scope.permissions = resolutions[1]
  $scope.manager = DeviceManager $scope.device

  $scope.manager.refresh()

  stream = (err) ->

  $scope.manager.connect stream

DeviceManagementController.$inject = [
  '$scope'
  'Api'
  'DeviceManager'
  'device_info'
  'permissions'
]

lft.controller 'DeviceManagementController', DeviceManagementController
