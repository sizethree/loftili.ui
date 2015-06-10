dDeviceStreamSearch = ($timeout, Api, Notifications, Socket, Lang, DEVICE_STATES) ->

  dDeviceStreamSearchLink = ($scope, $element, $attrs) ->
    timeout = null

    $scope.subscribe = (id) ->
      fail_lang = Lang 'merging.errors.subscribe'

      success = () ->
        $scope.manager.refresh()

      fail = () ->
        Notifications.flash.error fail_lang

      ($scope.manager.subscribe id).then success, fail

    run = () ->
      success = (streams) ->
        $scope.results = streams

      fail = () ->
        $scope.results = []

      if($scope.search.query.length == 0)
        $scope.results = []
      else
        (Api.Stream.query
          q: $scope.search.query).$promise.then success, fail

    $scope.search = () ->
      $timeout.cancel timeout
      timeout = $timeout run, 300
    
  lfDeviceStreamSearch =
    replace: true
    templateUrl: 'directives.device_stream_search'
    scope:
      manager: '='
    link: dDeviceStreamSearchLink

dDeviceStreamSearch.$inject = [
  '$timeout'
  'Api'
  'Notifications'
  'Socket'
  'Lang'
  'DEVICE_STATES'
]

lft.directive 'lfDeviceStreamSearch', dDeviceStreamSearch
