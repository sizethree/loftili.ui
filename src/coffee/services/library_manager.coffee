_factory = ($q, Api) ->

  class LibraryManager

    constructor: (@user, @library) ->

    dropTrack: (track_id) ->
      deferred = $q.defer()

      target_index = null

      for track, index in @library
        target_index = index if track.id == track_id

      success = () =>
        @library.splice target_index, 1
        deferred.resolve()

      fail = () ->
        deferred.reject()

      request = Api.User.dropTrack
        track: track_id
        user: @user.id

      request.$promise.then success, fail

      deferred.promise

_factory.$inject = ['$q', 'Api']

lft.service 'LibraryManager', _factory
