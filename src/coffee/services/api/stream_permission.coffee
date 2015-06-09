StreamPermissionFactory = ($resource, $q, URLS) ->

  defaults =
    id: '@id'

  StreamPermission = $resource [URLS.api, 'streampermissions', ':id'].join('/'), defaults, {}

StreamPermissionFactory.$inject = ['$resource', '$q', 'URLS']

lft.service 'Api/StreamPermission', StreamPermissionFactory
