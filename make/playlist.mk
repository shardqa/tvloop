playlist-info:
	@echo "Playlist information: $(CHANNEL_DIR)"
	@./scripts/playlist_manager.sh $(CHANNEL_DIR)/playlist.txt

playlist-validate:
	@echo "Validating playlist: $(CHANNEL_DIR)"
	@./scripts/playlist_manager.sh $(CHANNEL_DIR)/playlist.txt validate
