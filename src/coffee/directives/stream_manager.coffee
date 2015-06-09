dStreamManager = ($location, Api, Auth, Notifications, Lang) ->

  dStreamManagerLink = ($scope, $element, $attrs) ->
    busy = false

    $scope.remove = (index) ->
      success = () ->
        $scope.manager.refresh()

      fail = () ->

      ($scope.manager.remove index).then success, fail

    $scope.removePermission = (permission_id) ->
      return false if busy
      busy = true

      success = () ->
        busy = false
        $scope.manager.refresh()

      fail = () ->
        busy = false

      (Api.StreamPermission.delete
        id: permission_id).$promise.then success, fail
        

  lfStreamManager =
    replace: true
    templateUrl: 'directives.stream_manager'
    scope:
      manager: '='
    link: dStreamManagerLink

dStreamManager.$inject = [
  '$location'
  'Api'
  'Auth'
  'Notifications'
  'Lang'
]

lft.directive 'lfStreamManager', dStreamManager
