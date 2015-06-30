dDeviceInfo = ($location, Api, Auth, Notifications, DPL, Lang) ->

  update_lang =
    name:
      success: Lang 'device.updating.name.success'
      error: Lang 'device.updating.name.error'

  dDeviceInfoLink = ($scope, $element, $attrs) ->
    feed_loop_id = null

    $scope.updates = {}
    $scope.current_user = Auth.user()

    $scope.is_owner = () ->
      permissions = $scope.permissions or []
      current_user = Auth.user()
      if current_user
        result = false
        for p in permissions
          continue if !p.user
          result = true if p.user.id == current_user.id and p.level == DPL.OWNER
        result

    $scope.updates.name = (new_name, input_scope, input_el) ->
      success = () ->
        $scope.device.name = new_name
        input_scope.blurOut true
        Notifications.flash.success update_lang.name.success

      fail = () ->
        input_el.val = input_scope.value = $scope.device.name
        input_scope.blurOut true
        Notifications.flash.error update_lang.name.error

      (Api.Device.update
        id: $scope.device.id
        name: new_name
      ).$promise.then success, fail

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

  lfDeviceInfo =
    replace: true
    templateUrl: 'directives.device_info'
    scope:
      device: '='
      manager: '='
      permissions: '='
      serial: '='
    link: dDeviceInfoLink

dDeviceInfo.$inject = [
  '$location'
  'Api'
  'Auth'
  'Notifications'
  'DEVICE_PERMISSION_LEVELS'
  'Lang'
]

lft.directive 'lfDeviceInfo', dDeviceInfo
