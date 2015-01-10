LangFactory = () ->

  Lang = (context) ->
    splits = context.split '.'
    dict = Lang.current_dict

    while splits.length
      lvl = splits.shift()
      if dict and (dict[lvl] != undefined)
        dict = dict[lvl]
      else
        return ''

    return dict

  Lang.current_dict = {}

  Lang

LangFactory.$inject = []

lft.service 'Lang', LangFactory
