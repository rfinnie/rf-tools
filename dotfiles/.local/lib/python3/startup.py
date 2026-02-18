# SPDX-PackageName: rf-tools
# SPDX-PackageSupplier: Ryan Finnie <ryan@finnie.org>
# SPDX-PackageDownloadLocation: https://github.com/rfinnie/rf-tools
# SPDX-FileComment: Python startup config
# SPDX-FileCopyrightText: © 2024 Ryan Finnie <ryan@finnie.org>
# SPDX-License-Identifier: MPL-2.0

import os
import sys

try:
    import rich.pretty
except ImportError:
    pass
else:
    rich.pretty.install()

script_dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(script_dir)
try:
    from startup_local import *  # noqa: F401,F403
except ImportError:
    pass

del os, sys, script_dir
