# 🔧 Channel Switching Technical Details

## How It Works

When you tune in to a channel with `./tvloop tune mpv`, MPV is launched with:
- A custom Lua script (`mpv_channel_switcher.lua`) that handles channel switching
- Custom key bindings (`mpv_input.conf`) for hotkey controls
- Automatic channel discovery and time position calculation

## Files Created

- `scripts/mpv_channel_switcher.lua`: Main channel switching script
- `config/mpv_input.conf`: Key binding configuration
- `tests/test_tvloop_channel_switching.bash`: Test suite

## How Time Calculation Works

1. **Channel State**: Each channel has a `state.json` file with start time and total duration
2. **Time Calculation**: Script calculates elapsed time since channel start
3. **Video Selection**: Determines which video should be playing based on elapsed time
4. **Position Calculation**: Calculates exact position within the current video
5. **Seamless Switch**: Loads new video at calculated position

## Channel Discovery

The script automatically discovers channels by:
1. Scanning the `channels/` directory
2. Finding directories with `state.json` and `playlist.txt` files
3. Ordering channels alphabetically
4. Assigning numbers 1-9 for hotkey access

## Key Features

- **Seamless Switching**: No player restart needed
- **Time Preservation**: Each channel maintains its time position
- **Automatic Discovery**: No manual configuration needed
- **YouTube Support**: Works with YouTube channels
- **Hotkey Access**: Quick switching with number keys

## Technical Details

- [Architecture](technical-architecture.md) - Script structure and MPV integration
- [Extending](technical-extending.md) - Customization and new features