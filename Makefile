RSYNC := rsync

all:

install:
	$(RSYNC) -av $(CURDIR)/dotfiles/ $(HOME)/
