# 🔧 Advanced Troubleshooting

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

## Complex Issues

### Script Loading Problems
1. **Check Lua installation**:
   ```bash
   lua -v
   which lua
   ```

2. **Verify script syntax**:
   ```bash
   lua -c scripts/mpv_channel_switcher.lua
   ```

3. **Test MPV script support**:
   ```bash
   mpv --version | grep -i lua
   ```

### Channel Discovery Issues
1. **Test channel discovery manually**:
   ```bash
   find channels -maxdepth 1 -type d -name "*" | grep -v "^channels$"
   ```

2. **Verify channel structure**:
   ```bash
   for dir in channels/*/; do
       echo "Checking: $dir"
       ls -la "$dir"state.json "$dir"playlist.txt
   done
   ```

### Time Calculation Problems
1. **Check state.json format**:
   ```bash
   cat channels/channel_name/state.json | python -m json.tool
   ```

2. **Verify timestamps**:
   ```bash
   date -d @$(cat channels/channel_name/state.json | grep start_time | cut -d: -f2 | tr -d ' ,')
   ```

## See Also
- [YouTube Issues](troubleshooting-youtube.md) - YouTube-specific problems
- [System Issues](troubleshooting-system.md) - Performance and system problems
- [Debug Mode](troubleshooting-debug.md) - Debugging tools and testing