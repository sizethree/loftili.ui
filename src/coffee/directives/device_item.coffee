lft.directive 'lfDeviceItem', ['$timeout', 'DeviceManager', 'Notifications', 'Lang', ($timeout, DeviceManager, Notifications, Lang) ->

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: ($scope, $element, $attrs) ->
      manager = new DeviceManager $scope.device
      $scope.sharing = false
      $scope.connected = false

      $scope.stopShare = () ->
        $scope.sharing = false

      # public
      $scope.delete = (device) ->
        success = () ->
          $scope.ondelete()

        fail = () ->
          console.log 'the device was not removed!'

        device.$delete().then success, fail
       
      $scope.refresh = () ->
        notification_id = Notifications.add Lang('device.ping.start')

        success = (state) ->
          $scope.connected = state != null
          Notifications.remove notification_id
          Notifications.flash Lang('device.ping.success'), 'success'

        fail  = (response) ->
          $scope.connected = false
          Notifications.remove notification_id
          Notifications.flash Lang('device.ping.fail'), 'error'

        manager.getState().then success, fail

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
