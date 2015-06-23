dDraggableList = ($q) ->

  itemId = do ->
    indx = 0
    () -> ['', ++indx, ''].join '_'

  class DraggableList

    constructor: () ->
      @items = []
      @callbacks =
        change: []

    clear: () ->
      while @items.length
        @items.pop()

    on: (evt, fn) ->
      can_add = (angular.isFunction fn) and (angular.isArray @callbacks[evt])
      @callbacks[evt].push fn if can_add
      true

    removeReference: (item_id) ->
      target = null

      for item, index in @items
        if item.id == item_id
          target = index

      @items.splice target, 1 if target != null

      target

    addReference: (drag_item) ->
      uuid = itemId()

      @items.push
        id: uuid
        el: drag_item

      uuid

    finish: (moved_element, final_position) ->
      deferred = $q.defer()
      swap_index = -1
      moved_index = -1

      for item, index in @items
        if item.id == moved_element
          moved_index = index
          continue

        bounding = item.el[0].getBoundingClientRect()
        is_below = final_position.top > bounding.top
        is_above = final_position.top < bounding.bottom

        if is_above and is_below
          swap_index = index

        if index == 0 and is_above
          swap_index = 0

        if index == (@items.length - 1) and is_below
          swap_index = index

      fn moved_index, swap_index for fn in @callbacks['change']

      deferred.resolve true

      deferred.promise

  lfDraggableList =
    controller: DraggableList
    link: () ->


dDraggableList.$inject = [
  '$q'
]

lft.directive 'lfDraggableList', dDraggableList
