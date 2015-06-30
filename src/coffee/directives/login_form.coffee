dLoginForm = ($location, Auth, Api, Notifications, Lang, Analytics) ->

  isFn = angular.isFunction

  linkFn = ($scope, $element, $attrs) ->
    $scope.creds = {}
    $scope.errors = []
    $scope.state = 0

    $scope.signup = () ->
      $location.url '/signup'
      $scope.close() if $scope.close and angular.isFunction $scope.close
      true

    $scope.attempt = (event) ->
      success = () ->
        Analytics.event 'authentication', 'success', 'login_form'
        $location.path('/dashboard')

      fail = () ->
        Analytics.event 'authentication', 'fail', 'login_form'
        $scope.errors = [
          'Invalid credentials.'
        ]

      Analytics.event 'authentication', 'attempt', 'login_form'

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
        Analytics.event 'authentication', 'password_reset:email_sent', $scope.creds.reset_email
        $scope.state = 2

      fail = () ->
        Analytics.event 'authentication', 'password_reset:fail', $scope.creds.reset_email
        $scope.errors = ['Hmm, try again']

      finish = (user) ->
        Analytics.event 'authentication', 'password_reset:finished', $scope.creds.reset_email
        $scope.creds.email = user.email
        $scope.creds.password = $scope.creds.new_password
        $scope.attempt()

      if $scope.state == 0
        $scope.state = 1
      else if $scope.state == 1
        Analytics.event 'authentication', 'password_reset:start', $scope.creds.reset_email
        reset = Api.PasswordReset.save
          user: $scope.creds.reset_email
        reset.$promise.then success, fail
      else if $scope.state = 2
        Analytics.event 'authentication', 'password_reset:update_with_token', $scope.creds.reset_email
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

  LoginForm =
    replace: true
    templateUrl: 'directives.login_form'
    scope:
      close: '='
    link: linkFn

dLoginForm.$inject = [
  '$location'
  'Auth'
  'Api'
  'Notifications'
  'Lang'
  'Analytics'
]

lft.directive 'lfLoginForm', dLoginForm
