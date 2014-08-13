lft.directive 'lfDeviceCreator', ['Api', 'Auth', (Api, Auth) ->

  lfDeviceCreator =
    replace: true
    templateUrl: 'directives.device_creator'
    scope:
      devices: '='
    link: ($scope, $element, $attrs) ->
      addPermission = (device) ->
        user_id = Auth.user().id

        permission = new Api.DevicePermission
          user: user_id
          level: 1
          device: device.id

        Api.Device.register
          id: device.id

        permission.$save success, fail
        $scope.devices.push device

      success = (permission) ->
    
      fail = () ->
        console.log 'fail!'

      attempt = () ->
        device = new Api.Device $scope.device
        device.$save().then addPermission, fail

      $scope.keywatch = (evt) ->
        if evt.keyCode == 13
          attempt()

]
