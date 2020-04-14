RSYNC := rsync

all:

install:
	$(RM) $(HOME)/.tmux.conf-freebsd $(HOME)/.tmux.conf-macos $(HOME)/.tmux.conf.rpi $(HOME)/bin/tmux-status-host
	$(RSYNC) -av $(CURDIR)/dotfiles/ $(HOME)/
