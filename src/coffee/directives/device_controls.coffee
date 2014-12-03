lft.directive 'lfDeviceControls', ['Api', 'Notifications', 'Lang', 'DEVICE_STATES', (Api, Notifications, Lang, DEVICE_STATES) ->

  lfDeviceControls =
    replace: true
    templateUrl: 'directives.device_controls'
    scope:
      manager: '='
    link: ($scope, $element, $attrs) ->
      notification_id = null
      playing_lang = Lang 'device.playback.starting'
      stopping_lang = Lang 'device.playback.stopping'

      $scope.device_state = null

      $scope.playing = () ->
        $scope.device_state == DEVICE_STATES.PLAYING
      
      $scope.play = () ->
        $scope.manager.startPlayback().then getState, getState

        if notification_id
          Notifications.remove notification_id

        notification_id = Notifications.add playing_lang

      $scope.stop = () ->
        $scope.manager.stopPlayback().then getState, getState

        if notification_id
          Notifications.remove notification_id

        notification_id = Notifications.add stopping_lang
      
      update = (response) ->
        ping = response.ping
        status = if ping.status then ping.status else false
        if /stopped/i.test status
          $scope.device_state = DEVICE_STATES.STOPPED
        else if /playing/i.test status
          $scope.device_state = DEVICE_STATES.PLAYING

      getState = () ->
        if notification_id
          Notifications.remove notification_id

        $scope.device_state = null

        $scope.manager.getState().then update

      getState()


]
