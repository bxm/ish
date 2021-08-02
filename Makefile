# NOTE: stop undesirable builtin actions if name clashes exist
.SUFFIXES:

.DEFAULT_GOAL := help

_icheck: # Inverted check of daemon (internal use)
	@! docker ps -f "Name=busybox" -q | grep .

check: ## Check if daemon running
	@docker ps -f "Name=busybox" -q | grep . && echo Running || echo Not running

kill: ## Kill daemon
	@docker kill busybox

daemon: ## Start daemon
	@docker run --rm -v ${PWD}:/code -w /code --name busybox -d -ti busybox:1.31.1 cat

start: _icheck daemon check ## Start daemon if not running

run: start ## Synonym for start

restart: kill daemon check ## Restart daemon

login: ## Login to daemon
	@docker exec -ti busybox sh


.PHONY: help
help:
	@echo "Usage: make <target>"
	@echo
	@echo "Make targets:"
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo
