# SPDX-PackageSummary: rf-tools
# SPDX-FileCopyrightText: © 2026 Ryan Finnie <ryan@finnie.org>
# SPDX-License-Identifier: MPL-2.0

RSYNC := rsync

all:

install:
	$(RSYNC) -av $(CURDIR)/dotfiles/ $(HOME)/
