_factory = ($resource, URLS) ->

  default_params =
    id: '@id'

  DeviceState = $resource [URLS.api, 'devicestates', ':id'].join('/'), default_params,
    subscribe:
      method: 'PATCH'
      url: [URLS.api, 'devicestates', ':id', 'stream'].join '/'
    playback:
      method: 'PATCH'
      url: [URLS.api, 'devicestates', ':id', 'playback'].join '/'

_factory.$inject = ['$resource', 'URLS']

lft.service 'Api/DeviceState', _factory
