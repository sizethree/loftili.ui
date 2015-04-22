_factory = () ->

  is_fn = angular.isFunction
  is_arr = angular.isArray

  uuid = do ->
    id = 0
    () -> ['$', ++id].join ''


  px = (val) ->
    [val, 'px'].join ''

  instances = []
  maestro = null

  lookup = (id) ->
    indx = -1
    for popup, i in instances
      indx = i if popup.id == id
    indx

  class Maestro

    constructor: (@scope, @element) ->
      maestro = @
      @instances = []

    find: (id) ->
      indx = -1
      for instance, i in @instances
        indx = i if instance.id == id
      indx

    open: (id) ->
      instance = @instances[@find id]

      open = () =>
        placement = instance.placement
        bounding = placement[0].getBoundingClientRect()

        instance.container.css
          'display': 'block'
          'position': 'absolute'
          'left': px bounding.left
          'top': px bounding.top

      open true if instance


    close: (id) ->
      instance = @instances[@find id]

      close = () ->
        instance.container.css 'display', 'none'

      close true if instance

    append: (element, scope, placement) ->
      new_id = uuid true
      container = angular.element '<div class="popup-instance"></div>'

      @instances.push
        id: new_id
        scope: scope
        element: element
        container: container
        placement: placement

      container.append element
      @element.append container

      new_id

    remove: (id) ->
      indx = @find id
      instances = @instances

      remove = () ->
        instance = instances[indx]
        instance.container.remove()
        instances.splice indx, 1

      remove true if indx >= 0

  Maestro.$inject = [
    '$scope'
    '$element'
  ]

  PopupManager = {}

  PopupManager.Maestro = Maestro

  PopupManager.add = (transclusion, scope, element) ->
    new_id = null

    child_scope = scope.$parent.$new()

    place = (child_element) ->
      new_id = maestro.append child_element, scope, element

    transclusion child_scope, place

    new_id

  PopupManager.remove = (id) ->
    maestro.remove id

  PopupManager.open = (id) ->
    maestro.open id

  PopupManager.close = (id) ->
    maestro.close id

  PopupManager


_factory.$inject = [
]

lft.service 'PopupManager', _factory
