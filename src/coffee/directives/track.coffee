_factory = (Lang, Notifications) ->

  lfTrack =
    replace: true
    templateUrl: 'directives.track'
    scope:
      track: '='
      manager: '='
    link: ($scope, $elements, $attrs) ->
      is_dropping = false
      notification_id = null
      dropping_lang = Lang 'library.tracks.dropping'

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

      $scope.drop = () ->
        if is_dropping
          false
        else
          is_dropping = true
          dropTrack()

_factory.$inject = ['Lang', 'Notifications']

lft.directive 'lfTrack', _factory
