StreamManagementController = ($scope, Api, resolved) ->

  $scope.manager = resolved.manager
  $scope.devices = resolved.devices
  $scope.my_devices = []
  $scope.my_devices.push device.id for device in resolved.devices

StreamManagementController.$inject = [
  '$scope'
  'Api'
  'resolved'
]

lft.controller 'StreamManagementController', StreamManagementController
