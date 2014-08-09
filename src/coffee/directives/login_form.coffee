lft.directive 'lfLoginForm', ['Auth', '$location', (Auth, $location) ->

  LoginForm =
    replace: true
    templateUrl: 'directives.login_form'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.credentials = {}
      $scope.errors = []

      success = () ->
        $location.path('/dashboard')

      fail = () ->
        $scope.errors = ['unable to create an account - make sure you\'ve entered enough info']

      $scope.attempt = () ->
        Auth.attempt($scope.credentials).then success, fail

      $scope.keywatch = (evt) ->
        $scope.errors = []
        if evt.keyCode == 13
          $scope.attempt()

  LoginForm

]
