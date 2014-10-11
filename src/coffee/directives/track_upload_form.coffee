lft.directive 'lfTrackUploadForm', ['Api', 'Notifications', (Api, Notifications) ->

  lfTrackUploadForm =
    replace: true
    templateUrl: 'directives.track_upload_form'
    scope:
      tracks: '='
    link: ($scope, $element, $attrs) ->
      $scope.uploading = []
      $scope.failures = []
      $scope.searching = false
      file_type_rgx = /audio\/.*/
      form = null

      validate = (file) ->
        is_audio = file_type_rgx.test file.type
        if not is_audio
          $scope.failures.push [file.name, 'is not a valid audio file!'].join(' ')
        is_audio

      clearFailures = () ->
        $scope.failures = []

      $scope.toggleSearch = () ->
        $scope.searching = !($scope.searching)

        if !$scope.searching
          $scope.$broadcast 'closed'

      $scope.file = (input) ->
        clearFailures()
        fd_file = input.files[0]
        indx = null

        success = (new_track) ->
          $scope.uploading.splice (indx - 1), 1
          if $scope.tracks and angular.isArray $scope.tracks
            $scope.tracks.push new_track

        fail = (response) ->
          $scope.uploading.splice (indx - 1), 1
          Notifications.flash 'error', response

        if validate fd_file
          indx = $scope.uploading.push fd_file
          track = new Api.Track
            track_file: fd_file
          track.$upload().then success, fail

        $scope.$digest()

]
