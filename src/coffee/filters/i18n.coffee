_factory = (Lang) ->

  i18n = (context) ->
    result = Lang context
    if result then result else context

_factory.$inject = ['Lang']

lft.filter 'i18n', _factory
