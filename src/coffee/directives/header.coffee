lft.directive 'lfHeader', ['Auth', (Auth) ->

  lfHeader =
    replace: true
    templateUrl: 'directives.header'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.user = () -> Auth.user()
      $scope.form_active = false

      $scope.logout = () ->
        Auth.logout()

      $scope.toggle = () ->
        $scope.form_active = !$scope.form_active

]
