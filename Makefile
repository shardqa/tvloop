.PHONY: init status tune tune-vlc stop clean help test test-unit test-integration test-coverage playlist-info playlist-validate logs

include make/channel.mk
include make/playlist.mk
include make/testing.mk
include make/utils.mk

help:
	@echo "24-Hour Video Channel - Available commands:"
	@echo ""
	@echo "Channel Management:"
	@echo "  make init          - Initialize channel state"
	@echo "  make status        - Show channel status"
	@echo "  make tune          - Tune in to channel (mpv)"
	@echo "  make tune-vlc      - Tune in to channel (VLC)"
	@echo "  make stop          - Stop all players"
	@echo ""
	@echo "Playlist Management:"
	@echo "  make playlist-info - Show playlist information"
	@echo "  make playlist-validate - Validate playlist"
	@echo ""
	@echo "Testing:"
	@echo "  make test          - Run all tests"
	@echo "  make test-unit     - Run unit tests only"
	@echo "  make test-integration - Run integration tests only"
	@echo "  make test-coverage - Run tests with coverage report"
	@echo "  make coverage-analysis - Show coverage analysis"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean         - Clean up temporary files"
	@echo "  make logs          - Show recent logs"
	@echo ""
	@echo "Configuration:"
	@echo "  CHANNEL_DIR=path   - Specify channel directory"
