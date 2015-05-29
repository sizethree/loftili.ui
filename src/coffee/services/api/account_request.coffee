AccountRequestFactory = ($resource, $q, URLS) ->

  device_defaults =
    id: '@id'

  AccountRequest = $resource [URLS.api, 'accountrequests', ':id'].join('/'), device_defaults,
    delete:
      method: 'DELETE'

AccountRequestFactory.$inject = [
  '$resource',
  '$q',
  'URLS'
]

lft.service 'Api/AccountRequest', AccountRequestFactory
