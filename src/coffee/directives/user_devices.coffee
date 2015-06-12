dUserDevices = ($location, Lang, Api, Auth, Notifications) ->

  dUserDevicesLink = ($scope, $element, $attrs) ->

  lfUserDevices =
    replace: true
    templateUrl: 'directives.user_devices'
    scope:
      devices: '='
    link: dUserDevicesLink

dUserDevices.$inject = [
  '$location'
  'Lang'
  'Api'
  'Auth'
  'Notifications'
]

lft.directive 'lfUserDevices', dUserDevices
