_factory = ($resource, URLS) ->

  default_params =
    device_id: '@id'

  DeviceState = $resource [URLS.api, 'devicestates', ':device_id'].join('/'), default_params

_factory.$inject = ['$resource', 'URLS']

lft.service 'Api/DeviceState', _factory
