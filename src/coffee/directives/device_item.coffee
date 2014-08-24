lft.directive 'lfDeviceItem', ['$timeout', 'Api', 'Auth', 'Notifications', 'Lang', ($timeout, Api, Auth, Notifications, Lang) ->

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: ($scope, $element, $attrs) ->
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

      $scope.stop = () ->
        params =
          track: 1
          device: $scope.device.id

        success = () -> console.log arguments
        fail = () -> console.log arguments

        Api.Playback.stop(params).$promise.then success, fail

      $scope.play = () ->
        params =
          track: 1
          device: $scope.device.id

        success = () -> console.log arguments
        fail = () -> console.log arguments

        Api.Playback.start(params).$promise.then success, fail
       
      $scope.refresh = () ->
        notification_id = Notifications.add Lang('device.ping.started')

        success = (response) ->
          if(response.updatedAt)
            $scope.device.updatedAt = response.updatedAt

          $scope.device.status = true
          Notifications.remove notification_id
          Notifications.flash Lang('device.ping.success'), 'success'

        fail  = (response) ->
          if(response.data && response.data.updatedAt)
            $scope.device.updatedAt = response.data.updatedAt

          $scope.device.status = false
          Notifications.remove notification_id
          Notifications.flash Lang('device.ping.failed'), 'error'

        Api.Device.ping({device_id: $scope.device.id}).$promise.then success, fail

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
