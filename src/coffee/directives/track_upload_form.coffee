lft.directive 'lfTrackUploadForm', ['$timeout', 'Api', '$http', ($timeout, Api, $http) ->

  lfTrackUploadForm =
    replace: true
    templateUrl: 'directives.track_upload_form'
    scope:
      tracks: '='
    link: ($scope, $element, $attrs) ->
      $scope.uploading = []
      $scope.failures = []
      file_type_rgx = /audio\/.*/
      form = null

      validate = (file) ->
        is_audio = file_type_rgx.test file.type
        if not is_audio
          $scope.failures.push [file.name, 'is not a valid audio file!'].join(' ')
        is_audio

      clearFailures = () ->
        $scope.failures = []

      $scope.file = (input) ->
        clearFailures()
        fd_file = input.files[0]
        indx = null

        remove = () ->
          console.log 'finished upload...'
          $scope.uploading.splice (indx - 1), 1

        fail = () ->
          $scope.uploading.splice (indx - 1), 1

        if validate fd_file
          indx = $scope.uploading.push fd_file
          track = new Api.Track
            track_file: fd_file
          track.$upload().then remove, fail

        $scope.$digest()

]
