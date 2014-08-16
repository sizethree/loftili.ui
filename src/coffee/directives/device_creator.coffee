lft.directive 'lfDeviceCreator', ['Api', 'Auth', '$timeout', (Api, Auth, $timeout) ->

  lfDeviceCreator =
    replace: true
    templateUrl: 'directives.device_creator'
    scope:
      devices: '='
    link: ($scope, $element, $attrs) ->
      $scope.failures = []

      addPermission = (device) ->
        user_id = Auth.user().id

        permission = new Api.DevicePermission
          user: user_id
          level: 1
          device: device.id

        dns_entry = new Api.DnsRecord
          user: user_id
          device: device.id

        setStatus = (response) ->
          console.log arguments

        ping = () ->
          Api.Device.ping({device_id: device.id}).$promise.then setStatus

        dns_entry.$save().then ping, dnsFail
        permission.$save()
        $scope.devices.push device

      dnsFail = () ->
        $scope.failures.push 'Unable to create a dns entry for your device!'
        $timeout clearErrors, 2500

      addError = (error) ->
        $scope.failures.push error

      clearErrors = () ->
        $scope.failures = []

      fail = (response) ->
        if response and response.data
          addError ['You need to enter a better value for', error].join(' ') for error, val of response.data.invalidAttributes
        else
          addError 'Unable to get a response from the server'
        $timeout clearErrors, 2500

      attempt = () ->
        device = new Api.Device $scope.device
        device.$save().then addPermission, fail

      $scope.keywatch = (evt) ->
        if evt.keyCode == 13
          attempt()

]
