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
      $scope.resetting = false

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
          if $scope.close and isFn($scope.close)
            $scope.close()

        fail = () ->
          $scope.errors = ['Hmm, try again']

        if !$scope.resetting
          $scope.resetting = true
        else
          reset = Api.PasswordReset.save
            user: $scope.creds.reset_email
          reset.$promise.then success, fail

      $scope.cancel = () ->
        if $scope.resetting
          $scope.resetting = false
        else
          if $scope.close and isFn($scope.close)
            $scope.close()

      $scope.keywatch = (evt) ->
        $scope.errors = []
        if evt.keyCode == 13 and !$scope.resetting
          $scope.attempt()

  LoginForm

]
