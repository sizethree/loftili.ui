lft.filter 'deviceState', ['DEVICE_STATES', (DEVICE_STATES) ->
  
  deviceState = (play_state) ->
    is_ok = play_state == DEVICE_STATES.PLAYING || play_state == DEVICE_STATES.STOPPED || play_state == DEVICE_STATES.BUFFERING

    if is_ok
      "ok"
    else if play_state == DEVICE_STATES.ERRORED
      "!"
    else if play_state == DEVICE_STATES.QUEUE_ERROR
      "!"
    else
      "?"

]
