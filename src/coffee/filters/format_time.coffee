fFormatTime = () ->

  pad = (num) ->
    s = num + ''
    while s.length < 2
      s = '0' + s
    s

  formatTime = (milliseconds) ->
    return milliseconds if !angular.isNumber milliseconds
    seconds = milliseconds / 1000
    minutes_val = seconds / 60
    minutes_whole = Math.floor minutes_val
    seconds_rem = (minutes_val - minutes_whole) * 60
    [ minutes_whole
      pad Math.ceil seconds_rem
    ].join ':'

lft.filter 'formatTime', fFormatTime
