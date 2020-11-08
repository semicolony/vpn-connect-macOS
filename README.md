# vpn-connect
An easy to configure VPN client wrapper for linux written in bash.
It is in a really early stage of development, PRs welcome.

## Quick start

Copy the connection.ini.skel to connection.ini, change mod to 600 and edit its contents:

    [datacenter1]                  # This is the destination label. See CLI example below.
    client=openconnect             # This is the client you want to use. See supported clients below.
    uri=dc1.blabla.org             # The destination uri
    username=philipp.kemmeter
    password=SECRET_PASSWORD_IN_PLAINTEXT # This is why the mod has to be 600
    2fa-append=yes                 # Whether you need the 2fa token to be appended to the password.
    # list of other CL arguments valid for the chosen client
    
Then run `vpn-connect datacenter1` and the magic begins.

## Supported Clients

For now, openconnect is supported, only. More to come.

