# 24-Hour Video Channel Project Plan

## Overview

This project implements a "virtual TV channel" that simulates continuous video playback without actually running video players. The system tracks time progression through a playlist and resumes exactly where it left off when you "tune in".

## Documentation Structure

- **[Concept Overview](docs/concept.md)**: Core features and concept explanation
- **[Technical Architecture](docs/architecture.md)**: Implementation strategy and file structure
- **[Development Phases](docs/development.md)**: Development roadmap and success criteria
- **[TODO List](TODO.md)**: Comprehensive development tasks organized by phase

## Current Status

The project has been refactored into a modular structure with all files kept under 100 lines:

### Core Modules
- `core/time_utils.sh` - Time calculation functions
- `core/playlist_parser.sh` - Playlist parsing and video position calculation
- `core/channel_state.sh` - Channel initialization and state management
- `core/logging.sh` - Logging utility functions
- `core/playlist_utils.sh` - Playlist validation and utility functions
- `core/playlist_creator.sh` - Playlist creation and information display

### Player Modules
- `players/mpv_player.sh` - MPV-specific functionality
- `players/vlc_player.sh` - VLC-specific functionality
- `players/player_utils.sh` - Common player functions

### Main Scripts
- `scripts/channel_tracker.sh` - Channel tracking and status
- `scripts/channel_player.sh` - Video player integration
- `scripts/playlist_manager.sh` - Playlist management and creation

### Makefile Modules
- `make/channel.mk` - Channel management targets
- `make/playlist.mk` - Playlist management targets
- `make/testing.mk` - Testing targets
- `make/utils.mk` - Utility targets

## Usage

```bash
# Initialize a channel
./scripts/channel_tracker.sh channels/channel_1 init

# Check channel status
./scripts/channel_tracker.sh channels/channel_1 status

# Tune in to channel with mpv
./scripts/channel_player.sh channels/channel_1 tune mpv

# Stop all players
./scripts/channel_player.sh channels/channel_1 stop

# Create playlist from directory
./scripts/playlist_manager.sh channels/channel_1/playlist.txt /path/to/videos create

# Validate playlist
./scripts/playlist_manager.sh channels/channel_1/playlist.txt validate
```
