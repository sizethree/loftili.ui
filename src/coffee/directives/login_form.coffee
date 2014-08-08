define [
  'ng'
  'services/api'
], (ng) ->


  LoginForm = (Api) ->
    replace: true
    templateUrl: '/html/directives/login_form.html'
    scope:
      credentials: '='
    link: ($scope, $element, $attrs) ->
      success = () ->
        console.log 'success!'

      fail = () ->
        console.log 'failed!'

      attempt = () ->
        Api.Auth.attempt($scope.credentials).$promise.then success, fail

      $scope.keywatch = (evt) ->
        if evt.keyCode == 13
          attempt()

  LoginForm.$inject = ['Api']

  ng.module('lft').directive 'lfLoginForm', LoginForm
