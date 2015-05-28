dDeviceControls = (Api, Notifications, Socket, Lang, DEVICE_STATES) ->

  to_i = (num) -> parseInt num, 10

  dDeviceControlsLink = ($scope, $element, $attrs) ->
    notification_id = null
    playing_lang = Lang 'device.playback.starting'
    stopping_lang = Lang 'device.playback.stopping'
    restarting_lang = Lang 'device.playback.restarting'
    failed_lang = Lang 'device.playback.failed'

    $scope.skip = () ->
      success = () ->

      fail = () ->
        failed_play = failed_lang.replace /{{action}}/, 'skip'
        Notifications.flash.error failed_play

      ($scope.manager.skip true).then success, fail

    $scope.play = () ->
      success = () ->

      fail = () ->
        failed_play = failed_lang.replace /{{action}}/, 'start'
        Notifications.flash.error failed_play

      ($scope.manager.play true).then success, fail

    $scope.stop = () ->
      success = () ->

      fail = () ->
        failed_play = failed_lang.replace /{{action}}/, 'stop'
        Notifications.flash.error failed_play

      ($scope.manager.stop true).then success, fail

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
