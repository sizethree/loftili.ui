_factory = ($q, Api) ->

  class LibraryManager

    constructor: (@user, @library) ->

    dropTrack: (track_id) ->
      deferred = $q.defer()

      success = () =>
        for track, indx in @library
          if track.id = track_id
            @library.splice indx, 1
            break

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
