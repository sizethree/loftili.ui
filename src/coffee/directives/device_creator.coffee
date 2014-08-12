lft.directive 'lfDeviceCreator', ['Api', 'Auth', (Api, Auth) ->

  lfDeviceCreator =
    replace: true
    templateUrl: 'directives.device_creator'
    scope:
      devices: '='
    link: ($scope, $element, $attrs) ->
      success = (device) ->
        $scope.devices.push device

      fail = () ->
        console.log 'fail!'

      attempt = () ->
        device = angular.extend $scope.device,
          owner: Auth.user().id

        device = new Api.Device device
        device.$save().then success, fail

      $scope.keywatch = (evt) ->
        if evt.keyCode == 13
          attempt()

]
