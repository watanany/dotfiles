#!/usr/bin/env python
import shutil
import tempfile
import os.path
from subprocess import Popen, PIPE

EMACS_DIR = os.path.expanduser("~/.emacs.d")
DOOM = os.path.join(EMACS_DIR, "bin", "doom")


def evacuate_emacs_dir():
    if os.path.exists(EMACS_DIR):
        tempdir = tempfile.mkdtemp()
        shutil.move(EMACS_DIR, tempdir)
        return os.path.join(tempdir, ".emacs.d")
    else:
        return None


def install_doom():
    clone_p = Popen(
        [
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/hlissner/doom-emacs",
            EMACS_DIR,
        ]
    )
    clone_p.wait()
    install_p = Popen(f"yes | {DOOM} install", shell=True)
    install_p.wait()


def restore(emacs_dir):
    shutil.copy(
        os.path.join(emacs_dir, ".local/etc/lsp-session"),
        os.path.join(EMACS_DIR, ".local/etc/lsp-session"),
    )
    shutil.copy(
        os.path.join(emacs_dir, ".local/cache/recentf"),
        os.path.join(EMACS_DIR, ".local/cache/recentf"),
    )
    shutil.copy(
        os.path.join(emacs_dir, ".local/cache/projectile.projects"),
        os.path.join(EMACS_DIR, ".local/cache/projectile.projects"),
    )


def main():
    emacs_dir = evacuate_emacs_dir()
    install_doom()
    if emacs_dir is not None:
        restore(emacs_dir)
    print(f"Original {EMACS_DIR} is moved to {emacs_dir}")


if __name__ == "__main__":
    main()