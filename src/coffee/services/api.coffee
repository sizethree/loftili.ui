dependencies =[
  'Api/User',
  'Api/Auth',
  'Api/Device',
  'Api/Track',
  'Api/Artist',
  'Api/DnsRecord',
  'Api/Invitation',
  'Api/TrackQueue',
  'Api/PasswordReset',
  'Api/DevicePermission',
  'Api/AccountRequest',
  'Api/DeviceState',
  'Api/DeviceSerial',
  'Api/Stream',
  'Api/StreamPermission',
  'Api/Client',
  'Api/ClientToken'
]
lft.service 'Api', dependencies.concat([() ->

  ai = 0
  aa = arguments
  an = () -> aa[ai++]

  Api =
    User: an()
    Auth: an()
    Device: an()
    Track: an()
    Artist: an()
    DnsRecord: an()
    Invitation: an()
    TrackQueue: an()
    PasswordReset: an()
    DevicePermission: an()
    AccountRequest: an()
    DeviceState: an()
    DeviceSerial: an()
    Stream: an()
    StreamPermission: an()
    Client: an()
    ClientToken: an()

])
