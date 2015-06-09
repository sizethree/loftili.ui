dStreamPermissionControl = ($q, $timeout, Api, Lang, Notifications) ->

  dStreamPermissionControlLink = ($scope, $element, $attrs) ->
    last_attempt = null
    $scope.results = []

    $scope.addUser = (user, index) ->
      success = () ->
        $scope.results.splice index, 1
        $scope.manager.refresh()

      fail = () ->
        lang = Lang 'stream_permissions.errors.adding'
        Notifications.flash.error lang

      (Api.StreamPermission.save
        stream: $scope.manager.stream.id
        user: user.id
        level: 4).$promise.then success, fail

    $scope.search = (evt) ->
      $timeout.cancel last_attempt if last_attempt

      success = (results) ->
        $scope.results = results
        $scope.menus = new Array results.length
        $scope.busy = false

      fail = () ->
        $scope.busy = false
        $scope.results = []

      run = () ->
        query = $scope.search.query
        $scope.busy = true
        (Api.User.search
          q: query).$promise.then success, fail

      last_attempt = $timeout run, 300

  lfStreamPermissionControl =
    replace: true
    templateUrl: 'directives.stream_permission_control'
    scope:
      manager: '='
    link: dStreamPermissionControlLink


dStreamPermissionControl.$inject = [
  '$q',
  '$timeout',
  'Api'
  'Lang'
  'Notifications'
]

lft.directive 'lfStreamPermissionControl', dStreamPermissionControl
