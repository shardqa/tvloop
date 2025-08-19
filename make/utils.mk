clean:
	@echo "Cleaning up temporary files"
	@rm -f $(CHANNEL_DIR)/*.pid
	@rm -f logs/channel_activity.log
	@rm -rf /tmp/tvloop_test_*
	@rm -f /tmp/test_video*.mp4
	@echo "Cleanup complete"

logs:
	@echo "Recent channel activity:"
	@tail -20 logs/channel_activity.log 2>/dev/null || echo "No logs found"
