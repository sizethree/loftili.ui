lft.directive 'lfNotificationManager', ['Notifications', (Notifications) ->

  lfNotificationManager =
    replace: true
    templateUrl: 'directives.notification_manager'
    scope: {}
    link: ($scope, $element, $attrs) ->
      update = () ->
        $scope.notifications = Notifications.get()
      
      Notifications.on 'added', update
      Notifications.on 'removed', update

]
