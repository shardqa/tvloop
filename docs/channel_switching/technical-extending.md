# 🔧 Extending Channel Switching

## Overview

Channel switching can be extended with custom key bindings, script modifications, IPC integration, and support for various video sources and streaming features.

## Extension Categories

### [Custom Key Bindings](technical-keybindings.md)
- Adding more channels, alternative layouts, gaming controllers

### [Script Extensions](technical-scripting.md)
- Channel categories, custom commands, metadata, validation

### [IPC Integration](technical-ipc.md)
- Remote control, external scripts, automation

### [Video Sources](technical-videosources-basic.md)
- Local video, network streams, IPTV, multi-source

### [Protocol Extensions](technical-protocols.md)
- Custom protocols, advanced protocols, torrent streaming

### [Format Extensions](technical-formats.md)
- Video format conversion and handling

### [Subtitle and Audio](technical-formats-subtitles.md)
- Subtitle handling, audio configuration

### [Streaming Features](technical-videosources-streaming.md)
- Quality management, authentication, health monitoring

### [Stream Quality](technical-streaming-quality.md)
- Quality management overview

### [Adaptive Streaming](technical-streaming-adaptive.md)
- Adaptive bitrate, dynamic resolution

### [Bandwidth Management](technical-streaming-bandwidth.md)
- Quality fallback, bandwidth detection

### [Stream Authentication](technical-streaming-auth.md)
- Basic token and API key authentication

### [OAuth Authentication](technical-auth-oauth.md)
- OAuth, JWT, header-based authentication

### [Stream Monitoring](technical-streaming-monitoring.md)
- Health monitoring, connection tracking

### [Stream Recovery](technical-monitoring-recovery.md)
- Automatic recovery systems

### [Stream Statistics](technical-monitoring-stats.md)
- Basic statistics and performance metrics

### [Stream Alerts](technical-monitoring-alerts.md)
- Alerts, latency detection, advanced monitoring

## Quick Start

### Add More Channels
```bash
# In config/mpv_input.conf
F6 script-message switch-channel 6
```

### Custom Command
```lua
-- In mpv_channel_switcher.lua
mp.register_script_message("channel-info", function(channel_name)
    mp.osd_message("Channel: " .. channel_name, 3)
end)
```

### Remote Control
```bash
# Start with IPC
mpv --input-ipc-server=/tmp/mpv-socket video.mp4
```

## See Also
- [Architecture](technical-architecture.md) - Understanding the script structure
- [Technical Overview](technical.md) - How channel switching works
