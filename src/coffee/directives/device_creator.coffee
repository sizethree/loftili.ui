_factory = (Api, Auth, Notifications, Lang, $timeout) ->

  link = ($scope, $element, $attrs) ->
    $scope.failures = []
    $scope.device = {}

    attempt = () ->
      device = $scope.device

      success = (created) ->
        if $scope.devices
          $scope.devices.push created

        $scope.device = {}

      fail = (response) ->
        lang = Lang 'device.errors.registration'
        Notifications.flash.error lang

      if device and device.name and device.serial_number
        (Api.Device.save
          name: device.name
          serial_number: device.serial_number
        ).$promise.then success, fail

    $scope.generate = () ->
      success = (serial) ->
        serial_number = serial.serial_number
        $scope.device.serial_number = serial_number

      fail = () ->
        console.log 'failed'

      (Api.DeviceSerial.save
        key: '123'
      ).$promise.then success, fail

    $scope.attempt = attempt

    $scope.keywatch = (evt) ->
      attempt true if evt.keyCode == 13

  lfDeviceCreator =
    replace: true
    templateUrl: 'directives.device_creator'
    scope:
      devices: '='
    link: link

_factory.$inject = [
  'Api'
  'Auth'
  'Notifications'
  'Lang'
  '$timeout'
]


lft.directive 'lfDeviceCreator', _factory
