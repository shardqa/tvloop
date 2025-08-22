# 🔍 Basic Troubleshooting

## Common Solutions

### Recreate Channel
```bash
# Remove and recreate channel
rm -rf channels/channel_name
./tvloop create youtube channel_name "URL" 2
```

### Reset Channel State
```bash
# Reinitialize channel
./scripts/channel_tracker.sh channels/channel_name init
```

### Check File Permissions
```bash
# Ensure files are readable
chmod 644 channels/*/state.json
chmod 644 channels/*/playlist.txt
```

### Restart MPV with Debugging
```bash
# Launch with verbose output
mpv --msg-level=all=v --script=scripts/mpv_channel_switcher.lua
```

### Clean Channel Directory
```bash
# Remove any corrupt files
find channels/ -name "*.tmp" -delete
find channels/ -size 0 -delete
```

### Verify Dependencies
```bash
# Check required programs
which mpv
which lua
which yt-dlp

# Install if missing (Ubuntu/Debian)
sudo apt install mpv lua5.3 python3-pip
pip3 install yt-dlp
```

## Common Issues

### MPV Won't Start
- Check if another MPV instance is running: `ps aux | grep mpv`
- Kill existing instances: `killall mpv`
- Check display variable: `echo $DISPLAY`

### Script Errors
- Check Lua syntax: `lua -c scripts/mpv_channel_switcher.lua`
- Verify file permissions: `ls -la scripts/mpv_channel_switcher.lua`

### Channel Files Missing
- Recreate channel: `./tvloop create youtube channel_name URL`
- Check channel tracker: `./scripts/channel_tracker.sh channels/channel_name status`

## More Help

See specialized troubleshooting guides:
- [Quick Fixes](troubleshooting-quick.md) - Most common problems
- [YouTube Issues](troubleshooting-youtube.md) - YouTube-specific problems
- [System Issues](troubleshooting-system.md) - Performance and permissions
- [Debug Mode](troubleshooting-debug.md) - Advanced debugging