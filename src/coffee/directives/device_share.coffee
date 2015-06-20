dDeviceShare = ($timeout, Api, Auth, Lang, Notifications, DEVICE_PERMISSION_LEVELS) ->

  link = ($scope, $element, $attrs) ->
    query = ''
    busy = false
    $scope.results = []

    clear = () ->
      $scope.results = []

    remove = (permission) ->
      busy = true

      success = () ->
        busy = false

      fail = () ->
        busy = false

      (Api.DevicePermission.delete
        id: permission.id
      ).$promise.then success, fail

    share = (user) ->
      wait_lang = Lang 'device.sending_permission'
      note_id = Notifications.add wait_lang, 'info'
      busy = true

      success = (permission) ->
        Notifications.remove note_id
        busy = false
        $scope.permissions.push permission
        $scope.results = []

      fail = () ->
        bounce = false
        Notifications.remove note_id

      (Api.DevicePermission.save
        device: $scope.device.id
        user: user.id
        level: DEVICE_PERMISSION_LEVELS.FRIEND
      ).$promise.then success, fail

    $scope.share = (user) ->
      share user if !busy

    $scope.remove = (permission) ->
      remove permission if !busy

    success = (results) ->
      existing_ids = []
      unique_results = []
      existing_ids.push p.user.id for p in $scope.permissions

      for r in results
        existing = (existing_ids.indexOf r.id) >= 0
        unique_results.push r if !existing

      $scope.results = unique_results

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
  'Auth'
  'Lang'
  'Notifications'
  'DEVICE_PERMISSION_LEVELS'
]

lft.directive 'lfDeviceShare', dDeviceShare

