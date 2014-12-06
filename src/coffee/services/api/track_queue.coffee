TrackQueueService = ['$resource', 'URLS', ($resource, URLS) ->

  queue_defaults =
    id: '@id'

  TrackQueue = $resource [URLS.api, 'queues', ':id'].join('/'), queue_defaults,
    add:
      method: 'PUT'
      isArray: true

]

lft.service 'Api/TrackQueue', TrackQueueService

