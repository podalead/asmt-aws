.EXPORT_ALL_VARIABLES:
INFRA_SCRIPT = ./scripts/infra_deployment.sh
CERT_SCRIPT = ./scripts/certs_loading.sh
PROFILE = test
PREFIX = te

.NOTPARALLEL:

.PHONY: help terraform

help:
	@cat Makefile* | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

certs: ## Upload certificates
	@echo "Upload certificates"
	$(CERT_SCRIPT) deploy --profile=$(PROFILE) --prefix=$(PREFIX)

infra-deploy: ## Deploy Infrastructure
	@echo "Deploy infrastructure"
	date
	$(INFRA_SCRIPT) deploy --profile=$(PROFILE) --prefix=$(PREFIX)
	date

test: ## Test infrastructure
	@echo "Run the tests"
	date
	$(INFRA_SCRIPT) test --profile=$(PROFILE) --prefix=$(PREFIX)
	date

infra-cleanup: ## Cleanup Infrastructure
	@echo "Cleanup infrastructure"
	$(INFRA_SCRIPT) cleanup --profile=$(PROFILE) --prefix=$(PREFIX)
