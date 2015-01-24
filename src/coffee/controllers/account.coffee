_factory = ($scope, activeUser, Api, Notifications, Lang, ClientManager, clientTokens, clients, invitations) ->

  $scope.user = activeUser
  $scope.clients = clients
  $scope.client_tokens = clientTokens
  $scope.client_manager = new ClientManager clientTokens, clients
  $scope.invitations = invitations

  inviteSent = (event, invite) ->
    $scope.invitations.push invite

  $scope.$on 'invitation:sent', inviteSent

  $scope.fields =
    password: ''
    password_confirm: ''

  $scope.errors = []

  save = () ->
    $scope.user.password = $scope.fields.password
    request = Api.User.update
      id: $scope.user.id
      password: $scope.fields.password

    success = () ->
      success_lang = Lang('account.password.change.success')
      Notifications.flash success_lang, 'success'
      $scope.changing_password = false

    fail = () ->
      fail_lang = Lang('account.password.change.fail')
      Notifications.flash fail_lang, 'error'
      $scope.changing_password = false

    request.$promise.then success, fail

  attempt = () ->
    valid_pasword = $scope.fields.password != ""
    valid_confirm = $scope.fields.password_confirm != ""
    matching = $scope.fields.password == $scope.fields.password_confirm

    if valid_confirm and valid_pasword and matching
      save()
    else
      $scope.errors = ['Passwords must match']

  $scope.passwordToggle = (state) ->
    $scope.changing_password = state

  $scope.savePassword = () ->
    attempt()
    
  $scope.update = (type, evt) ->
    $scope.errors = []
    if evt.keyCode == 13
      attempt()
    else
      val = evt.srcElement.value
      $scope.fields[type] = val

_factory.$inject = [
  '$scope',
  'activeUser',
  'Api',
  'Notifications',
  'Lang',
  'ClientManager',
  'clientTokens',
  'clients',
  'invitations'
]

lft.controller 'AccountController', _factory
