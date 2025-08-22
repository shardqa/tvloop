# 🔍 Quick Troubleshooting

## Quick Fixes

### Channel Not Switching
**Press 1-9 keys but nothing happens?**

1. **Check if channels exist**:
   ```bash
   ls -la channels/
   ```

2. **Verify channel files**:
   ```bash
   ls -la channels/filipe_deschamps/
   # Should have: state.json, playlist.txt
   ```

3. **Check MPV logs** for script errors in terminal

### Wrong Time Position
**Channel starts at wrong time?**

1. **Reinitialize channel**:
   ```bash
   ./scripts/channel_tracker.sh channels/channel_name init
   ```

2. **Check state.json**:
   ```bash
   cat channels/channel_name/state.json
   ```

### Script Not Loading
**No channel switching available?**

1. **Check Lua**:
   ```bash
   which lua
   ```

2. **Check script file**:
   ```bash
   ls -la scripts/mpv_channel_switcher.lua
   ```

3. **Check MPV version**:
   ```bash
   mpv --version
   ```

### Keys Not Working
**Hotkeys 1-9 don't respond?**

1. **Check input config**:
   ```bash
   cat config/mpv_input.conf
   ```

2. **Verify MPV launched with config** (look for "with channel switching enabled")

3. **Test in MPV console** (press ` key): `script-message switch-channel 1`

### No Channels Found
**Script shows "no channels available"?**

1. **Check channels directory**:
   ```bash
   ls -la channels/
   ```

2. **Verify channel structure**:
   ```bash
   ls -la channels/channel_name/
   # Should have: state.json, playlist.txt
   ```

## Quick Tests

### Run Channel Switching Tests
```bash
./lib/bashunit tests/test_tvloop_channel_switching.bash
```

### Test MPV Script Loading
```bash
mpv --script=scripts/mpv_channel_switcher.lua --input-conf=config/mpv_input.conf
```

### Check Channel Status
```bash
./tvloop status
./tvloop list
```
