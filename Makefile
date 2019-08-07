-include env.mk

env.mk: env.sh
	sed 's/"//g ; s/=/:=/' < $< > $@

DOCKER_VERSION := $(shell docker --version 2>/dev/null)
DOCKER_COMPOSE_VERSION := $(shell docker-compose --version 2>/dev/null)

all:
ifndef DOCKER_VERSION
    $(error Makefile -- command docker is not available, please install Docker)
endif
ifndef DOCKER_COMPOSE_VERSION
    $(error Makefile -- command docker-compose is not available, please install Docker)
endif
ifeq ($(OS),Windows_NT)
    $(error Makefile -- local dns solution not ready for windows)
else
    UNAME_S := $(shell uname -s)
    $(info Makefile -- non windows distro detected)
ifeq ($(UNAME_S),Darwin)
    $(info Makefile -- OSX detected)
ifneq ("$(wildcard /etc/resolver/test)","")
    $(info Makefile -- test resolver already exists at /etc/resolver/test)
else
    $(info Makefile -- test resolver not found. Creating /etc/resolver/test)
    $(shell sudo mkdir -p /etc/resolver/ && echo "nameserver 127.0.0.1" | sudo tee -a /etc/resolver/test > /dev/null)
endif
endif
ifeq ($(UNAME_S),Linux)
    $(error local dns solution not ready for linux)
endif
endif

start-clarity:
		docker-compose up

stop-clarity:
		docker-compose down --remove-orphans

start-clarity-local:
		docker-compose -f docker-compose.local.yml up

stop-clarity-local:
		docker-compose -f docker-compose.local.yml down --remove-orphans

restart-clarity:
		docker-compose restart

rm-clarity:
		docker-compose kill
		docker-compose rm -f

reset-clarity: rm-clarity start-clarity
