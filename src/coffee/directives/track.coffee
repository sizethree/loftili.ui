dTrack = (Lang, Notifications, Audio) ->

  dTrackLink = ($scope, $element, $attrs) ->
    is_dropping = false
    notification_id = null
    dropping_lang = Lang 'library.tracks.dropping'
    sound = null

    dropSuccess = () ->
      Notifications.remove notification_id
      is_dropping = false

    dropFail = () ->
      Notifications.remove notification_id
      is_dropping = false

    dropTrack = () ->
      notification_id = Notifications.add dropping_lang, 'info'
      track_id = $scope.track.id
      promise = $scope.manager.dropTrack track_id
      promise.then dropSuccess, dropFail

    stopped = () ->
      $scope.playing = false

    makeSound = () ->
      sound = new Audio.Sound $scope.track
      sound.on 'stop', stopped

    $scope.play = () ->
      $scope.playing = true
      if !sound
        makeSound()
      sound.play()

    $scope.stop = () ->
      $scope.playing = false
      sound.stop()

    $scope.drop = () ->
      if is_dropping
        false
      else
        is_dropping = true
        dropTrack()

    cleanup = () ->
      $scope.stop()

    $scope.$on '$destroy', cleanup

  lfTrack =
    replace: true
    templateUrl: 'directives.track'
    scope:
      track: '='
      manager: '='
    link: dTrackLink

dTrack.$inject = [
  'Lang'
  'Notifications'
  'Audio'
]

lft.directive 'lfTrack', dTrack
