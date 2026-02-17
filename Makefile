# SPDX-PackageName: rf-tools
# SPDX-PackageSupplier: Ryan Finnie <ryan@finnie.org>
# SPDX-PackageDownloadLocation: https://github.com/rfinnie/rf-tools
# SPDX-FileComment: Makefile
# SPDX-FileCopyrightText: © 2026 Ryan Finnie <ryan@finnie.org>
# SPDX-License-Identifier: MPL-2.0

RSYNC := rsync

all:

install:
	$(RSYNC) -av $(CURDIR)/dotfiles/ $(HOME)/
