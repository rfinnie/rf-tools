all:
	$(RM) $(HOME)/.tmux.conf-freebsd $(HOME)/.tmux.conf-macos $(HOME)/.tmux.conf.rpi
	rsync -av $(CURDIR)/dotfiles/ $(HOME)/
	mkdir -p $(HOME)/bin
	rsync -av $(CURDIR)/bin/tmux-status-host $(HOME)/bin/
