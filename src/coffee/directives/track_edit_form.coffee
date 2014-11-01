lft.directive 'lfTrackEditForm', [() ->

  lfTrackEditForm =
    replace: true
    templateUrl: 'directives.track_edit_form'
    scope:
      track: '='
    link: ($scope, $element, $attr) ->
      $scope.edits = { track: {} }
      angular.copy $scope.track, $scope.edits.track

      trySave = () ->
        $scope.track.title = $scope.edits.track.title
        $scope.track.$update()

      $scope.keywatch = (evt) ->
        key_code = evt.keyCode

        if key_code == 13
          trySave()

]
