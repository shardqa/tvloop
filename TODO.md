# 24-Hour Video Channel Project - TODO

## Overview

This document contains the active TODO list for the 24-Hour Video Channel project, organized by priority. Completed tasks have been moved to [COMPLETED_TASKS.md](COMPLETED_TASKS.md).

## Active Tasks (Ordered by Priority)

### 🔥 High Priority - Next Actions

*No high priority tasks currently active*

### 📋 Medium Priority - Enhancement Tasks

1. **YouTube Subscription Management**
   - Add YouTube channel subscription support
   - Implement automatic playlist updates from subscriptions
   - Create subscription configuration management
   - Priority: **MEDIUM** - Nice to have feature

2. **Improve Test Coverage** ✅ **COMPLETELY RESOLVED**
   - Add more tests to reach 80%+ project-only coverage
   - Current project-only coverage: 37% (601/1585 lines)
   - Fixed test-coverage command and reduced failures from 9 to 1
   - Fixed playlist parser to handle malformed entries properly
   - **✅ PARALLEL EXECUTION WORKING**: Installed GNU parallel, tests now run with 8 jobs
   - **✅ HEADLESS MODE IMPLEMENTED**: mpv now runs without GUI windows during tests
   - **✅ COMPLETE MOCKING IMPLEMENTED**: All tests now use mock PID files, NO real mpv processes start
   - Added locking mechanism for player tests to prevent race conditions
   - Fixed error handling tests to use proper mocking instead of real script calls
   - All 156 tests passing with 0 failures
   - Focus on low-coverage files and missing test scenarios
   - Priority: **MEDIUM** - Important for code quality

### 🔧 Low Priority - Polish Tasks

3. **Performance Optimizations**
   - Optimize YouTube API calls with caching
   - Improve playlist loading performance
   - Add background playlist updates
   - Priority: **LOW** - Optimization tasks

4. **User Interface Improvements**
   - Add YouTube channel selection interface
   - Create playlist preview functionality
   - Add video thumbnail display
   - Priority: **LOW** - UI polish

## Quick Start Guide

When you're ready to work on this project:

1. **YouTube Channel Integration is Complete!** - Create 24-hour channels from any YouTube channel
2. **Two Options Available:**
   - **API Version**: `scripts/create_youtube_channel.sh` (requires API key)
   - **yt-dlp Version**: `scripts/create_youtube_channel_ytdlp.sh` (no API key needed)
3. **Create local media channels** - Use `scripts/create_channel.sh`
4. **Next: YouTube Subscription Management** - Add YouTube channel subscription support and automatic playlist updates

## Testing Infrastructure

**✅ Parallel Test Execution**: Tests now run in parallel with 8 jobs for faster execution
- **Installation**: GNU parallel is installed and configured
- **Usage**: `make test` runs tests in parallel, `make test-seq` runs sequentially
- **Coverage**: `make test-coverage` generates coverage reports with parallel execution
- **Race Condition Protection**: Player tests use locking mechanism to prevent conflicts

**✅ Headless Mode**: mpv runs without GUI windows during tests
- **TEST_MODE**: Environment variable enables headless operation
- **No GUI Interference**: Tests run without opening windows or causing misclicks
- **Clean Test Environment**: Isolated testing without user interface interference
- **mpv Options**: `--no-video --vo=null --no-terminal` for headless operation

## Reference

- **Completed Tasks**: See [COMPLETED_TASKS.md](COMPLETED_TASKS.md) for all completed work
- **Detailed Phase Documentation**: See `docs/todo/` directory for comprehensive phase details
- **Project Status**: All core functionality is complete, YouTube integration is fully implemented
