_factory = ($q, DM, Auth, Api, Notifications, Lang) ->

  link = ($scope, $element, $attrs) ->
    $scope.manager = new DM $scope.device

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: link

_factory.$inject = [
  '$q'
  'DeviceManager'
  'Auth'
  'Api'
  'Notifications'
  'Lang'
]

lft.directive 'lfDeviceItem', _factory
