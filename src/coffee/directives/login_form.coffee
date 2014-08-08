define [
  'ng'
  'services/api'
], (ng) ->


  LoginForm = () ->
    replace: true
    templateUrl: '/html/directives/login_form.html'
    scope:
      credentials: '='
    link: ($scope, $element, $attrs) ->
      attempt = () ->
        console.log $scope.credentials

      $scope.keywatch = (evt) ->
        if evt.keyCode == 13
          attempt()

  LoginForm.$inject = ['Api']

  ng.module('lft').directive 'lfLoginForm', LoginForm
