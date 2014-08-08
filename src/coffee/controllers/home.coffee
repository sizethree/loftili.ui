define [
  'ng'
], (ng) ->

  class HomeController

    constructor: (AuthState) ->

    @$inject = ['AuthState']

  ng.module('lft').controller 'HomeController', [HomeController]
