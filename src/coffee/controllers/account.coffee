AccountControllerFactory = ['$scope', 'activeUser', 'Api', 'Notifications', 'Lang', ($scope, activeUser, Api, Notifications, Lang) ->

  $scope.user = activeUser
  $scope.password = ""
  $scope.password_confirm = ""
  $scope.errors = []

  save = () ->
    $scope.user.password = $scope.password
    promise = $scope.user.$update()

    success = () ->
      success_lang = Lang('account.password.change.success')
      Notifications.flash success_lang, 'success'
      $scope.changing_password = false

    fail = () ->
      fail_lang = Lang('account.password.change.fail')
      Notifications.flash fail_lang, 'error'
      $scope.changing_password = false

    promise.then success, fail

  attempt = () ->
    valid_pasword = $scope.password != ""
    valid_confirm = $scope.password_confirm != ""
    matching = $scope.password == $scope.password_confirm
    if valid_confirm and valid_pasword and matching
      save()
    else
      $scope.errors = ['Passwords must match']

  $scope.startPasswordChange = () ->
    $scope.changing_password = true

  $scope.savePassword = () ->
    attempt()
    
  $scope.update = (type, evt) ->
    $scope.errors = []
    if evt.keyCode == 13
      attempt()
    else
      val = evt.srcElement.value
      $scope[type] = val

]

lft.controller 'AccountController', AccountControllerFactory
