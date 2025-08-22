# 🔧 Testing and Diagnostics

## Run Diagnostic Tests
```bash
# Run all tests
./lib/bashunit tests/test_tvloop_*.bash

# Run specific tests
./lib/bashunit tests/test_tvloop_channel_switching.bash
```

## Manual Script Testing
```bash
# Test script functions manually
lua -e "
dofile('scripts/mpv_channel_switcher.lua')
channels = discover_channels()
for i, ch in ipairs(channels) do
    print(i .. ': ' .. ch.name)
end
"
```

## MPV Console Testing
```bash
# In MPV console (press ` key):
script-message switch-channel 1
script-binding show-channel-info
```

## Test Individual Components
```bash
# Test channel discovery
lua -e "dofile('scripts/mpv_channel_switcher.lua')"

# Test playlist parsing
lua -e "print(parse_playlist('channels/channel_name/playlist.txt'))"
```

## Performance Testing
```bash
# Monitor memory usage
htop
ps aux | grep mpv

# Test channel switching speed
time ./tvloop tune mpv channel_name
```

## Stress Testing
```bash
# Create multiple test channels
for i in {1..5}; do
    ./tvloop create youtube "test_$i" "https://www.youtube.com/@channel" 1
done

# Test rapid channel switching
for i in {1..5}; do
    echo "script-message switch-channel $i" | socat - /tmp/mpv-socket
    sleep 2
done
```

## Validation Tests
```bash
# Check all channels have required files
for dir in channels/*/; do
    echo "Validating: $dir"
    test -f "$dir/state.json" || echo "Missing state.json"
    test -f "$dir/playlist.txt" || echo "Missing playlist.txt"
done

# Validate JSON syntax
for json in channels/*/state.json; do
    python -m json.tool "$json" >/dev/null || echo "Invalid JSON: $json"
done
```

## Report Issues
Include the following information:
- MPV version: `mpv --version`
- Lua version: `lua -v`
- System info: `uname -a`
- Error messages from logs
- Channel directory structure: `tree channels/`
