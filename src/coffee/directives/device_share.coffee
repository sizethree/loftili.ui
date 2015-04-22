dDeviceShare = ($timeout, Api, DEVICE_PERMISSION_LEVELS) ->

  link = ($scope, $element, $attrs) ->
    query = ''
    $scope.results = []

    clear = () ->
      $scope.results = []

    success = (results) ->
      $scope.results = results

    fail = () ->
      $scope.results = []

    gather = () ->
      (Api.User.search
        q: $scope.search.query).$promise.then success, fail

    $scope.search = (evt) ->
      query = $scope.search.query
      if query == ''
        clear()
      else
        gather()

  lfDeviceShare =
    replace: true
    templateUrl: 'directives.device_share'
    scope:
      device: '='
      permissions: '='
    link: link

dDeviceShare.$inject = [
  '$timeout'
  'Api'
  'DEVICE_PERMISSION_LEVELS'
]

lft.directive 'lfDeviceShare', dDeviceShare

