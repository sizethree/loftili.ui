dAccountRequestForm = (Api, Notifications, Lang) ->

  sending_lang = Lang 'account.requesting.sending'
  finshed_lang = Lang 'account.requesting.finished'
  failed_lang = Lang 'account.requesting.failed'
  has_sent = false

  dAccountRequestFormLink = ($scope, $element, $attrs) ->
    sending = false
    $scope.has_sent = has_sent
    $scope.info = {}

    send = () ->
      sending = true
      $scope.has_sent = has_sent = true
      note_id = Notifications.add sending_lang, 'info'

      success = () ->
        sending = false
        Notifications.remove note_id
        Notifications.flash.success finshed_lang

      fail = () ->
        sending = false
        Notifications.remove note_id
        Notifications.flash.error failed_lang

      (Api.AccountRequest.save
        email: $scope.info.email).$promise.then success, fail

    $scope.send = () ->
      send true if !sending and !$scope.has_sent

  lfAccountRequestForm =
    replace: true
    templateUrl: 'directives.account_request_form'
    scope: { }
    link: dAccountRequestFormLink

dAccountRequestForm.$inject = [
  'Api'
  'Notifications'
  'Lang'
]

lft.directive 'lfAccountRequestForm', dAccountRequestForm
