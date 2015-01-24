dependencies =[
  'Api/User',
  'Api/Auth',
  'Api/Device',
  'Api/Track',
  'Api/Artist',
  'Api/Playback',
  'Api/DnsRecord',
  'Api/Invitation',
  'Api/TrackQueue',
  'Api/PasswordReset',
  'Api/DevicePermission',
  'Api/DeviceState',
  'Api/Client',
  'Api/ClientToken'
]
lft.service 'Api', dependencies.concat([() ->

  aindx = 0

  Api =
    User: arguments[aindx++]
    Auth: arguments[aindx++]
    Device: arguments[aindx++]
    Track: arguments[aindx++]
    Artist: arguments[aindx++]
    Playback: arguments[aindx++]
    DnsRecord: arguments[aindx++]
    Invitation: arguments[aindx++]
    TrackQueue: arguments[aindx++]
    PasswordReset: arguments[aindx++]
    DevicePermission: arguments[aindx++]
    DeviceState: arguments[aindx++]
    Client: arguments[aindx++]
    ClientToken: arguments[aindx++]

])
