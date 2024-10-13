# Makefile for Docker Management

# Define service names for Docker Compose
DOCKER_COMPOSE = docker-compose -f docker-compose.yml
DOCKER=docker
APP_SERVICE = app
WEB_SERVICE = nginx
DB_SERVICE = mongodb

#Test Make File
test:
	@echo "Make file is working";

# Start the Docker containers (build if necessary)
up:
	@$(DOCKER_COMPOSE) up -d --build
	@echo "Containers are up and running."

# Stop the running containers
down:
	@$(DOCKER_COMPOSE) down
	@echo "Containers have been stopped."

# Rebuild containers without cache
rebuild:
	@$(DOCKER_COMPOSE) build 
	@$(DOCKER_COMPOSE) up -d
	@echo "Containers rebuilt and started."

# Start only the app and web services
start-app:
	@$(DOCKER_COMPOSE) up -d $(APP_SERVICE) $(WEB_SERVICE)
	@echo "App and web services started."

# Start all services (app, web, db)
start-all:
	@$(DOCKER_COMPOSE) up -d $(APP_SERVICE) $(WEB_SERVICE) $(DB_SERVICE)
	@echo "All services started."

# Stop all services
stop:
	@$(DOCKER_COMPOSE) stop
	@echo "Containers stopped."

# View logs for the Laravel app service
logs:
	@$(DOCKER_COMPOSE) logs -f $(APP_SERVICE)

# View logs for all services
logs-all:
	@$(DOCKER_COMPOSE) logs -f

# Execute bash in the app container
bash:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) /bin/bash

# Run Composer install
composer-install:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) composer install
	@echo "Composer dependencies installed."

# Run Artisan commands
artisan:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) php artisan $(cmd)
# Add a specific target for migrations if needed
migrate:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) php artisan migrate

# Run NPM install
npm-install:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) npm install
	@echo "NPM dependencies installed."

# Run NPM build (for frontend assets)
npm-build:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) npm run build
	@echo "Frontend assets built."

# Clear Laravel cache
cache-clear:
	@$(DOCKER_COMPOSE) exec $(APP_SERVICE) php artisan cache:clear

# Restart the application container
restart-app:
	@$(DOCKER_COMPOSE) restart $(APP_SERVICE)
	@echo "Laravel app restarted."

# Restart all services
restart-all:
	@$(DOCKER_COMPOSE) restart
	@echo "All services restarted."

# View container status
status:
	@$(DOCKER_COMPOSE) ps

# Clean Docker system
docker-clean:
	@docker system prune -af
	@echo "Docker system cleaned up."

# Remove all Docker volumes
clean-volumes:
	@docker volume prune -f
	@echo "All Docker volumes removed."

