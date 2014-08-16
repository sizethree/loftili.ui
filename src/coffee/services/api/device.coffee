DeviceFactory = ($resource, $q, API_HOME) ->

  device_defaults =
    device_id: '@id'

  Device = $resource [API_HOME, 'devices', ':device_id', ':fn'].join('/'), device_defaults,
    delete:
      method: 'DELETE'

lft.service 'Api/Device', [
  '$resource',
  '$q',
  'API_HOME',
  DeviceFactory
]


