lft.service 'Api', ['$resource', 'API_HOME', ($resource, API_HOME) ->

  Api = {}

  Api.User = $resource [API_HOME, 'users', ':user_id'].join('/')

  Api.Auth = $resource [API_HOME, 'auth'].join('/'), {},
    check:
      method: 'GET'
    attempt:
      method: 'POST'
    logout:
      method: 'DELETE'

  Api.Device = $resource [API_HOME, 'devices', ':device_id'].join('/'), {}

  Api.Track = $resource [API_HOME, 'tracks', ':track_id'].join('/'), {},
    upload:
      method: 'POST'
      params:
        track_id: 'upload'
      transformRequest: (data) ->
        fdt = new FormData()
        fdt.append 'file', data.track_file
        fdt

  # must be returned
  Api

]
