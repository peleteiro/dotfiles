.DEFAULT_GOAL = copy
.PHONY: copy

OS := $(shell uname)

all: config install copy dev-domain

config:
ifeq ($(OS), Darwin)
	@./bin/osx-config
endif

install:
ifeq ($(OS), Darwin)
	@./bin/osx-install
else
	@./bin/linux-install
endif

copy:
	@./bin/copy-home

dev-domain:
ifeq ($(OS), Darwin)
	@./bin/osx-setup-dev-domains
endif
