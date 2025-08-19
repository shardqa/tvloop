# Technical Architecture

## Implementation Strategy

### Bash Scripts Approach
- **channel_tracker.sh**: Core time tracking and state management
- **channel_player.sh**: Video player integration and launch
- **channel_manager.sh**: Multi-channel management and switching
- **playlist_manager.sh**: Playlist metadata and organization

### File Structure
```
tvloop/
├── channels/
│   ├── local_movies/
│   │   ├── playlist.txt
│   │   ├── state.json
│   │   ├── config.sh
│   │   └── type: local
│   ├── youtube_playlist/
│   │   ├── playlist.txt
│   │   ├── state.json
│   │   ├── config.sh
│   │   ├── type: youtube_playlist
│   │   └── playlist_id: PLxxxxx
│   └── youtube_subscriptions/
│       ├── playlist.txt
│       ├── state.json
│       ├── config.sh
│       ├── type: youtube_subscriptions
│       └── last_week: true
├── scripts/
│   ├── channel_tracker.sh
│   ├── channel_player.sh
│   ├── channel_manager.sh
│   ├── playlist_manager.sh
│   ├── youtube_integration.sh
│   └── content_sources/
│       ├── local_source.sh
│       ├── youtube_playlist.sh
│       └── youtube_subscriptions.sh
├── config/
│   ├── channels.conf
│   └── youtube.conf
└── logs/
    └── channel_activity.log
```
