lft.directive 'lfDeviceShare', ['$timeout', 'Api', 'DEVICE_PERMISSION_LEVELS', ($timeout, Api, DEVICE_PERMISSION_LEVELS) ->

  lfDeviceShare =
    replace: true
    templateUrl: 'directives.device_share'
    scope:
      device: '='
    link: ($scope, $element, $attrs) ->
      timeout_promise = null

      $scope.results = []

      $scope.search = (event) ->
        if timeout_promise
          $timeout.cancel timeout_promise
        timeout_promise = $timeout search, 400

      $scope.share = (user) ->
        new_permission = new Api.DevicePermission
          user: user.id
          device: $scope.device.id
          level: DEVICE_PERMISSION_LEVELS.FRIEND
        new_permission.$save()

      finish = (user_results) ->
        $scope.results = user_results

      clear = () ->
        $scope.results = []

      search = () ->
        query = $scope.search.query
        if query == ''
          clear()
        else
          search_req = Api.User.search
            q: query
          search_req.$promise.then finish, clear
        

]
