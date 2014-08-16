lft.directive 'lfIcon', ['ICONOGRAPHY', 'Svg', (ICONOGRAPHY, Svg) ->

  default_width = 20
  default_height = 20

  lfIcon =
    replace: true
    templateUrl: 'directives.icon'
    scope: {}
    link: ($scope, $element, $attrs) ->
      icon = $attrs['icon']
      path = ICONOGRAPHY[icon]
      width = $attrs['width'] || default_width
      height = $attrs['height'] || default_height
      fill = $attrs['fill'] || '#fff'

      svg = Svg.create 'svg',
        width: width
        height: height

      group = Svg.create 'g'
      group.translate width * 0.5, height * 0.5
      group.scale 0.80

      icon = Svg.create 'path'

      if path
        icon.attr
          d: path
          fill: fill

      group.append icon
      svg.append group

      $element.append svg.el

]
