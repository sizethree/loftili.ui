define [
  'ng'
  'directives/login_form'
], (ng) ->

  class DashboardController

    constructor: (AuthState) ->

    @$inject = ['AuthState']

  ng.module('lft').controller 'DashboardController', [DashboardController]
