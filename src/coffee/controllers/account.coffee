_factory = ($scope, activeUser, ClientManager, AccountManager, clientTokens, clients, invitations) ->

  $scope.user = activeUser

  $scope.clients = clients
  $scope.client_tokens = clientTokens
  $scope.client_manager = new ClientManager clientTokens, clients

  $scope.invitations = invitations

  $scope.account_manager = new AccountManager $scope.user

  inviteSent = (event, invite) ->
    $scope.invitations.push invite

  $scope.$on 'invitation:sent', inviteSent

_factory.$inject = [
  '$scope',
  'activeUser',
  'ClientManager',
  'AccountManager',
  'clientTokens',
  'clients',
  'invitations'
]

lft.controller 'AccountController', _factory
