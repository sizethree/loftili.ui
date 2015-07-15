DeviceManagementController = ($scope, Api, DeviceManager, DeviceHistoryLoader, resolutions...) ->

  $scope.device = resolutions[0].device
  $scope.serial = resolutions[0].serial_number
  $scope.permissions = resolutions[1]
  $scope.manager = DeviceManager $scope.device
  $scope.history_loader = DeviceHistoryLoader $scope.device

  $scope.manager.refresh()

  stream = (err) ->

  $scope.$on '$destroy', () ->
    $scope.manager.close()

  $scope.manager.connect stream

DeviceManagementController.$inject = [
  '$scope'
  'Api'
  'DeviceManager'
  'DeviceHistoryLoader'
  'device_info'
  'permissions'
]

lft.controller 'DeviceManagementController', DeviceManagementController
