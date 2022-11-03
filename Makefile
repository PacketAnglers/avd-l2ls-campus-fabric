###########################################
# Run AVD with various tags               #
# #########################################

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build AVD Configs
	ansible-playbook build.yml

.PHONY: deploy
deploy: ## Build AVD Configs
	ansible-playbook deploy.yml

.PHONY: start-lab
start-lab: ## Build AVD Configs
	sudo clab deploy -t clab/campus-l2ls.yml --reconfigure

.PHONY: stop-lab
stop-lab: ## Build AVD Configs
	sudo clab destroy -t clab/campus-l2ls.yml