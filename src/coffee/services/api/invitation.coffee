_factory = ($resource, URLS) ->

  default_params =
    invite_id: '@id'

  Invitation = $resource [URLS.api, 'invitations', ':invite_id'].join('/'), default_params,
    destroy:
      method: 'DELETE'

_factory.$inject = ['$resource', 'URLS']

lft.service 'Api/Invitation', _factory
