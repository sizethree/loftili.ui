lft.filter 'streamState', ['DEVICE_STATES', (DEVICE_STATES) ->
  
  deviceState = (play_state) ->
    if /buffering/i.test(play_state)
      "buffering"
    else if /playing/i.test(play_state)
      "playing"
    else
      ""

]
