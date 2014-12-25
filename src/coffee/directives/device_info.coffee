lft.directive 'lfDeviceInfo', ['Api', 'Notifications', 'Lang', (Api, Notifications, Lang) ->

  lfDeviceInfo =
    replace: true
    templateUrl: 'directives.device_info'
    scope:
      device: '='
      permissions: '='
    link: ($scope, $element, $attrs) ->
      $scope.savePort = (port, scope, element) ->
        params =
          id: $scope.device.id
          port: port

        success = () ->
          lang = Lang 'device.updating.port.success'
          $scope.device.port = port
          Notifications.flash lang, 'success'
          scope.blurOut()

        fail = () ->
          scope.val = $scope.device.port

        new_device = new Api.Device params
        new_device.$update().then success, fail

      $scope.saveIp = (ip_addr, scope) ->
        params =
          id: $scope.device.id
          ip_addr: ip_addr

        success = () ->
          lang = Lang 'device.updating.ip_addr.success'
          $scope.device.ip_addr = ip_addr
          Notifications.flash lang, 'success'
          scope.blurOut()

        fail = () ->
          scope.val = $scope.device.ip_addr

        new_device = new Api.Device params
        new_device.$update().then success, fail

      $scope.removePermission = (permission) ->
        finish = () ->
          for p, i in $scope.permissions
            if p.id == permission.id
              $scope.permissions.splice i, 1

        request = Api.DevicePermission.delete
          permission_id: permission.id

        request.$promise.then finish


]
