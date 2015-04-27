dDeviceControls = (Api, Notifications, Socket, Lang, DEVICE_STATES) ->

  to_i = (num) -> parseInt num, 10

  dDeviceControlsLink = ($scope, $element, $attrs) ->
    notification_id = null
    playing_lang = Lang 'device.playback.starting'
    stopping_lang = Lang 'device.playback.stopping'
    restarting_lang = Lang 'device.playback.restarting'

    clear = () ->

    $scope.play = () ->
      $scope.manager.play true

    $scope.stop = () ->
      $scope.manager.stop true

    $scope.restart = () ->

  lfDeviceControls =
    replace: true
    templateUrl: 'directives.device_controls'
    scope:
      manager: '='
    link: dDeviceControlsLink

dDeviceControls.$inject = [
  'Api'
  'Notifications'
  'Socket'
  'Lang'
  'DEVICE_STATES'
]

lft.directive 'lfDeviceControls', dDeviceControls
