define [
  'ng'
  'services/auth'
], (ng) ->

  class AuthConfig

    constructor: (AuthProvider) ->
      console.log AuthProvider

    @$inject: ['AuthProvider']

  ng.module('lft').config AuthConfig
