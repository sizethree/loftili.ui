dDeviceControls = (Api, Notifications, Socket, Lang, TrackCache, ArtistCache, DEVICE_STATES) ->

  to_i = (num) -> parseInt num, 10

  STOPPING_LANG = Lang 'device.playback.stopping'
  STARTING_LANG = Lang 'device.playback.starting'
  FAILED_LANG = Lang 'device.playback.failed'

  dDeviceControlsLink = ($scope, $element, $attrs) ->
    notification_id = null
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
        if track.artist
          (ArtistCache track.artist).then finish, fail
        else
          finish null

      fail = () ->
        $scope.current_track = null
        nav = ['stream']

      (TrackCache track_id).then loadedTrack, fail if track_id > 0

    $scope.unsubscribe = () ->
      note_id = Notifications.add STOPPING_LANG, 'info'

      success = () ->
        Notifications.remove note_id
        $scope.manager.refresh()

      fail = () ->
        Notifications.remove note_id
        Notifications.flash.error FAILED_LANG

      ($scope.manager.subscribe 0).then success, fail

    $scope.setPlayback = (state) ->
      message = if state then STARTING_LANG else STOPPING_LANG
      note_id = Notifications.add message, 'info'

      success = () ->
        Notifications.remove note_id
        $scope.manager.refresh()

      fail = () ->
        Notifications.remove note_id
        Notifications.flash.error FAILED_LANG

      ($scope.manager.playback state).then success, fail

    update = (initial) ->
      $scope.stream_manager = $scope.manager.stream
      state = $scope.manager.state
      $scope.current_track = null
      nav = ['stream']
      nav_index = 0
      $scope.active_nav = nav[nav_index]

      $scope.playback = state and (parseInt state.playback) == 1

      if state and (parseInt state.current_track) > 0
        updateTrack 1

      true

    listener_id = $scope.manager.on 'update', update

    cleanup = () ->
      $scope.manager.off listener_id

    $scope.$on '$destroy', cleanup

    update 1

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
  'TrackCache'
  'ArtistCache'
  'DEVICE_STATES'
]

lft.directive 'lfDeviceControls', dDeviceControls
