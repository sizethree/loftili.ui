dSignupForm = (Api, Auth, Notifications, $location) ->

  dSignupFormLink = ($scope, $element, $attrs) ->
    $scope.locked = false
    $scope.errors = []
    note_id = null

    redirect = () ->
      $location.path('/dashboard')

    sucess = (user) ->
      Notifications.remove note_id
      attempt = Auth.attempt $scope.credentials
      attempt.then redirect, redirect
      $scope.locked = false
      note_id = false

    fail = (response) ->
      Notifications.remove note_id
      note_id = false
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
      if note_id
        return false

      $scope.locked = true
      note_id = Notifications.add 'Creating account, please wait', 'info'

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


dSignupForm.$inject = [
  'Api'
  'Auth'
  'Notifications'
  '$location'
]


lft.directive 'lfSignupForm', dSignupForm
