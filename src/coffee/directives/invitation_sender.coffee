_factory = (Api, Notifications, Lang) ->

  lfInvitationSender =
    replace: true
    templateUrl: 'directives.invitation_sender'
    scope: {}
    link: ($scope, $element, $attrs) ->
      is_sending = false
      notification_closer = null

      success = (invitation) ->
        is_sending = false
        Notifications.remove notification_closer
        $scope.$emit 'invitation:sent', invitation
        $scope.email = ''

      fail = () ->
        is_sending = false
        Notifications.remove notification_closer

      send = () ->
        is_sending = true
        notification_closer = Notifications.add Lang('invitation.sending')

        request = Api.Invitation.save
          email: $scope.email

        request.$promise.then success, fail

      $scope.keywatch = (event) ->
        if event.keyCode == 13 and $scope.email and !is_sending
          send $scope.email


_factory.$inject = ['Api', 'Notifications', 'Lang']

lft.directive 'lfInvitationSender', _factory
