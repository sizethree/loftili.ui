define [
  'ng'
], (ng) ->

  class HomeController

    constructor: (AuthState) ->
      console.log arguments

    @$inject = ['AuthState']

  ng.module('lft').controller 'HomeController', [HomeController]
