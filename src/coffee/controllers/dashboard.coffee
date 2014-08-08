define [
  'ng'
], (ng) ->

  class DashboardController

    constructor: (AuthState) ->

    @$inject = ['AuthState']

  ng.module('lft').controller 'DashboardController', [DashboardController]
