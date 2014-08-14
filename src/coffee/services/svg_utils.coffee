lft.service 'Svg', [() ->

  namespace = 'http://www.w3.org/2000/svg'

  createElement = (tag) ->
    document.createElementNS namespace, tag

  setAttrs = (element, attrs) ->

    set = (attr, value) ->
      element.setAttributeNS null, attr, value

    set attr, attrs[attr] for attr of attrs

  getAttr = (element, name) ->
    element.getAttribute name

  translateStr = (xpos, ypos) ->
    coords = joinStr xpos, ypos, ','
    ['translate(', coords, ')'].join ''

  joinStr = (a, b, c) ->
    [a, b].join c

  wrap = (val, prop) ->
    [prop, '(', val, ')'].join ''

  class El

    constructor: (tagname, options) ->
      @el = createElement tagname
      if options
        setAttrs @el, options

    translate: (xpos, ypos) ->
      current = getAttr @el, 'transform'
      translation = translateStr xpos, ypos
      final_str = joinStr current, translation, ' '

      setAttrs @el,
        transform: final_str

    scale: (size) ->
      current = getAttr @el, 'transform'
      scale = wrap size, 'scale'
      final_str = joinStr current, scale, ' '

      setAttrs @el,
        transform: final_str

    append: (el_instance) ->
      if el_instance and el_instance instanceof El
        @el.appendChild el_instance.el
      @

    attr: (attrs) ->
      setAttrs @el, attrs

  SvgUtils =

    create: (tagname, attrs) ->
      new El(tagname, attrs)

]
