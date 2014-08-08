define [
  'ng'
  'services/api'
], (ng) ->

  SignupForm = () ->
    replace: true
    templateUrl: '/html/directives/signup_form.html'
    link: ($scope, $element, $attrs) ->

  SignupForm['$inject'] = []

  ng.module('lft').directive 'lfSignupForm', SignupForm
