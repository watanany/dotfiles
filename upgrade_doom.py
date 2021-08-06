#!/usr/bin/env python
import shutil
import tempfile
import os.path
from urllib.request import urlopen
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


def install_plantuml():
    url = "http://sourceforge.net/projects/plantuml/files/plantuml.jar/download"
    path = os.path.join(EMACS_DIR, ".local/etc/plantuml.jar")
    with open(path, "wb") as writer, urlopen(url) as res:
        writer.write(res.read())


def main():
    emacs_dir = evacuate_emacs_dir()
    try:
        install_doom()
        install_plantuml()
        if emacs_dir is not None:
            restore(emacs_dir)
    finally:
        print("\n\n", end="")
        print(f"[Info] Original {EMACS_DIR} is moved to {emacs_dir}")


if __name__ == "__main__":
    main()
