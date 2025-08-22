# 🎬 Channel Switching

## Quick Start

**Hotkey-based channel switching** directly within MPV! Switch between channels without closing the player.

### Basic Usage
```bash
# Start a channel
./tvloop tune mpv filipe_deschamps

# Switch channels while playing:
# Press 2 → Switch to jovem_nerd
# Press 1 → Switch back to filipe_deschamps
# Press i → Show channel information
```

### Hotkeys
- **1-9**: Switch to channel 1-9
- **i**: Show channel information
- **F1-F5**: Alternative switching
- **Ctrl+1-5**: Ctrl modifier switching

## Features
- ✅ Seamless switching (no player restart)
- ✅ Time preservation (each channel maintains position)
- ✅ Automatic channel discovery
- ✅ YouTube support
- ✅ Up to 9 channels

## Documentation

### Usage
- [Usage Guide](usage.md) - Detailed usage examples

### Technical
- [Technical Overview](technical.md) - How it works
- [Architecture](technical-architecture.md) - Script structure and MPV integration
- [Extending](technical-extending.md) - Customization overview
- [Key Bindings](technical-keybindings.md) - Custom key configurations
- [Script Extensions](technical-scripting.md) - Lua script modifications
- [IPC Integration](technical-ipc.md) - Remote control and automation
- [Basic Video Sources](technical-videosources-basic.md) - Common video source extensions
- [Advanced Video Sources](technical-videosources-advanced.md) - Complex video source extensions
- [Protocol Extensions](technical-protocols.md) - Custom protocol handlers
- [Format Extensions](technical-formats.md) - Video format handling
- [Subtitle and Audio](technical-formats-subtitles.md) - Subtitle and audio formats
- [Streaming Extensions](technical-videosources-streaming.md) - Streaming overview
- [Stream Quality](technical-streaming-quality.md) - Quality management overview
- [Adaptive Streaming](technical-streaming-adaptive.md) - Adaptive streaming features
- [Bandwidth Management](technical-streaming-bandwidth.md) - Bandwidth and fallback
- [Stream Authentication](technical-streaming-auth.md) - Basic authentication
- [OAuth Authentication](technical-auth-oauth.md) - OAuth and advanced auth
- [Stream Monitoring](technical-streaming-monitoring.md) - Health monitoring
- [Stream Recovery](technical-monitoring-recovery.md) - Recovery systems
- [Stream Statistics](technical-monitoring-stats.md) - Basic statistics
- [Stream Alerts](technical-monitoring-alerts.md) - Alerts and advanced monitoring

### Troubleshooting
- [Quick Fixes](troubleshooting-quick.md) - Most common problems
- [Basic Solutions](troubleshooting-basic.md) - Common solutions
- [YouTube Issues](troubleshooting-youtube.md) - YouTube-specific problems
- [System Issues](troubleshooting-system.md) - Performance and permissions
- [Advanced Issues](troubleshooting-advanced.md) - Complex problems
- [Debug Mode](troubleshooting-debug.md) - Debugging tools
- [Testing](troubleshooting-testing.md) - Testing and diagnostics

## Files
- `scripts/mpv_channel_switcher.lua` - Main switching script
- `config/mpv_input.conf` - Key bindings
- `tests/test_tvloop_channel_switching.bash` - Test suite

---

**Enjoy your TV-like experience!** 📺✨
