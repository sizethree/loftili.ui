dSignupForm = (Api, Auth, $location) ->

  dSignupFormLink = ($scope, $element, $attrs) ->
    $scope.locked = false
    $scope.errors = []

    redirect = () ->
      $location.path('/dashboard')

    sucess = (user) ->
      attempt = Auth.attempt $scope.credentials
      attempt.then redirect, redirect
      $scope.locked = false

    fail = (response) ->
      errors = []
      data = response.data

      if /duplicate/i.test data
        $scope.duplicate = true
      else
        $scope.errored = true

    $scope.key = () ->
      $scope.errored = false
      $scope.duplicate = false

    create = () ->
      $scope.locked = true

      params = angular.extend $scope.credentials,
        token: if $scope.token then $scope.token.token else false

      (Api.User.save params).$promise.then sucess, fail

    $scope.attempt = () ->
      create()

  SignupForm =
    replace: true
    templateUrl: 'directives.signup_form'
    scope:
      token: '='
    link: dSignupFormLink


dSignupForm.$inject = ['Api', 'Auth', '$location']


lft.directive 'lfSignupForm', dSignupForm
