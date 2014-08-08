define [
  'ng'
  'services/auth'
], (ng) ->

  class AuthConfig

    constructor: (AuthProvider) ->

    @$inject: ['AuthProvider']

  ng.module('lft').config AuthConfig
