# 24-Hour Video Channel Project - TODO

## Overview

This document contains the active TODO list for the 24-Hour Video Channel project, organized by priority. Completed tasks have been moved to [COMPLETED_TASKS.md](COMPLETED_TASKS.md).

## Active Tasks (Ordered by Priority)

### 🔥 High Priority - Next Actions

**Note**: The unit tests are taking so long. A way to run them in parallel is needed.

### 📋 Medium Priority - Enhancement Tasks

1. **Testing Enhancements** ✅ **COMPLETED**
   - ✅ Add YouTube API integration tests (51 tests created, all passing)
   - ✅ Create mock YouTube API responses for testing
   - ✅ Add YouTube playback integration tests
   - ✅ Comprehensive test coverage for all YouTube API modules
   - ✅ Refactored large test files into focused modules (test_time_utils, test_player_utils_edge_cases, test_channel_state_edge_cases)
   - ✅ Refactored youtube_api.sh into focused modules (core, parsing, video, playlist)
   - ✅ Further split remaining large test files to ensure all files are under 100 lines

2. **YouTube Subscription Management**
   - Add YouTube channel subscription support
   - Implement automatic playlist updates from subscriptions
   - Create subscription configuration management
   - Priority: **MEDIUM** - Nice to have feature

3. **Improve Test Coverage**
   - Add more tests to reach 80%+ project-only coverage
   - Current project-only coverage is 46% (360/779 lines)
   - Priority: **MEDIUM** - Good progress made, continue improving

### 🔧 Low Priority - Polish Tasks

4. **Performance Optimizations**
   - Optimize YouTube API calls with caching
   - Improve playlist loading performance
   - Add background playlist updates
   - Priority: **LOW** - Optimization tasks

5. **User Interface Improvements**
   - Add YouTube channel selection interface
   - Create playlist preview functionality
   - Add video thumbnail display
   - Priority: **LOW** - UI polish

## Quick Start Guide

When you're ready to work on this project:

1. **YouTube Integration is Complete!** - All YouTube functionality is now implemented
2. **Set up YouTube Data API credentials** - Follow the guide in `docs/youtube_setup.md`
3. **Create YouTube playlists** - Use `scripts/youtube_playlist_manager.sh`
4. **Play YouTube channels** - Use `scripts/youtube_channel_player.sh`
5. **Next: YouTube Subscription Management** - Add YouTube channel subscription support and automatic playlist updates

## Reference

- **Completed Tasks**: See [COMPLETED_TASKS.md](COMPLETED_TASKS.md) for all completed work
- **Detailed Phase Documentation**: See `docs/todo/` directory for comprehensive phase details
- **Project Status**: All core functionality is complete, YouTube integration is fully implemented
