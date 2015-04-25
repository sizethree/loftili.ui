dDeviceInfo = ($location, Api, Notifications, Lang) ->

  link = ($scope, $element, $attrs) ->
    feed_loop_id = null
    $scope.last_checked = $scope.device.last_checked
    $scope.connection_status = null

    $scope.destroy = () ->
      success = () ->
        $location.url '/dashboard'

      fail = () ->

      (Api.Device.delete
        id: $scope.device.id).$promise.then success, fail

    $scope.removePermission = (permission) ->
      finish = () ->
        for p, i in $scope.permissions
          $scope.permissions.splice i, 1 if p.id == permission.id

      (Api.DevicePermission.delete
        id: permission.id).$promise.then finish

    update = (err, ping_response) ->
      if err
        $scope.last_checked = false
      else
        $scope.last_checked = ping_response.last_checked

    $scope.$on '$destroy', () ->
      $scope.manager.feed.remove feed_loop_id

    feed_loop_id = $scope.manager.feed.add update

  lfDeviceInfo =
    replace: true
    templateUrl: 'directives.device_info'
    scope:
      device: '='
      manager: '='
      permissions: '='
    link: link

dDeviceInfo.$inject = [
  '$location'
  'Api'
  'Notifications'
  'Lang'
]

lft.directive 'lfDeviceInfo', dDeviceInfo
