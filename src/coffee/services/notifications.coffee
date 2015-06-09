NotificationsFactory = ($timeout) ->
  
  flash_timeout = 3000

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

  Notifications = {}

  Notifications.flash = (notification, type) ->
    notification_id = Notifications.add notification, type

    remove = () ->
      Notifications.remove notification_id

    $timeout remove, flash_timeout

  Notifications.add = (notification, type) ->
    new_id = idgen()

    notifications.push
      id: new_id
      message: notification
      type: type || 'info'

    trigger 'added'

    new_id

  Notifications.on = (evt, callback) ->
      if angular.isFunction(callback) and angular.isArray(listeners[evt])
        listeners[evt].push callback

  Notifications.get = () ->
    notifications

  Notifications.remove = (target_id) ->
    for notification, index in notifications
      if notification && target_id == notification.id
        notifications.splice index, 1
        trigger 'removed'
  
  Notifications.flash.error = (message) -> Notifications.flash message, 'error'
  Notifications.flash.success = (message) -> Notifications.flash message, 'success'
  Notifications.flash.info = (message) -> Notifications.flash message, 'info'

  Notifications

NotificationsFactory.$inject = ['$timeout']

lft.service 'Notifications', NotificationsFactory
