define [
  'ng'
  'ngResource'
  'var/api_home'
], (ng, ngResource, API_HOME) ->

  ApiFactory = ($resource) ->

    Auth: $resource API_HOME + '/auth', {},
      check:
        method: 'GET'
      attempt:
        method: 'POST'
      logout:
        method: 'DELETE'

  ApiFactory['$inject'] = ['$resource']

  ng.module('lft').factory 'Api', ApiFactory

