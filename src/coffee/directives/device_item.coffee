_factory = (DeviceManager, Notifications, Lang) ->

  link = ($scope, $element, $attrs) ->
    $scope.manager = new DeviceManager $scope.device
    $scope.sharing = false

    $scope.toggleShare = () ->
      $scope.sharing = !$scope.sharing

    $scope.stopShare = () ->
      $scope.sharing = false

    $scope.delete = (device) ->
      success = () ->
        $scope.ondelete()

      fail = () ->
        console.log 'the device was not removed!'

      (device.$delete true).then success, fail

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: link

_factory.$inject = [
  'DeviceManager'
  'Notifications'
  'Lang'
]

lft.directive 'lfDeviceItem', _factory
