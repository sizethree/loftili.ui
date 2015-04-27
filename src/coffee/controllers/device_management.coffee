DeviceManagementController = ($scope, Api, DeviceManager, resolutions...) ->

  $scope.device = resolutions[0]
  $scope.permissions = resolutions[1]
  $scope.queue = resolutions[2]
  $scope.manager = DeviceManager $scope.device

  stream = (err) ->

  $scope.manager.connect stream

DeviceManagementController.$inject = [
  '$scope'
  'Api'
  'DeviceManager'
  'device'
  'permissions'
  'device_queue'
]

lft.controller 'DeviceManagementController', DeviceManagementController
