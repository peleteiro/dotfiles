.DEFAULT_GOAL = all
.PHONY: all

all: config install copy dev\-domain

config:
	@./bin/osx-config

install:
	@./bin/install

copy:
	@./bin/copy-home

dev\-domain:
	@./bin/setup-dev-domains
