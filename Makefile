default: start logs

service:=tem
project:=flask

.PHONY: start
start:
	docker-compose -p ${project} up -d

.PHONY: devstart
devstart:
	docker-compose -f docker-compose.dev.yml -p ${project} up -d

.PHONY: stop
stop:
	docker-compose -p ${project} down

.PHONY: restart
restart: stop start

.PHONY: prod
prod: start stamp migrate upgrade

.PHONY: dev
dev: devstart stamp migrate upgrade

.PHONY: ps
ps:
	docker-compose -p ${project} ps

.PHONY: logs
logs:
	docker-compose -p ${project} logs -f

.PHONY: logs-app
logs-app:
	docker-compose -p ${project} logs -f ${service}

# connect to the microservice cli for debugging
.PHONY: shell
shell:
	docker-compose -p ${project} exec ${service} bash

.PHONY: build
build:
	docker-compose -p ${project} build --no-cache


.PHONY: install-package-in-container
install-package-in-container:
	docker-compose -p ${project} exec ${service} pip install ${package}
	docker-compose -p ${project} exec ${service} pip freeze > requirements.txt

.PHONY: stamp
stamp:
	docker-compose -p ${project} exec ${service} flask db stamp head

.PHONY: migrate
migrate:
	docker-compose -p ${project} exec ${service} flask db migrate 

.PHONY: upgrade
upgrade:
	docker-compose -p ${project} exec ${service} flask db upgrade 

.PHONY: add
add: start install-package-in-container build

.PHONY: deps
deps:
	docker-compose -p ${project} exec ${service} pip install -r requirements.txt

.PHONY: lint
lint:
	# docker-compose -p ${project} exec ${service} pylint app.py src/*.py tests/**/*.py
	pylint app.py src/ --disable=E1101

# .PHONY: test
# test: start test-run-only

# .PHONY: test-run-only
# test-run-only:
# 	docker-compose -p ${project} exec ${service} pytest