dDeviceControls = (Api, Notifications, Socket, Lang, DEVICE_STATES) ->

  to_i = (num) -> parseInt num, 10

  dDeviceControlsLink = ($scope, $element, $attrs) ->
    notification_id = null
    stopping_lang = Lang 'device.playback.stopping'
    failed_lang = Lang 'device.playback.failed'
    nav_index = 0
    nav = ['stream', 'track']
    $scope.active_nav = nav[nav_index]

    $scope.next = () ->
      nav_index = 0 if ++nav_index >= nav.length
      $scope.active_nav = nav[nav_index]

    updateTrack = () ->
      state = $scope.manager.state
      track_id = state and parseInt state.current_track, 10
      loaded_track = null

      finish = (artist) ->
        $scope.current_track = loaded_track
        $scope.current_artist = artist
        nav = ['stream', 'track']
        nav_index = 1
        $scope.active_nav = 'track'

      loadedTrack = (track) ->
        loaded_track = track
        (Api.Artist.get {id: track.artist}).$promise.then finish, fail

      fail = () ->
        $scope.current_track = null
        nav = ['stream']

      (Api.Track.get {id: track_id}).$promise.then loadedTrack, fail if track_id > 0

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
        $scope.manager.refresh().then update

      fail = () ->
        Notifications.remove note_id
        Notifications.flash.error failed_lang

      ($scope.manager.playback state).then success, fail

    update = () ->
      $scope.stream_manager = $scope.manager.stream
      state = $scope.manager.state
      $scope.current_track = null
      nav = ['stream']
      nav_index = 0
      $scope.active_nav = nav[nav_index]

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
