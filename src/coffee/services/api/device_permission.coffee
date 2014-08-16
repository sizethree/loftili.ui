lft.service 'Api/DevicePermission', ['$resource', 'API_HOME', ($resource, API_HOME) ->

  DevicePermission = $resource [API_HOME, 'devicepermissions', ':permission_id'].join('/'), {},
    query:
      method: 'GET'
      isArray: true
      interceptor:
        response: (response) ->
          return response

]
