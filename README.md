# tunneler-server
Server for managing a set of ngrok connections through an http/https port

This is a personal system I use to access one of my personal devices from my home network since I only exposed ports 80 (HTTP) and 443 (HTTPS) through the firewall for enhanced security. This repository is one of my designed experiments to learn Haskell as well as making an Apple Watch app as a client. Feel free to open issues if you find them, but this is primarily for my own use.

## Setup

Ngrok must be installed and you must have a `.ngrok2/ngrok.yml` file in your home directory. Ngrok must also of course be in your path.

Example Ngrok Config:

```
authtoken: mYlOnGtOKeNfRoMnGrOkDoTcOm
json_resolver_url: ""
dns_resolver_ips: []
tunnels:
    ssh:
        proto: tcp
        addr: 0.0.0.0:22
```

To run the actual haskell server, you'll also need to install `stack` and install the dependencies with `stack install`. I've also used a cabal file as a backwards compatible run system. Therefore, you'll need [stack-run](https://hackage.haskell.org/package/stack-run) to operate the repository without cabal.

## Running / Installing

If you're trying to hack on this project, it would be most useful to run `stack run` assuming the above instructions.

If you just want to install it as a cron job, once you run `stack` a binary should be available somewhere in the `.stack-work/dist` directory. Then, you can update your crontab to including something like this:

```
@reboot PORT=12345 TUSER=mysecretuser TPSWD=mysecurepassword /path/to/binary/tunneler
```

## Copyright (GPLv3)

Copyright 2017 Christian Di Lorenzo

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
