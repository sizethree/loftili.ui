lft.directive 'lfLoginForm', ['$location', 'Auth', 'Api', 'Notifications', 'Lang', ($location, Auth, Api, Notifications, Lang) ->

  isFn = angular.isFunction

  LoginForm =
    replace: true
    templateUrl: 'directives.login_form'
    scope:
      close: '='
    link: ($scope, $element, $attrs) ->
      $scope.creds = {}
      $scope.errors = []
      $scope.state = 0

      $scope.attempt = (event) ->
        success = () ->
          $location.path('/dashboard')

        fail = () ->
          $scope.errors = ['Hmm, try again']

        promise = Auth.attempt
          email: $scope.creds.email
          password: $scope.creds.password

        promise.then success, fail

        if event
          event.stopPropagation()

      $scope.reset = () ->
        success_lang = Lang('reset_password.success')

        success = () ->
          Notifications.flash success_lang, 'info'
          $scope.state = 2

        fail = () ->
          $scope.errors = ['Hmm, try again']

        finish = (user) ->
          $scope.creds.email = user.email
          $scope.creds.password = $scope.creds.new_password
          $scope.attempt()

        if $scope.state == 0
          $scope.state = 1
        else if $scope.state == 1
          reset = Api.PasswordReset.save
            user: $scope.creds.reset_email
          reset.$promise.then success, fail
        else if $scope.state = 2
          reset = Api.User.update
            id: 'reset'
            password: $scope.creds.new_password
            reset_token: $scope.creds.reset_token
          reset.$promise.then finish, fail

      $scope.cancel = () ->
        if $scope.state > 0
          $scope.state = 0
        else
          if $scope.close and isFn($scope.close)
            $scope.close()

      $scope.keywatch = (evt) ->
        $scope.errors = []
        if evt.keyCode == 13 and $scope.state == 0
          $scope.attempt()

  LoginForm

]
