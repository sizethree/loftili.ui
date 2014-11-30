lft.directive 'lfDeviceControls', ['Api', 'DEVICE_STATES', (Api, DEVICE_STATES) ->

  lfDeviceControls =
    replace: true
    templateUrl: 'directives.device_controls'
    scope:
      device: '='
    link: ($scope, $element, $attrs) ->
      $scope.device_state = null
      
      $scope.play = () ->
        request = Api.Playback.start
          device: $scope.device.id
        request.$promise.then getState, getState

      $scope.stop = () ->
        request = Api.Playback.stop
          device: $scope.device.id
        request.$promise.then getState, getState
      
      update = (response) ->
        ping = response.ping
        status = if ping.status then ping.status else false
        if /stopped/i.test status
          $scope.device_state = DEVICE_STATES.STOPPED
        else if /playing/i.test status
          $scope.device_state = DEVICE_STATES.PLAYING

      getState = () ->
        $scope.device_state = null

        request = Api.Device.ping
          device_id: $scope.device.id

        request.$promise.then update

      getState()


]
