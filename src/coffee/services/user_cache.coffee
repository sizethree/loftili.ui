sUserCache = ($q, Api, ApiCache) ->

  ApiCache Api.User

sUserCache.$inject = [
  '$q',
  'Api',
  'ApiCache'
]

lft.service 'UserCache', sUserCache
