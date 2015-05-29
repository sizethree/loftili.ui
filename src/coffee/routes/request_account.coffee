rRequestAccount = ($routeProvider) ->

  RequestRoute =
    controller: 'RequestAccountController'
    templateUrl: 'views.request_account'
    name: 'request_account'
    title: 'Join today!'

  $routeProvider.when '/join', RequestRoute

rRequestAccount.$inject = [
  '$routeProvider'
]

lft.config rRequestAccount
