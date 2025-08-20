# Default number of parallel jobs (can be overridden with JOBS=N)
JOBS ?= 8

test:
	@echo "Running all tests in parallel (jobs: $(JOBS))..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		if command -v parallel >/dev/null 2>&1; then \
			./node_modules/.bin/bats --jobs $(JOBS) tests/unit/; \
		else \
			echo "GNU parallel not found. Running tests sequentially..."; \
			./node_modules/.bin/bats tests/unit/; \
		fi \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-unit:
	@echo "Running unit tests in parallel (jobs: $(JOBS))..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		if command -v parallel >/dev/null 2>&1; then \
			./node_modules/.bin/bats --jobs $(JOBS) tests/unit/; \
		else \
			echo "GNU parallel not found. Running tests sequentially..."; \
			./node_modules/.bin/bats tests/unit/; \
		fi \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-integration:
	@echo "Running integration tests in parallel (jobs: $(JOBS))..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		if command -v parallel >/dev/null 2>&1; then \
			./node_modules/.bin/bats --jobs $(JOBS) tests/integration/; \
		else \
			echo "GNU parallel not found. Running tests sequentially..."; \
			./node_modules/.bin/bats tests/integration/; \
		fi \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

# Sequential testing targets (for debugging or when parallelization causes issues)
test-seq:
	@echo "Running all tests sequentially..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		./node_modules/.bin/bats tests/unit/; \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-unit-seq:
	@echo "Running unit tests sequentially..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		./node_modules/.bin/bats tests/unit/; \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

# Fast testing with fewer jobs (for CI/CD or slower systems)
test-fast:
	@echo "Running tests with minimal parallelization (jobs: 2)..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		if command -v parallel >/dev/null 2>&1; then \
			./node_modules/.bin/bats --jobs 2 tests/unit/; \
		else \
			echo "GNU parallel not found. Running tests sequentially..."; \
			./node_modules/.bin/bats tests/unit/; \
		fi \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

# Maximum parallelization (use with caution)
test-max:
	@echo "Running tests with maximum parallelization (jobs: 16)..."
	@if [ -f "node_modules/.bin/bats" ]; then \
		if command -v parallel >/dev/null 2>&1; then \
			./node_modules/.bin/bats --jobs 16 tests/unit/; \
		else \
			echo "GNU parallel not found. Running tests sequentially..."; \
			./node_modules/.bin/bats tests/unit/; \
		fi \
	else \
		echo "Bats not found. Run: npm install"; \
		exit 1; \
	fi

test-coverage:
	@echo "Running tests with coverage in parallel (jobs: $(JOBS))..."
	@export PATH="$$HOME/.local/share/gem/ruby/3.4.0/gems/bashcov-3.2.0/bin:$$PATH"; \
	if command -v bashcov >/dev/null 2>&1; then \
		if [ -f "node_modules/.bin/bats" ]; then \
			if command -v parallel >/dev/null 2>&1; then \
				bashcov --skip-uncovered -- ./node_modules/.bin/bats --jobs $(JOBS) tests/unit/ 2>/dev/null; \
			else \
				bashcov --skip-uncovered -- ./node_modules/.bin/bats tests/unit/ 2>/dev/null; \
			fi \
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
