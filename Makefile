# URL des dépôts Git
FRONTEND_REPO=git@github.com:Ynov-CI-CD/Frontend.git
BACKEND_REPO=git@github.com:Ynov-CI-CD/Backend.git

# Détection de la commande docker-compose
DOCKER_COMPOSE = $(shell if docker compose version > /dev/null 2>&1; then echo "docker compose"; else echo "docker-compose"; fi)

.PHONY: init
init:
	@if [ ! -d "./Frontend" ]; then \
		echo "Cloning Frontend repository..."; \
		git clone -b develop $(FRONTEND_REPO); \
	else \
		echo "Frontend repository already exists."; \
	fi
	@if [ -f "./Frontend/.env.example" ]; then \
		echo "Copying .env.example to .env in Frontend..."; \
		cp ./Frontend/.env.example ./Frontend/.env; \
	fi
	@if [ -d "./Frontend" ]; then \
		echo "Installing Frontend dependencies..."; \
		cd Frontend && npm install; \
	fi
	@if [ ! -d "./Backend" ]; then \
		echo "Cloning Backend repository..."; \
		git clone -b develop $(BACKEND_REPO); \
	else \
		echo "Backend repository already exists."; \
	fi
	@if [ -f "./Backend/.env.example" ]; then \
		echo "Copying .env.example to .env in Backend..."; \
		cp ./Backend/.env.example ./Backend/.env; \
	fi
	@if [ -d "./Backend" ]; then \
		echo "Installing Backend dependencies..."; \
		cd Backend && npm install; \
	fi

.PHONY: update
update:
	@echo "Updating current directory repository..."
	@git checkout develop && git pull

	@if [ -d "./Frontend" ]; then \
		echo "Updating Frontend repository..."; \
		cd Frontend && git checkout develop  && git pull; \
	fi
	@if [ -d "./Frontend" ]; then \
		echo "Installing Frontend dependencies..."; \
		cd Frontend && npm install; \
	fi
	@if [ -d "./Backend" ]; then \
		echo "Updating Backend repository..."; \
		cd Backend && git checkout develop  && git pull; \
	fi
	@if [ -d "./Backend" ]; then \
		echo "Installing Backend dependencies..."; \
		cd Backend && npm install; \
	fi

.PHONY: start
start:
	$(DOCKER_COMPOSE) up -d

.PHONY: stop
stop:
	$(DOCKER_COMPOSE) down

.PHONY: restart
restart: stop start

.PHONY: logs
logs:
	docker-compose logs -f