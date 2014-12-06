lft.directive 'lfDeviceInfo', ['Api', (Api) ->

  lfDeviceInfo =
    replace: true
    templateUrl: 'directives.device_info'
    scope:
      device: '='
      permissions: '='
    link: ($scope, $element, $attrs) ->
      $scope.saveIp = (ip_addr, scope) ->
        success = () ->
          $scope.device.ip_addr = ip_addr

        fail = () ->
          scope.val = $scope.device.ip_addr

        request = Api.Device.update
          id: $scope.device.id
          ip_addr: ip_addr

        request.$promise.then success, fail

      $scope.removePermission = (permission) ->
        finish = () ->
          for p, i in $scope.permissions
            if p.id == permission.id
              $scope.permissions.splice i, 1

        request = Api.DevicePermission.delete
          permission_id: permission.id

        request.$promise.then finish


]
