.DEFAULT_GOAL = copy
.PHONY: copy

OS := $(shell uname)

all: config install copy

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
