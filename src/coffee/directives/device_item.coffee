lft.directive 'lfDeviceItem', ['Api', 'Auth', (Api, Auth) ->

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: ($scope, $element, $attrs) ->
      $scope.delete = (device) ->
        success = () ->
          $scope.ondelete()

        fail = () ->
          console.log 'the device was not removed!'

        device.$delete().then success, fail
        Api.DnsRecord.delete({device: device.id, user: Auth.user().id})

      pingSuccess = (response) ->
        if(response.device)
          console.log response.device.updatedAt
          $scope.device.updatedAt = response.device.updatedAt

        $scope.device.status = true

      pingFail = (response) ->
        if(response.device)
          $scope.device.updatedAt = response.device.updatedAt

        $scope.device.status = false

      $scope.refresh = () ->
        Api.Device.ping({device_id: $scope.device.id}).$promise.then pingSuccess, pingFail


]
