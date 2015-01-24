_factory = (Api, Auth, $location) ->

  SignupForm =
    replace: true
    templateUrl: 'directives.signup_form'
    scope:
      token: '='
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
        errors = []

        addError = (err) ->
          clean = err.replace(/_/g, ' ')
          errors.push clean

        if response and response.data
          addError err for err, val of response.data.invalidAttributes

        message = ['You need to enter better values for', errors.join(', ')].join(' ')
        $scope.errors = [message]

      create = () ->
        $scope.locked = true

        params = angular.extend $scope.credentials,
          token: if $scope.token then $scope.token.token else false

        user = new Api.User params

        user.$save().then sucess, fail

      $scope.attempt = () ->
        create()

      $scope.keywatch = (evt) ->
        $scope.errors = []
        if evt.keyCode == 13
          create()


_factory.$inject = ['Api', 'Auth', '$location']


lft.directive 'lfSignupForm', _factory
