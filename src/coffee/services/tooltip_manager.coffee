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
      arrow = angular.element '<span class="arrow"></span>'
      containing_el.append arrow

      tooltip_el = null
      hide_timeout = null

      placementHover = () ->
        if hide_timeout
          $timeout.cancel hide_timeout
          hide_timeout = null

        bounding = placement_el[0].getBoundingClientRect()
        left = bounding.left
        top = bounding.bottom + 10

        if left < 5
          left = 5

        containing_el.css
          top: [top, 'px'].join ''
          display: "inline-block"

        container_width = containing_el[0].getBoundingClientRect().width
        bounding_width = bounding.width
        real_left = left - (container_width * 0.5) + (bounding_width * 0.5)

        if real_left < 5
          real_left = 5

        containing_el.css
          left: [real_left, 'px'].join ''
          opacity: 1.0

        arrow.css
          left: [left + (bounding_width * 0.5 - 5), 'px'].join ''

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
        tooltip_el = element
        containing_el.append element
        trigger "transclude", [containing_el]

_factory.$inject = ['$timeout']

lft.service 'TooltipManager', _factory
