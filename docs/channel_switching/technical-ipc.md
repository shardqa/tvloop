# 🔧 IPC Integration

## Remote Control Setup
```bash
# Start MPV with IPC socket
mpv --input-ipc-server=/tmp/mpv-socket video.mp4

# Send channel switch command
echo 'script-message switch-channel 2' | socat - /tmp/mpv-socket
```

## External Control Script
```bash
#!/bin/bash
# External channel switcher
SOCKET="/tmp/mpv-socket"

switch_channel() {
    echo "script-message switch-channel $1" | socat - "$SOCKET"
}

# Usage: ./external_switcher.sh 2
switch_channel "$1"
```

## Python Control Script
```python
#!/usr/bin/env python3
import socket
import sys

def send_command(command):
    sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
    try:
        sock.connect('/tmp/mpv-socket')
        sock.send(f'{command}\n'.encode())
        response = sock.recv(1024).decode()
        print(f"Response: {response}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        sock.close()

if __name__ == "__main__":
    if len(sys.argv) > 1:
        channel = sys.argv[1]
        send_command(f'script-message switch-channel {channel}')
    else:
        print("Usage: python3 mpv_control.py <channel_number>")
```

## Web Interface
```bash
#!/bin/bash
# Simple web server for channel control
PORT=8080

while true; do
    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" | nc -l $PORT
    echo "Channel control interface"
    echo "GET /switch/1 - Switch to channel 1"
    echo "GET /switch/2 - Switch to channel 2"
done
```

## Network Control
```bash
# Enable network control
mpv --input-ipc-server=/tmp/mpv-socket --input-unix-socket=/tmp/mpv-socket video.mp4

# Control from another machine
echo 'script-message switch-channel 1' | nc -U /tmp/mpv-socket
```

## Automation Scripts
```bash
# Auto-switch channels every 30 minutes
while true; do
    for channel in {1..5}; do
        echo "script-message switch-channel $channel" | socat - /tmp/mpv-socket
        sleep 1800  # 30 minutes
    done
done
```

## Status Monitoring
```bash
# Get current channel status
echo 'script-message get-channel-status' | socat - /tmp/mpv-socket

# Get available channels
echo 'script-message list-channels' | socat - /tmp/mpv-socket
```
