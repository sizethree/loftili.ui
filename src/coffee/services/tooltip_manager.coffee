_factory = ($timeout) ->

  listeners =
    transclude: []

  addListener = (evt, fn) ->
    if angular.isFunction fn
      listeners[evt].push fn

  trigger = (evt, args) ->
    (fn.apply(null, args) for fn in listeners[evt]) if listeners[evt]

  tooltipElement = () ->
    angular.element '<div class="tooltip-instance"></div>'

  TooltipManager =

    on: (evt, fn) ->
      if listeners[evt]
        addListener evt, fn
      else
        false

    transclusion: (placement_el, placement_scope) ->
      containing_el = tooltipElement()
      hide_timeout = null

      placementHover = () ->
        if hide_timeout
          $timeout.cancel hide_timeout
          hide_timeout = null

        bounding = placement_el[0].getBoundingClientRect()
        left = bounding.left - (bounding.width * 0.5)
        top = bounding.bottom + 10

        if left < 5
          left = 5

        containing_el.css
          top: [top, 'px'].join ''
          left: [left, 'px'].join ''
          opacity: 1.0
          display: "inline-block"

      hidePlacement = () ->
        containing_el.css
          display: "none"

      placementOff = () ->
        if hide_timeout
          $timeout.cancel hide_timeout

        containing_el.css
          opacity: 0

        hide_timeout = $timeout hidePlacement, 400

      destroyPlacement = () ->
        containing_el.remove()

      placement_scope.$on 'hover', placementHover
      placement_scope.$on 'off', placementOff
      placement_scope.$on '$destroy', destroyPlacement

      transclusionFn = (element, scope) ->
        containing_el.append element
        trigger "transclude", [containing_el]

_factory.$inject = ['$timeout']

lft.service 'TooltipManager', _factory
