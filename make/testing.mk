# Bashunit Testing Makefile
# Clean, simple testing with Bashunit

test:
	@echo "Running all tests with Bashunit..."
	@if [ -f "lib/bashunit" ]; then \
		./lib/bashunit --env bashunit.env --parallel tests/test_*.bash; \
	else \
		echo "Bashunit not found. Run: curl -s https://bashunit.typeddevs.com/install.sh | bash"; \
		exit 1; \
	fi

# Run tests in parallel
test-parallel:
	@echo "Running tests in parallel with Bashunit..."
	@if [ -f "lib/bashunit" ]; then \
		./lib/bashunit --env bashunit.env --parallel tests/test_*.bash; \
	else \
		echo "Bashunit not found. Run: curl -s https://bashunit.typeddevs.com/install.sh | bash"; \
		exit 1; \
	fi

# Run tests sequentially (for debugging)
test-seq:
	@echo "Running tests sequentially with Bashunit..."
	@if [ -f "lib/bashunit" ]; then \
		./lib/bashunit --env bashunit.env --no-parallel tests/test_*.bash; \
	else \
		echo "Bashunit not found. Run: curl -s https://bashunit.typeddevs.com/install.sh | bash"; \
		exit 1; \
	fi

# Generate HTML and JUnit reports
test-reports:
	@echo "Running tests with HTML and JUnit reports..."
	@if [ -f "lib/bashunit" ]; then \
		mkdir -p coverage; \
		./lib/bashunit --env bashunit.env --report-html coverage/bashunit.html --log-junit coverage/junit.xml tests/test_*.bash; \
		echo ""; \
		echo "📊 Reports generated:"; \
		echo "  📄 HTML Report: coverage/bashunit.html"; \
		echo "  📄 JUnit XML:   coverage/junit.xml"; \
	else \
		echo "Bashunit not found. Run: curl -s https://bashunit.typeddevs.com/install.sh | bash"; \
		exit 1; \
	fi

# Run tests with verbose output
test-verbose:
	@echo "Running tests with verbose output..."
	@if [ -f "lib/bashunit" ]; then \
		./lib/bashunit --env bashunit.env --verbose tests/test_*.bash; \
	else \
		echo "Bashunit not found. Run: curl -s https://bashunit.typeddevs.com/install.sh | bash"; \
		exit 1; \
	fi

# Run tests with simple output
test-simple:
	@echo "Running tests with simple output..."
	@if [ -f "lib/bashunit" ]; then \
		./lib/bashunit --env bashunit.env --simple tests/test_*.bash; \
	else \
		echo "Bashunit not found. Run: curl -s https://bashunit.typeddevs.com/install.sh | bash"; \
		exit 1; \
	fi

# Clean up generated files
clean-test:
	@echo "Cleaning up test artifacts..."
	@rm -rf coverage/
	@rm -f *.tmp
	@rm -f test_*.log
