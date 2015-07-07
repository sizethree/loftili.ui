dStreamPermissionControl = ($q, $timeout, Api, Lang, Notifications) ->

  dStreamPermissionControlLink = ($scope, $element, $attrs) ->
    last_attempt = null
    $scope.results = []

    $scope.addUser = (user, index) ->
      return false if $scope.sending == true

      sending_lang = Lang 'streams.sending_permission'
      note_id = Notifications.add sending_lang, 'info'
      $scope.sending = true

      success = () ->
        $scope.results.splice index, 1
        $scope.manager.refresh()
        $scope.sending = false
        Notifications.remove note_id

      fail = () ->
        lang = Lang 'stream_permissions.errors.adding'
        $scope.sending = false
        Notifications.remove note_id
        Notifications.flash.error lang

      (Api.StreamPermission.save
        stream: $scope.manager.stream.id
        user: user.id
        level: 4).$promise.then success, fail

    $scope.search = (evt) ->
      $timeout.cancel last_attempt if last_attempt

      success = (results) ->
        existing_users = []
        unique_users = []

        for p in $scope.manager.permissions
          existing_users.push p.user

        for r in results
          user = r.id
          existing = (existing_users.indexOf user) >= 0
          unique_users.push user if !existing
          true

        $scope.results = unique_users

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
