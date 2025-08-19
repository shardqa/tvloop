test:
	@echo "Running all tests..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		./node_modules/.bin/bats tests/; \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-unit:
	@echo "Running unit tests..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		./node_modules/.bin/bats tests/unit/; \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-integration:
	@echo "Running integration tests..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		./node_modules/.bin/bats tests/integration/; \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-coverage:
	@echo "Running tests with coverage..."
	@if command -v bashcov >/dev/null 2>&1; then \
		if [ -f "node_modules/.bin/bats" ]; then \
			bashcov -- ./node_modules/.bin/bats tests/; \
		else \
			echo "Bats not found. Run: npm install"; \
			exit 1; \
		fi \
	else \
		echo "bashcov not found. Install with: pipx install bashcov or pip install --user bashcov"; \
		echo "Running tests without coverage..."; \
		$(MAKE) test; \
	fi
