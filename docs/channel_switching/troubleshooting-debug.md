# 🔧 Debug Mode

## Enable Verbose Logging
```bash
# Launch MPV with verbose logging
mpv --msg-level=all=v --script=scripts/mpv_channel_switcher.lua video.mp4
```

## Check Script Output
- Look for "MPV Channel Switcher loaded successfully" message
- Check for "Discovered X channels for switching" message
- Look for any error messages in MPV console

## Log Analysis

### Check Logs
```bash
# MPV logs
mpv --log-file=mpv.log --script=scripts/mpv_channel_switcher.lua

# System logs
journalctl -f | grep mpv

# Channel switching specific logs
grep -i "channel" mpv.log
grep -i "switch" mpv.log
```

### Common Error Messages

**"Lua script error"**:
- Check Lua syntax: `lua -c scripts/mpv_channel_switcher.lua`
- Verify Lua version: `lua -v`

**"File not found"**:
- Check file paths in script
- Verify channel directory structure

**"Permission denied"**:
- Check file permissions
- Run with appropriate user privileges

## Debug Information
```bash
# Show debug info
echo "MPV version: $(mpv --version | head -1)"
echo "Lua version: $(lua -v)"
echo "Channels found: $(ls -1d channels/*/ 2>/dev/null | wc -l)"
echo "Script exists: $(test -f scripts/mpv_channel_switcher.lua && echo 'Yes' || echo 'No')"
```

## Debug Script
```bash
# Create debug script
cat > debug_channels.sh << 'EOF'
#!/bin/bash
echo "=== Channel Switching Debug ==="
echo "Channels directory:"
ls -la channels/
echo
echo "Script file:"
ls -la scripts/mpv_channel_switcher.lua
echo
echo "Input config:"
ls -la config/mpv_input.conf
echo
echo "Test script syntax:"
lua -c scripts/mpv_channel_switcher.lua && echo "OK" || echo "ERROR"
EOF
chmod +x debug_channels.sh
./debug_channels.sh
```

## Advanced Testing
- [Testing Guide](troubleshooting-testing.md) - Comprehensive testing tools