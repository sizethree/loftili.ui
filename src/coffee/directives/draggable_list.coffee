dDraggableList = ($q) ->

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

    addReference: (drag_item) ->
      @items.push drag_item

    finish: (moved_element, final_position) ->
      deferred = $q.defer()
      swap_index = -1
      moved_index = -1

      for item, index in @items
        if item == moved_element
          moved_index = index
          continue

        bounding = item[0].getBoundingClientRect()
        is_below = final_position.top > bounding.top
        is_above = final_position.top < bounding.bottom

        if is_above and is_below
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
