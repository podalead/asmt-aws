.EXPORT_ALL_VARIABLES:
COMMON_SCRIPT = ./scripts/start.sh
PROFILE = test
PREFIX = te

.NOTPARALLEL:

.PHONY: help terraform

help:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

deploy: ## Deploy Infrastructure
	@echo "Deploy infrastructure"
	$(COMMON_SCRIPT) deploy --profile=$(PROFILE) --prefix=$(PREFIX)

test: ## Test infrastructure
	@echo "Run the tests"
	$(COMMON_SCRIPT) test --profile=$(PROFILE) --prefix=$(PREFIX)

cleanup: ## Cleanup Infrastructure
	@echo "Cleanup infrastructure"
	$(COMMON_SCRIPT) cleanup --profile=$(PROFILE) --prefix=$(PREFIX)
