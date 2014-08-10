lft.service 'MenuManager', ['$window', '$rootScope', ($window, $rootScope) ->

  open_menus = []

  closeNext = () ->
    if open_menus.length > 0
      next = open_menus.pop()
      next()
      $rootScope.$digest()

  keyWatch = (evt) ->
    if evt.keyCode == 27
      closeNext()

  clickWatch = (evt) ->
    target = angular.element evt.target
    if !target.attr('data-mm-noclose')
      closeNext()

  angular.element($window).on 'keyup', keyWatch
  angular.element($window).on 'click', clickWatch

  uid = do ->
    indx = 0
    () ->
      indx++
      ['wrapper', indx].join('-')

  MenuManager =

    register: (fn) ->
      if angular.isFunction fn
        wrapper = () -> fn()
        wrapper_uid = uid()
        wrapper.indx = wrapper_uid
        open_menus.push(wrapper)
        wrapper_uid
      else
        false

    remove: (indx) ->
      check = (menu) ->
        if menu.indx == indx
          menu()

      check menu for menu in open_menus
]
