_factory = ($resource, URLS) ->

  default_params =
    id: '@id'

  DeviceState = $resource [URLS.api, 'devicestates', ':id'].join('/'), default_params,
    subscribe:
      method: 'PATCH'

_factory.$inject = ['$resource', 'URLS']

lft.service 'Api/DeviceState', _factory
