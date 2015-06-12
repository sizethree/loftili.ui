dUserStreams = ($location, Lang, Api, Auth, Notifications) ->

  assert = (obj, prop, length) ->
    obj[prop] and obj[prop].length > length

  dUserStreamsLink = ($scope, $element, $attrs) ->
    $scope.new_stream = {}
    $scope.saving = false

    makeStream = (stream) ->
      success = (created_stream) ->
        $scope.streams.push created_stream

      fail = () ->
        failed_lang = Lang 'streams.errors.create'
        Notifications.flash.error failed_lang

      (Api.Stream.save
        title: stream.title
        description: stream.description).$promise.then success, fail

    $scope.createStream = () ->
      new_stream = $scope.new_stream
      makeStream new_stream if (assert new_stream, 'title', 2) and (assert new_stream, 'title', 2)

  lfUserStreams =
    replace: true
    templateUrl: 'directives.user_streams'
    scope:
      streams: '='
    link: dUserStreamsLink

dUserStreams.$inject = [
  '$location'
  'Lang'
  'Api'
  'Auth'
  'Notifications'
]

lft.directive 'lfUserStreams', dUserStreams
