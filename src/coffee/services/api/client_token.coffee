_factory = ($resource, URLS) ->

  token_defaults =
    token_id: '@id'

  ClientToken = $resource [URLS.api, 'clienttokens', ':token_id'].join('/'), token_defaults,
    destroy:
      method: 'DELETE'

_factory.$inject = ['$resource', 'URLS']

lft.service 'Api/ClientToken', _factory
