lft.controller 'DeviceManagementController', ['$scope', 'Api', 'device', 'permissions', ($scope, Api, device, permissions) ->

  $scope.device = device
  $scope.permissions = permissions

  $scope.removePermission = (permission) ->
    finish = () ->
      for p, i in $scope.permissions
        if p.id == permission.id
          $scope.permissions.splice i, 1

    request = Api.DevicePermission.delete
      permission_id: permission.id

    request.$promise.then finish


]
