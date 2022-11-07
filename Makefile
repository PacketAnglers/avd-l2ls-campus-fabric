###########################################
# Run AVD with various tags               #
# #########################################

.PHONY: help
help: ## Display help message
	@grep -E '^[0-9a-zA-Z_-]+\.*[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build Configs
	ansible-playbook playbooks/build.yml

.PHONY: deploy
deploy: ## Deploy Configs
	ansible-playbook playbooks/deploy.yml

.PHONY: ping
ping: ## Test Connectivity
	ansible-playbook playbooks/ping.yml


.PHONY: inspect-lab
inspect-lab: ## Inspect Running Lab
	sudo clab inspect -t clab/campus-l2ls.yml

.PHONY: start-lab
start-lab: ## Start Lab
	sudo clab deploy -t clab/campus-l2ls.yml --reconfigure

.PHONY: stop-lab
stop-lab: ## Stop Lab
	sudo clab destroy -t clab/campus-l2ls.yml --cleanup