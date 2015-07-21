lft.value 'i18n-en',
  privacy: "Privacy"
  device_permissions:
    1: "Owner"
    2: "Friend"
  stream_permissions:
    1: "Owner"
    2: "Manager"
    4: "Contributor"
    errors:
      adding: 'Unable to add user to stream, contact support'
      removing: 'Unable to remove user from stream, contact support'
  streams:
    empty: "This stream is empty!"
    uploading_track: 'Uploading track, please wait'
    sending_permission: 'Adding user to stream...'
    subscribing_browser: 'Subscribing your browser to the stream...'
    errors:
      removing_item: 'Unable to remove stream item, try again'
  in_touch: "We'll be in touch!"
  invitation:
    sending: 'Sending invitation, please wait'
    failed_remove: 'Failed deleting the invitation, please contact support'
  library:
    tracks:
      dropping: 'Removing the track from your library, please wait'
  queuing:
    failed: 'Unable to add the track to your device queue'
    failed_remove: 'Unable to remove the track from your device queue'
  merging:
    errors:
      subscribe: 'Unable to subscribe your device to the stream, please try again'
  reset_password:
    success: 'Check your email, you should have a link waiting'
  account:
    privacy:
      PRIVATE: 'private'
      CONNECTED: 'connections'
      PUBLIC: 'public'
    doing_update: 'Please wait, updating account'
    update_success: 'Successfully updated your account'
    requesting:
      sending: 'Sending your request...'
      finished: 'We\'ve saved your request, we\'ll be in touch'
      failed: 'We couldn\'t complete your request, shoot us an email.'
    password:
      change:
        success: 'Your password has been updated!'
        fail: 'We\'ve messed something up, shoot us an email!'
  device:
    copied_serial: 'Copied serial to clipboard!'
    do_not_disturb:
      changing: 'Changing your device\'s do not disturb setting...'
    sending_permission: 'Granting user control of device, please wait...'
    now_playing_text: "Now playing:"
    register: "Register device:"
    errors:
      registration: "Unable to register your device, please check your serial number"
      unable_to_communicate: "We're unable to get information from your device, please check it's configuration"
      empty_track_queue: "Your device was unable to load it\'s track queue, try restarting"
    updating:
      name:
        success: 'Successfully updated your device\'s name'
        error: 'Unable to update the devie\'s name'
    ping:
      start: 'Sending a ping request to your device'
      success: 'We\'ve successfully communicated with your device'
      fail: 'We were unable to communicate with your device'
    playback:
      starting: 'Starting playback, please wait'
      stopping: 'Stopping playback, please wait'
      restarting: 'Attempting to restart playback, please wait'
      failed: 'Unable to {{action}} device, please check it\'s connection'
  stream:
    errors:
      moving: 'Unable to move the stream\'s tracks around'
      privacy: 'Unable to toggle stream\'s privacy'
  media:
    providers:
      SC: "soundcloud"
      LF: "loftili"
