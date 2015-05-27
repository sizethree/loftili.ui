DeviceSerialFactory = ['$resource', '$q', 'URLS', ($resource, $q, URLS) ->

  device_defaults =
    id: '@id'

  DeviceSerial = $resource [URLS.api, 'deviceserials', ':id', ':fn'].join('/'), device_defaults,
    delete:
      method: 'DELETE'

]

lft.service 'Api/DeviceSerial', DeviceSerialFactory
