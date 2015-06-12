dDeviceControls = (Api, Notifications, Socket, Lang, DEVICE_STATES) ->

  to_i = (num) -> parseInt num, 10

  dDeviceControlsLink = ($scope, $element, $attrs) ->
    notification_id = null
    stopping_lang = Lang 'device.playback.stopping'
    failed_lang = Lang 'device.playback.failed'

    updateTrack = () ->
      state = $scope.manager.state
      track_id = state and parseInt state.current_track, 10

      success = (track) ->
        $scope.current_track = track

      fail = () ->
        $scope.current_track = null

      (Api.Track.get {id: track_id}).$promise.then success, fail if track_id > 0

    $scope.unsubscribe = () ->
      note_id = Notifications.add stopping_lang, 'info'

      success = () ->
        Notifications.remove note_id
        $scope.manager.refresh()

      fail = () ->
        Notifications.remove note_id
        Notifications.flash.error failed_lang

      ($scope.manager.subscribe 0).then success, fail

    $scope.setPlayback = (state) ->
      note_id = Notifications.add stopping_lang, 'info'

      success = () ->
        Notifications.remove note_id
        $scope.manager.refresh()

      fail = () ->
        Notifications.remove note_id
        Notifications.flash.error failed_lang

      ($scope.manager.playback state).then success, fail

    update = () ->
      $scope.stream_manager = $scope.manager.stream
      state = $scope.manager.state
      $scope.current_track = null
      $scope.playback = state and (parseInt state.playback) == 1
      updateTrack() if state and (parseInt state.current_track) > 0

    listener_id = $scope.manager.on 'update', update

    $scope.$on '$destroy', () ->
      $scope.manager.off listener_id

    update()

  lfDeviceControls =
    replace: true
    templateUrl: 'directives.device_controls'
    scope:
      manager: '='
    link: dDeviceControlsLink

dDeviceControls.$inject = [
  'Api'
  'Notifications'
  'Socket'
  'Lang'
  'DEVICE_STATES'
]

lft.directive 'lfDeviceControls', dDeviceControls
