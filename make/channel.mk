CHANNEL_DIR ?= channels/channel_1

init:
	@echo "Initializing channel: $(CHANNEL_DIR)"
	@./scripts/channel_tracker.sh $(CHANNEL_DIR) init

status:
	@echo "Channel status: $(CHANNEL_DIR)"
	@./scripts/channel_tracker.sh $(CHANNEL_DIR) status

tune:
	@echo "Tuning in to channel: $(CHANNEL_DIR)"
	@./scripts/channel_player.sh $(CHANNEL_DIR) tune mpv

tune-vlc:
	@echo "Tuning in to channel (VLC): $(CHANNEL_DIR)"
	@./scripts/channel_player.sh $(CHANNEL_DIR) tune vlc

stop:
	@echo "Stopping all players"
	@./scripts/channel_player.sh $(CHANNEL_DIR) stop
