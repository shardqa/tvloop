# 🔧 Channel Switching Architecture

## Script Architecture

### Main Components
- **Channel Discovery**: `discover_channels()` function
- **Time Calculation**: `calculate_channel_position()` function
- **Video Switching**: `switch_to_channel()` function
- **Key Bindings**: `setup_key_bindings()` function

### Key Functions
```lua
-- Discover available channels
discover_channels()

-- Calculate current video and position
calculate_channel_position(channel_dir)

-- Switch to specific channel
switch_to_channel(channel_index)

-- Register script message handler
mp.register_script_message("switch-channel", handler)
```

## MPV Integration

### Script Loading
MPV loads the channel switching script via:
```bash
mpv --script="scripts/mpv_channel_switcher.lua" --input-conf="config/mpv_input.conf"
```

### Key Binding System
- **Direct Bindings**: Keys 1-9 directly call `switch_to_channel()`
- **Script Messages**: `script-message switch-channel <index>` for external control
- **Information Display**: 'i' key shows channel information

### Video Loading
```lua
-- Load new video at calculated position
mp.commandv("loadfile", youtube_url, "replace")
mp.commandv("seek", math.floor(position.position))
```

## Environment Variables

- `TVLOOP_CHANNELS_DIR`: Custom channels directory (default: "channels")
- Used by script to discover channels in test environments

## Error Handling

- **Invalid Channel**: Shows OSD message for non-existent channels
- **Missing State**: Handles channels without proper state files
- **Empty Playlist**: Gracefully handles channels with no videos
- **Script Errors**: Logs errors to MPV console

## Performance Considerations

- **Channel Discovery**: Only runs once at script startup
- **Time Calculation**: Performed on-demand when switching
- **Video Loading**: Uses MPV's efficient `loadfile` command
- **Memory Usage**: Minimal Lua script footprint
