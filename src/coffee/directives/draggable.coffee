dDraggable = ($rootScope) ->

  clearStyle = (el) ->
    el.css
      'position': ''
      'width': ''
      'height': ''
      'top': ''
      'left': ''


  dDraggableCompile = (e, a, transclude) ->

    dDraggableLink = ($scope, $element, $attrs, $controller) ->
      origin = null
      current = null
      doc = angular.element document
      body = angular.element document.body
      is_moving = false
      detached = false
      mover = null
      spacer = false
      list_id = null

      bounding = () ->
        mover[0].getBoundingClientRect()

      stop = () ->
        finish = () ->
          is_moving = false
          doc.off 'mouseup', stop
          body.removeClass 'no-hl'
          detached = false
          $scope.moving = false

          clearStyle spacer
          clearStyle mover

        ($controller.finish list_id, current).then finish

      detatch = () ->
        detached = true

        $rootScope.$apply () ->
          $scope.moving = true

        box = bounding()

        spacer.css
          'height': box.height + 'px'
          'width': box.width + 'px'

        mover.css
          'position': 'fixed'
          'z-index': 1000
          'width': box.width + 'px'
          'height': box.height + 'px'
          'left': box.left + 'px'
          'top': box.top + 'px'

      move = (event) ->
        if !is_moving
          return false

        detatch() if !detached

        current =
          left: (event.clientX - origin.left)
          top: (event.clientY - origin.top)

        mover.css
          'left': current.left + 'px'
          'top': current.top + 'px'

        true

      $scope.start = ($event) ->
        box = bounding()

        origin =
          left: $event.clientX - box.left
          top: $event.clientY - box.top

        is_moving = true
        body.addClass 'no-hl'
        doc.on 'mouseup', stop
        true

      transclusion = (child_element) ->
        mover = angular.element $element[0].querySelectorAll '.mover'
        spacer = angular.element $element[0].querySelectorAll '.spacer'
        mover.append child_element
        list_id = $controller.addReference $element

      $scope.$on '$destroy', () ->
        $controller.removeReference list_id

      transclude $scope.$parent, transclusion
      doc.on 'mousemove', move

  lfDraggable =
    replace: true
    transclude: true
    templateUrl: 'directives.draggable'
    scope: {}
    require: '^lfDraggableList'
    compile: dDraggableCompile

dDraggable.$inject = [
  '$rootScope'
]

lft.directive 'lfDraggable', dDraggable
