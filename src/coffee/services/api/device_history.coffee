DeviceHistoryFactory = ($resource, $q, URLS) ->

  device_defaults =
    id: '@id'

  DeviceHistory = $resource [URLS.api, 'history', ':id', 'tracks'].join('/'), device_defaults,
    get:
      isArray: true

DeviceHistoryFactory.$inject = [
  '$resource',
  '$q',
  'URLS'
]

lft.service 'Api/DeviceHistory', DeviceHistoryFactory
