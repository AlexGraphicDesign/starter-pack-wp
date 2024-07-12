build: ## Build docker image
	docker-compose build
	make up

up: down ## Run containers
	docker-compose up -d

down: ## Stop all containers
	docker-compose down

php: ## Connect to the PHP container
	docker-compose exec --user www-data php bash

init-project: generate-env build download-wp download-wp-cli success-message

composer: ## Install Composer dependencies
	docker-compose exec --user www-data php bash -c 'cd confidential && composer install'

composer-u: ## Update Composer dependencies
	docker-compose exec --user www-data php bash -c 'cd confidential && composer update'

download-wp: ## Download Wordpress
	docker-compose exec --user www-data php bash -c 'mkdir wp-temp && composer create-project roots/bedrock wp-temp && shopt -s dotglob && mv wp-temp/* . && shopt -u dotglob &&  rm -rf wp-temp'

download-wp-cli: ## Download the wp-cli.phar
	docker-compose exec --user www-data php bash -c 'curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
	docker-compose exec php bash -c 'chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp'

generate-env:
	@rm -f .env
	@echo "HOST=`hostname -I | cut -d ' ' -f1`" >> .env

success-message: ## Display success message
	@printf "\n\n"
	@printf "================\n"
	@printf "Le site est disponible ici : https://starter-pack-wp.dev.localhost  \n"
	@printf "================\n"

help: ## Display this help message
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-20s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'