localizer = (Lang, en) ->

  Lang.current_dict = en

localizer.$inject = ['Lang', 'i18n-en']

lft.run localizer
