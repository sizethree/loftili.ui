lft.directive 'lfDeviceItem', ['Api', 'Auth', (Api, Auth) ->

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: ($scope, $element, $attrs) ->
      # private
      pingSuccess = (response) ->
        if(response.device)
          $scope.device.updatedAt = response.device.updatedAt

        $scope.device.status = true

      pingFail = (response) ->
        if(response.device)
          $scope.device.updatedAt = response.device.updatedAt

        $scope.device.status = false

      # public
      $scope.delete = (device) ->
        success = () ->
          $scope.ondelete()

        fail = () ->
          console.log 'the device was not removed!'

        device.$delete().then success, fail

        # To.Do - success and fail!
        Api.DnsRecord.delete
          device: device.id
          user: Auth.user().id

      $scope.play = () ->
        params =
          track: 1
          device: $scope.device.id

        success = () -> console.log arguments
        fail = () -> console.log arguments

        Api.Playback.start(params).$promise.then success, fail
       

      $scope.refresh = () ->
        Api.Device.ping({device_id: $scope.device.id}).$promise.then pingSuccess, pingFail

      $scope.revertPropery = (property, value) ->
        $scope.device[property] = value

      $scope.saveProperty = (property, value) ->
        $scope.device[property] = value

        # To.do - notifications
        success = () -> console.log 'passed update'

        # To.do - notifications and loader
        fail = () -> console.log 'failed update'

        $scope.device.$save().then success, fail

]
