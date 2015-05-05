TrackQueueService = ['$resource', 'URLS', ($resource, URLS) ->

  queue_defaults =
    id: '@id'

  TrackQueue = $resource [URLS.api, 'queues', ':id', ':position'].join('/'), queue_defaults,
    add:
      method: 'PUT'
    remove:
      method: 'DELETE'
    current:
      method: 'GET'
      params:
        position: 'current'

]

lft.service 'Api/TrackQueue', TrackQueueService

