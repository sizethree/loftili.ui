lft.directive 'lfSignupForm', ['Api', 'Auth', '$location', (Api, Auth, $location) ->

  SignupForm =
    replace: true
    templateUrl: 'directives.signup_form'
    scope: {}
    link: ($scope, $element, $attrs) ->
      $scope.locked = false
      $scope.errors = []

      redirect = () ->
        $location.path('/dashboard')

      whoops = () ->

      sucess = (user) ->
        attempt = Auth.attempt $scope.credentials
        attempt.then redirect, whoops
        $scope.locked = false

      fail = (response) ->
        console.log response
        $scope.errors = ['unable to create an account']

      create = () ->
        $scope.locked = true
        user = new Api.User($scope.credentials)
        user.$save().then sucess, fail

      $scope.attempt = () ->
        create()

      $scope.keywatch = (evt) ->
        if evt.keyCode == 13
          create()

]
