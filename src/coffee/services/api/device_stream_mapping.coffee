DeviceStreamMappingFactory = ($resource, $q, URLS) ->

  default_params =
    id: '@id'

  DeviceStreamMapping = $resource [URLS.api, 'devicestreammappings', ':id'].join('/'), default_params

DeviceStreamMappingFactory.$inject = [
  '$resource',
  '$q',
  'URLS'
]

lft.service 'Api/DeviceStreamMapping', DeviceStreamMappingFactory
