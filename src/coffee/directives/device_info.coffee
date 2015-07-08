dDeviceInfo = ($location, Api, Auth, Notifications, DPL, Lang) ->

  update_lang =
    name:
      success: Lang 'device.updating.name.success'
      error: Lang 'device.updating.name.error'

  dDeviceInfoLink = ($scope, $element, $attrs) ->
    feed_loop_id = null
    is_busy = false

    $scope.updates = {}
    $scope.current_user = Auth.user()

    $scope.dnd = () ->
      state = !$scope.device.do_not_disturb
      is_owner = $scope.is_owner()

      if is_busy or !is_owner
        return false

      is_busy = true

      wait_lang = Lang 'deivce.do_not_disturb.changing'
      note_id = Notifications.add wait_lang, 'info'

      success = () ->
        is_busy = false
        $scope.device.do_not_disturb = state
        Notifications.remove note_id

      fail = () ->
        is_busy = false
        Notifications.remove note_id

      (Api.Device.update
        id: $scope.device.id
        do_not_disturb: if state then 1 else 0
      ).$promise.then success, fail

    $scope.is_owner = () ->
      permissions = $scope.permissions or []
      cu = Auth.user()
      result = false

      if cu
        result = p for p in permissions when p.user.id == cu.id and p.level == DPL.OWNER

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
