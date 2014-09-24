PasswordResetFactory = ['$resource', '$q', 'URLS', ($resource, $q, URLS) ->

  PasswordReset = $resource [URLS.api, 'passwordreset'].join('/'), {}

]

lft.service 'Api/PasswordReset', PasswordResetFactory
