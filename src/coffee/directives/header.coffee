lft.directive 'lfHeader', ['$rootScope', '$route', 'Auth', 'MenuManager', ($rootScope, $route, Auth, MenuManager) ->

  lfHeader =
    replace: true
    templateUrl: 'directives.header'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.user = () -> Auth.user()
      $scope.form_active = false
      manager_index = null

      $scope.logout = () ->
        Auth.logout()

      close = () ->
        $scope.form_active = false

      update = (evt, route_info) ->
        route_obj = route_info.$$route
        if route_obj and route_obj.name
          $scope.active_route = route_obj.name

      $rootScope.$on '$routeChangeSuccess', update

      $scope.closeLogin = () ->
        $scope.form_active = false
        MenuManager.remove manager_index

      $scope.toggle = (event) ->
        $scope.form_active = !$scope.form_active

        if $scope.form_active
          manager_index = MenuManager.register close
        else
          MenuManager.remove manager_index

        event.stopPropagation()

]
