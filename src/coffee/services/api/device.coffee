DeviceFactory = ['$resource', '$q', 'URLS', ($resource, $q, URLS) ->

  device_defaults =
    id: '@id'

  Device = $resource [URLS.api, 'devices', ':id', ':fn'].join('/'), device_defaults,
    update:
      method: 'PUT'
    delete:
      method: 'DELETE'
    ping:
      method: 'GET'
      params:
        fn: 'ping'

]

lft.service 'Api/Device', DeviceFactory
