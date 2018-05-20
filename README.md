# A home automation presence service based on Bluetooth scanning

There are many ways to determine presence, this one is based on scanning if certain devices (phones) are present or not.
I use a raspberry pi with a BT dongle to do the work. This requires `hcitool` to be up-and-running

## Set-Up

This script needs two files as inputs:

### setenv.sh

General parameters
```
#!/bin/bash

# export whatever we need
export CHECKIN_ENDPOINT=https://<your-endpoint-goes-here>
export LOCATION=<place-where-the-script-runs> # e.g. "home"
```

### devices

A textfile containing one linefor the tuple bt-mac/person to track:
```
xx:xx:xx:xx:xx:xx|person-A
yy:yy:yy:yy:yy:yy|person-B
```


