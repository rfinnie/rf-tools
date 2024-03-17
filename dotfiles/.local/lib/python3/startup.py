try:
    import rich.pretty
except ImportError:
    pass
else:
    rich.pretty.install()


def _load_startup_local():
    import os
    import sys

    script_dir = os.path.dirname(os.path.realpath(__file__))
    sys.path.append(script_dir)
    try:
        import startup_local
    except ImportError:
        pass


_load_startup_local()
del _load_startup_local
