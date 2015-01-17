_factory = (Api, Notifications, Lang, DEVICE_STATES) ->
  
  to_i = (num) -> parseInt num, 10

  lfDeviceControls =
    replace: true
    templateUrl: 'directives.device_controls'
    scope:
      manager: '='
    link: ($scope, $element, $attrs) ->
      notification_id = null
      playing_lang = Lang 'device.playback.starting'
      stopping_lang = Lang 'device.playback.stopping'
      restarting_lang = Lang 'device.playback.restarting'
      feed_loop_id = null

      $scope.current_track = null

      updateTrack = (current_track) ->
        $scope.current_track = current_track

      clear = () ->
        $scope.manager.feed.refresh()
        if notification_id
          Notifications.remove notification_id
     
      $scope.play = () ->
        $scope.manager.startPlayback().then clear, clear
        clear()
        notification_id = Notifications.add playing_lang

      $scope.stop = () ->
        $scope.manager.stopPlayback().then clear, clear
        clear()
        notification_id = Notifications.add stopping_lang

      $scope.restart = () ->
        $scope.manager.restartPlayback().then clear, clear
        clear()
        notification_id = Notifications.add restarting_lang

      update = (err, feed_response) ->
        if err
          $scope.player_state = DEVICE_STATES.ERRORED
        else
          $scope.player_state = to_i feed_response['player:state']
          $scope.manager.getCurrentTrack().then updateTrack, updateTrack

      $scope.$on '$destroy', () ->
        $scope.manager.feed.remove feed_loop_id

      feed_loop_id = $scope.manager.feed.add update

_factory.$inject = ['Api', 'Notifications', 'Lang', 'DEVICE_STATES']

lft.directive 'lfDeviceControls', _factory
