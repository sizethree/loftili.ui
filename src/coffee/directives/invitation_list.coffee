_factory = (Api, Notifications, Lang) ->

  lfInvitationList =
    replace: true
    templateUrl: 'directives.invitation_list'
    scope:
      invitations: '='
    link: ($scope, $element, $attrs) ->
      is_sending = false

      $scope.destroy = (invitation) ->
        indx = -1

        for inv, i in $scope.invitations
          if inv.id == invitation.id
            indx = i

        sucess = () ->
          $scope.invitations.splice indx, 1

        fail = () ->
          fail_lang = Lang 'invitation.failed_remove'
          Notifications.flash fail_lang, 'error'

        request = Api.Invitation.destroy
          invite_id: invitation.id

        request.$promise.then sucess, fail

_factory.$inject = ['Api', 'Notifications', 'Lang']

lft.directive 'lfInvitationList', _factory
