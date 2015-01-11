_factory = (Lang) ->

  i18n = (context) ->
    Lang(context)

_factory.$inject = ['Lang']

lft.filter 'i18n', _factory
