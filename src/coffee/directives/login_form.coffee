lft.directive 'lfLoginForm', ['$location', 'Auth', ($location, Auth) ->

  LoginForm =
    replace: true
    templateUrl: 'directives.login_form'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.creds = {}
      $scope.errors = []

      success = () ->
        $location.path('/dashboard')

      fail = () ->
        $scope.errors = ['Hmm, try again']

      $scope.attempt = (event) ->
        Auth.attempt($scope.creds).then success, fail
        if event
          event.stopPropagation()

      $scope.keywatch = (evt) ->
        $scope.errors = []
        if evt.keyCode == 13
          $scope.attempt()

  LoginForm

]
