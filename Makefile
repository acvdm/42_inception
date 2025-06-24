WP_DATA = /home/anvander/data/wordpress
DB_DATA = /home/anvander/data/mariadb

all: up

up:	build
	@mkdir -p $(WP_DATA)
	@mkdir -p $(DB_DATA)
	docker compose -f ./srcs/docker-compose.yml up -d

down:
	docker compose -f ./srcs/docker-compose.yml down

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml start

build:
	docker compose -f ./srcs/docker-compose.yml build

clean:
	@containers=$$(docker ps -aq)
	@docker stop $$containers || true
	@docker rm $$containers || true

	@images=$$(docker images -aq)
	@docker rmi -f $$images || true

	@volume=$$(docker volume ls -q)
	@docker volume rm $$volume || true

	@network=$$(docker network ls -q)
	@docker network rm $$network || true

re: clean up

prune:	clean
	@docker system prune -a --volumes -f