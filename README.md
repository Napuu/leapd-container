# leapd-container
Containerized leapd for the original Leap Motion controller

## Building the container

1. Get the Linux SDK from [here](https://www.ultraleap.com/downloads/leap-controller/)
2. Move the SDK to the same dir as this Dockerfile (`TAR_FILE=tracking-software-linux.tar.gz`)
3. Build the container:
```bash
podman build -f Dockerfile -t leapd .
```

## Running the container
Find the device id of the controller, e.g.
```
# lsusb | grep Leap
Bus 001 Device 002: ID f182:0003 Leap Motion Controller
```
means that the device is at `/dev/bus/usb/001/002`. And then run the container:

```
# podman run -it --device=/dev/bus/usb/001/002 --publish 6437:6437 leapd
```

These commands are tried and working on Fedora 42 + Podman. Docker should work as well, but I haven't tested it.