# ubi8-ntp-server

This is a ChronyD NTP Server in a Red Hat Universal Base Image v8 container.

## Building & Running the Container

```bash
git clone github.com/kenmoini/ubi8-ntp-server.git
cd ubi8-ntp-server/

podman build -f Containerfile -t chrony-ntp .
podman run -d --rm --name chrony-ntp \
 --cap-add SYS_TIME \
 --cap-add NET_BIND_SERVICE \
 --network lanBridge \
 -p 123/udp \
 -p 323/udp \
 --ip 192.168.42.14 \
 chrony-ntp:latest
```

## Pulling & Running the Container

```bash
podman pull quay.io/kenmoini/ubi8-ntp-server:latest

podman build -f Containerfile -t chrony-ntp .
podman run -d --rm --name chrony-ntp \
 --cap-add SYS_TIME \
 --cap-add NET_BIND_SERVICE \
 --network lanBridge \
 -p 123/udp \
 -p 323/udp \
 --ip 192.168.42.14 \
 chrony-ntp:latest
```

## Setting up a ChronyD Client

On your Linux terminal you also need ChronyD configured as a client, edit the `/etc/chronyd.conf` and set it as so:

```text
# Set the Server
server 192.168.42.14 iburst

# Record the rate at which the system clock gains/losses time.
driftfile /var/lib/chrony/drift

# Allow the system clock to be stepped in the first three updates
# if its offset is larger than 1 second.
makestep 1.0 3

# Enable kernel synchronization of the real-time clock (RTC).
rtcsync

# Get TAI-UTC offset and leap seconds from the system tz database.
leapsectz right/UTC

# Specify directory for log files.
logdir /var/log/chrony
```

...then restart the service with `systemctl restart chronyd`

## Testing the ChronyD NTP Server

```bash
podman exec chrony-ntp chronyc ntpdata

podman exec chrony-ntp chronyc serverstats

podman exec chrony-ntp chronyc sources

podman exec chrony-ntp chronyc sourcestats

podman exec chrony-ntp chronyc tracking
```