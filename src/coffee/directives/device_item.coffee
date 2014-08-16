lft.directive 'lfDeviceItem', ['Api', 'Auth', (Api, Auth) ->

  lfDeviceItem =
    replace: true
    templateUrl: 'directives.device_item'
    scope:
      device: '='
      ondelete: '&'
      index: '='
    link: ($scope, $element, $attrs) ->
      $scope.delete = (device) ->
        success = () ->
          $scope.ondelete()

        fail = () ->
          console.log 'the device was not removed!'

        device.$delete().then success, fail
        Api.DnsRecord.delete({device: device.id, user: Auth.user().id})

      $scope.report = () ->
        $scope.device.$report()


]
