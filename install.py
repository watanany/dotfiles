#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import os

HOME: str = os.environ["HOME"]
CONFIG_ROOT: str = os.path.join(HOME, "dotfiles")

DIRS: list[str] = [
    ".config",
    ".cache",
    ".local/bin",
    ".local/share",
    ".tmux/plugins",
    ".ipython/profile_default/startup",
    ".pyenv",
    ".clojure",
]

LINK_LIST: list[str] = [
    ".zsh",
    ".zshrc",
    ".tmux.conf",
    ".ghci",
    ".iex.exs",
    ".config/fish",
    ".config/karabiner",
    ".config/kitty",
    ".local/bin/marked2",
    ".cache/dein",
    ".tmux/plugins/tpm",
    ".git-subcommands",
    ".doom.d",
    ".gitignore_global",
    ".lein",
    ".ipython/profile_default/startup/00-first.py",
    ".config/nvim",
    ".pyenv/default-packages",
    ".clojure/deps.edn",
    ".config/evcxr",
]


def remove_links() -> None:
    home_files = [os.path.join(HOME, fn) for fn in LINK_LIST]
    home_files = [
        path for path in home_files if os.path.exists(path) or os.path.islink(path)
    ]

    for path in home_files:
        print("remove {0}".format(path))
        os.remove(path)


def link_files() -> None:
    home_files = [os.path.join(HOME, fn) for fn in LINK_LIST]
    dot_files = [os.path.join(CONFIG_ROOT, fn) for fn in LINK_LIST]

    for home_file, dot_file in zip(home_files, dot_files):
        print("link\t{0}\tto\t{1}".format(dot_file, home_file))
        os.symlink(dot_file, home_file)


def make_dirs() -> None:
    pathes = [os.path.join(HOME, d) for d in DIRS]
    pathes = [p for p in pathes if not os.path.exists(p)]
    for path in pathes:
        os.makedirs(path)


def main() -> None:
    make_dirs()
    remove_links()
    link_files()


if __name__ == "__main__":
    main()
