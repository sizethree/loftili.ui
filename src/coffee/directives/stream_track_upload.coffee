dStreamTrackUpload = ($rootScope, $location, Lang, Api, Auth, Notifications) ->

  dStreamTrackUploadLink = ($scope, $element, $attrs) ->
    upload = (file) ->
      loading_lang = Lang 'streams.uploading_track'
      note_id = Notifications.add loading_lang, 'info'

      fail = () ->
        fail_lang = Lang 'upload.errors.upload'
        Notifications.remove note_id

      finish = () ->
        $scope.manager.refresh()
        Notifications.remove note_id

      success = (track) ->
        ($scope.manager.add track.id).then finish, fail

      (Api.Track.upload
        track_file: file).$promise.then success, fail

    $scope.file = (input) ->
      file_fd = input.files[0]

      if /audio\/.*/i.test file_fd.type
        upload file_fd
      else
        invalid_lang = Lang 'upload.errors.type'
        Notifications.flash.error invalid_lang

      $rootScope.$digest()

  lfStreamTrackUpload =
    replace: true
    templateUrl: 'directives.stream_track_upload'
    scope:
      manager: '='
    link: dStreamTrackUploadLink

dStreamTrackUpload.$inject = [
  '$rootScope'
  '$location'
  'Lang'
  'Api'
  'Auth'
  'Notifications'
]

lft.directive 'lfStreamTrackUpload', dStreamTrackUpload
