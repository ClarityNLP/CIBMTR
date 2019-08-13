-include env.mk

env.mk: env.sh
	sed 's/"//g ; s/=/:=/' < $< > $@

start-clarity:
		docker-compose pull && docker-compose up -d

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
