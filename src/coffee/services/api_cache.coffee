sApiCache = ($q, Api) ->

  ApiCache = (model) ->
    cache = {}

    Cache = (id) ->
      deferred = $q.defer()

      success = (instance) ->
        cache[instance.id] = instance
        deferred.resolve instance

      fail = () ->
        deferred.reject false

      if cache[id]
        deferred.resolve cache[id]
      else
        (model.get {id: id}).$promise.then success, fail

      deferred.promise

    Cache.lookup = (id) -> cache[id]

    Cache



sApiCache.$inject =[
  '$q',
  'Api'
]

lft.service 'ApiCache', sApiCache
