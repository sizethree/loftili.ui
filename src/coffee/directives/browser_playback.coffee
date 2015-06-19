dBrowserPlayback = (BrowserPlayback) ->

  dBrowserPlaybackLink = ($scope, $element, $attrs) ->

    $scope.unsubscribe = () ->
      BrowserPlayback.stop()

    $scope.stop = () ->
      BrowserPlayback.pause()

    update = () ->
      $scope.current = BrowserPlayback.current
      $scope.stream = BrowserPlayback.stream

    BrowserPlayback.on 'update', update

  lfBrowserPlayback =
    replace: true
    templateUrl: 'directives.browser_playback'
    scope: {}
    link: dBrowserPlaybackLink


dBrowserPlayback.$inject = [
  'BrowserPlayback'
]

lft.directive 'lfBrowserPlayback', dBrowserPlayback
