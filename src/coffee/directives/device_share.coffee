lft.directive 'lfDeviceShare', ['$timeout', 'Api', 'DEVICE_PERMISSION_LEVELS', ($timeout, Api, DEVICE_PERMISSION_LEVELS) ->

  lfDeviceShare =
    replace: true
    templateUrl: 'directives.device_share'
    scope:
      device: '='
    link: ($scope, $element, $attrs) ->
      timeout_promise = null
      $scope.last_results = null
      $scope.shared_ids = null
      $scope.results = []

      filter = () ->
        $scope.results = []
        for user in $scope.last_results
          if $scope.shared_ids.indexOf(user.id) < 0
            $scope.results.push user

      finish = (user_results) ->
        $scope.last_results = user_results

        addAndFilter = (permissions) ->
          $scope.shared_ids = []
          $scope.shared_ids.push permission.user.id for permission in permissions
          filter()

        if $scope.shared_ids == null
          shared_with_req = Api.DevicePermission.search
            device: $scope.device.id
          shared_with_req.$promise.then addAndFilter
        else
          filter()

      clear = () ->
        $scope.results = []

      gather = () ->
        query = $scope.search.query
        search_req = Api.User.search
          q: query
        search_req.$promise.then finish, clear

      search = () ->
        query = $scope.search.query
        if query == ''
          clear()
        else
          gather()
        
      $scope.search = (event) ->
        if timeout_promise
          $timeout.cancel timeout_promise
        timeout_promise = $timeout search, 400

      $scope.share = (user) ->
        add = () ->
          $scope.shared_ids.push user.id
          filter()

        new_permission = new Api.DevicePermission
          user: user.id
          device: $scope.device.id
          level: DEVICE_PERMISSION_LEVELS.FRIEND

        new_permission.$save().then add

]
