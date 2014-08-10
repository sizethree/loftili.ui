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
        user = new Api.User($scope.credentials)
        user.$save().then sucess, fail

      $scope.attempt = () ->
        create()

      $scope.keywatch = (evt) ->
        $scope.errors = []
        if evt.keyCode == 13
          create()

]
