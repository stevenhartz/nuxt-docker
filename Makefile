# Include file with .env variables if exists
-include .env

# Define default values for variables
COMPOSE_FILE ?= docker-compose.yml

#-----------------------------------------------------------
# Management
#-----------------------------------------------------------

.DEFAULT_GOAL := help

help: ## This help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

env_dev: ## Init variables for development environment
	ln -s .env.dev .env

install: build up ## Build and restart containers

up: ## Start containers
	docker-compose -f ${COMPOSE_FILE} up -d

down: ## Stop containers
	docker-compose -f ${COMPOSE_FILE} down --remove-orphans

build: ## Build containers
	docker-compose -f ${COMPOSE_FILE} build

ps: ## Show list of running containers
	docker-compose -f ${COMPOSE_FILE} ps

restart: ## Restart containers
	docker-compose -f ${COMPOSE_FILE} restart

reboot: down up ## Reboot containers

logs: ## View output from containers
	docker-compose -f ${COMPOSE_FILE} logs --tail 500

fl: ## Follow output from containers (short for 'follow logs')
	docker-compose -f ${COMPOSE_FILE} logs --tail 500 -f

prune: ## Prune stopped docker containers and dangling images
	docker system prune

#-----------------------------------------------------------
# Application
#-----------------------------------------------------------

nuxi_upgrade: ## Upgrade Nuxt
	docker-compose -f ${COMPOSE_FILE} exec app nuxi upgrade --force

nuxi_cleanup: ## Nuxt cleanup dependancies
	docker-compose -f ${COMPOSE_FILE} exec app nuxi cleanup

yarn_install: ## Install yarn dependencies
	docker-compose -f ${COMPOSE_FILE} exec app yarn install

yi: yarn_install ## Alias to install yarn dependencies

yarn_upgrade: ## Upgrade yarn dependencies
	docker-compose -f ${COMPOSE_FILE} exec app yarn upgrade

yu: yarn_upgrade ## Alias to upgrade yarn dependencies

yarn_outdated: ## Show outdated yarn dependencies
	docker-compose exec -f ${COMPOSE_FILE} app yarn outdated

default: help