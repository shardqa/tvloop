# 🔧 System Troubleshooting

## File Permission Problems
```bash
# Check file permissions
ls -la channels/*/
ls -la scripts/mpv_channel_switcher.lua
ls -la config/mpv_input.conf

# Fix permissions if needed
chmod 644 channels/*/state.json
chmod 644 channels/*/playlist.txt
chmod 755 scripts/mpv_channel_switcher.lua
chmod 644 config/mpv_input.conf
```

## Environment Variable Issues
```bash
# Check environment variables
echo $TVLOOP_CHANNELS_DIR
echo $DISPLAY

# Set if missing
export TVLOOP_CHANNELS_DIR="/path/to/channels"
export DISPLAY=":0"
```

## Performance Issues

### Slow Channel Switching
- **Cause**: Large playlist files or slow disk access
- **Solution**: Optimize playlist size or use SSD storage

### High Memory Usage
- **Cause**: Too many channels or large state files
- **Solution**: Limit number of channels or optimize state files

### Script Loading Delays
- **Cause**: Complex channel discovery or slow filesystem
- **Solution**: Use faster storage or reduce channel count

## Performance Optimization

### Optimize Channel Discovery
```bash
# Reduce channel count for testing
mv channels/channel_name channels/channel_name.bak

# Use faster storage
ln -s /tmp/channels channels
```

### Memory Optimization
```bash
# Monitor memory usage
htop
ps aux | grep mpv

# Limit MPV memory
mpv --cache=1024 --cache-secs=30
```

## System Requirements
```bash
# Required packages
which mpv
which lua
which yt-dlp

# Optional but recommended
which curl
which tree
```

## Report Issues
Include the following information:
- MPV version: `mpv --version`
- Lua version: `lua -v`
- System info: `uname -a`
- Error messages from logs
- Channel directory structure: `tree channels/`
