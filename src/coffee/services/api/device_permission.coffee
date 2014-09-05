DevicePermissionFactory = ['$resource', 'URLS', ($resource, URLS) ->

  DevicePermission = $resource [URLS.api, 'devicepermissions', ':permission_id'].join('/'), {},
    query:
      method: 'GET'
      isArray: true
      interceptor:
        response: (response) ->
          return response

]

lft.service 'Api/DevicePermission', DevicePermissionFactory
