NotificationsFactory = ($timeout) ->
  
  flash_timeout = 1500

  idgen = do () ->
    notification_count = 0
    () ->
      [notification_count++, 'notification'].join '-'

  notifications = []
  listeners =
    'added': []
    'removed': []

  trigger = (type) ->
    cb() for cb in listeners[type]

  Notifications =

    flash: (notification, type) ->
      notification_id = Notifications.add notification, type

      remove = () ->
        Notifications.remove notification_id

      $timeout remove, flash_timeout

    add: (notification, type) ->
      new_id = idgen()

      notifications.push
        id: new_id
        message: notification
        type: type || 'info'

      trigger 'added'

      new_id

    on: (evt, callback) ->
      if angular.isFunction(callback) and angular.isArray(listeners[evt])
        listeners[evt].push callback

    get: () ->
      notifications

    remove: (target_id) ->
      for notification, index in notifications
        if notification && target_id == notification.id
          notifications.splice index, 1
          trigger 'removed'

NotificationsFactory.$inject = ['$timeout']

lft.service 'Notifications', NotificationsFactory
