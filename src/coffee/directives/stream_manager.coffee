dStreamManager = ($location, Lang, Api, Auth, Notifications) ->

  dStreamManagerLink = ($scope, $element, $attrs) ->
    busy = false

    update = (property) ->
      (value) ->
        old_value = $scope.manager.stream[property]

        success = () ->
          $scope.manager.stream[property] = value

        fail = () ->
          $scope.manager.stream[property] = old_value

        updates = {}
        updates[property] = value
        ($scope.manager.update updates).then success, fail

    $scope.destroy = () ->
      success =  () ->
        $location.url '/dashboard'

      fail = () ->
        fail_lang = Lang 'stream.errors.destroy'
        Notifications.flash.error fail_lang

      (Api.Stream.delete
        id: $scope.manager.stream.id).$promise.then success, fail

    $scope.updates =
      title: update 'title'
      description: update 'description'
      privacy: () ->
        current = $scope.manager.stream.privacy
        next = ++current % 2

        success = () ->
          $scope.manager.stream.privacy = next

        fail = () ->
          fail_lang = Lang 'stream.errors.privacy'
          Notifications.flash.error fail_lang

        ($scope.manager.update
          privacy: next).then success, fail

    $scope.remove = (index) ->
      success = () ->
        $scope.manager.refresh()

      fail = () ->
        lang = Lang 'streams.errors.removing_item'
        Notifications.flash.error lang

      ($scope.manager.remove index).then success, fail

    $scope.removePermission = (permission_id) ->
      return false if busy
      busy = true

      success = () ->
        busy = false
        $scope.manager.refresh()

      fail = () ->
        busy = false
        lang = Lang 'stream_permissions.errors.removing'
        Notifications.flash.error lang

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
  'Lang'
  'Api'
  'Auth'
  'Notifications'
]

lft.directive 'lfStreamManager', dStreamManager
