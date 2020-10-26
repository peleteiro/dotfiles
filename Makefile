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
	@./bin/vscode-install

copy:
	@./bin/copy-home

gnome-shell-reload: copy
	killall -SIGQUIT gnome-shell

gnome-shell-log:
	journalctl /usr/bin/gnome-shell -f
