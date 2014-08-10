lft.directive 'lfHeader', ['Auth', 'MenuManager', (Auth, MenuManager) ->

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

      $scope.toggle = (event) ->
        $scope.form_active = !$scope.form_active

        if $scope.form_active
          manager_index = MenuManager.register close
        else
          MenuManager.remove manager_index

        event.stopPropagation()

]
