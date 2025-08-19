test:
	@echo "Running all tests..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		./node_modules/.bin/bats tests/unit/; \
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
	@export PATH="$$HOME/.local/share/gem/ruby/3.4.0/gems/bashcov-3.2.0/bin:$$PATH"; \
	if command -v bashcov >/dev/null 2>&1; then \
		if [ -f "node_modules/.bin/bats" ]; then \
			bashcov --skip-uncovered -- ./node_modules/.bin/bats tests/unit/ 2>/dev/null; \
			echo ""; \
			./scripts/coverage_analysis.sh; \
		else \
			echo "Bats not found. Run: npm install"; \
			exit 1; \
		fi \
	else \
		echo "bashcov not found. Install with: gem install --user-install bashcov"; \
		echo "Running tests without coverage..."; \
		$(MAKE) test; \
	fi

coverage-analysis:
	@echo "Analyzing coverage..."
	@if [ -f "scripts/coverage_analysis.sh" ]; then \
		./scripts/coverage_analysis.sh; \
	else \
		echo "Coverage analysis script not found."; \
		exit 1; \
	fi
