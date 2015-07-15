dDeviceHistory = (TrackCache) ->

  dDeviceHistoryLink = ($scope, $element, $attrs) ->
    $scope.trackFor = (history) ->
      t = TrackCache.lookup history.track
      t

    $scope.itemDate = (d) ->
      d = new Date d.createdAt
      d.getTime()

    $scope.loader.next()

  lfDeviceHistory =
    replace: true
    templateUrl: 'directives.device_history'
    scope:
      device: '='
      loader: '='
    link: dDeviceHistoryLink


dDeviceHistory.$inject = [
  'TrackCache'
]


lft.directive 'lfDeviceHistory', dDeviceHistory
