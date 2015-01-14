_factory = ($resource, URLS) ->

  Client = $resource [URLS.api, 'clients'].join('/')

_factory.$inject = ['$resource', 'URLS']

lft.service 'Api/Client', _factory
