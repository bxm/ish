# NOTE: stop undesirable builtin actions if name clashes exist
.SUFFIXES:

.DEFAULT_GOAL := help
CMD=/bin/ash

_icheck: # Inverted check of BusyBox daemon (internal use)
	@! docker ps -f "Name=busybox" -q | grep .

check: ## Check if BusyBox daemon running
	@docker ps -f "Name=busybox" -q | grep . && echo Running || echo Not running

stat: check ## Synonym for 'check'

kill: ## Kill BusyBox daemon
	@docker kill busybox

daemon: ## Start BusyBox daemon
	@docker run --rm -v ${PWD}:/code -w /code --name busybox -d -ti busybox:1.31.1 cat

start: _icheck daemon check ## Start BusyBox daemon if not running

run: ## Run a command inside ephermeral BusyBox (use CMD="foo bar")
	@echo "Starting ephermeral container to run '$(CMD)'"
	@sleep 1
	docker run --rm -v ${PWD}:/code -w /code -ti busybox:1.31.1 $(CMD)

restart: kill daemon check ## Restart BusyBox daemon

login: ## Login to BusyBox daemon
	@docker exec -ti busybox sh


.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Make targets:"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
