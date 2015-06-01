sEventManager = () ->

  makeId = do ->
    indx = 0
    () -> [++indx, '_'].join ''

  EventManagerFactory = (events) ->
    listeners = []
    listeners[e] = [] for e in events

    add = (evt, fn) ->
      is_valid = (angular.isFunction fn) and (angular.isArray listeners[evt])
      if is_valid
        cid = makeId()
        listeners[evt].push
          fn: fn
          cid: cid
        cid
      else
        false

    remove = (id) ->
      check = (group) ->
        for c, i in group
          group.splice i, 1 if c.cid == id

      check listeners[group] for group of listeners

    trigger = (evt, data) ->
      c.fn(data) for c in listeners[evt]

    EventManager =
      on: add
      off: remove
      trigger: trigger

  EventManagerFactory
  


sEventManager.$inject = [
]

lft.service 'EventManager', sEventManager
