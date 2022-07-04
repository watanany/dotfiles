#!/usr/bin/env python3
# -*- coding: utf-8 -*-
from __future__ import print_function
import os

HOME = os.getenv('HOME')
CONFIG_ROOT = os.path.join(HOME, 'dotfiles')

DIRS = [
    '.config',
    '.cache',
    '.local/bin',
    '.local/share',
    '.tmux/plugins',
]

LINK_LIST = [
    '.zsh',
    '.zshrc',
    '.vim',
    '.vimrc',
    '.tmux.conf',
    '.ghci',
    '.iex.exs',
    '.config/fish',
    '.config/karabiner',
    '.local/bin/marked2',
    '.cache/dein',
    '.tmux/plugins/tpm',
    '.git-subcommands',
    '.doom.d',
    '.gitignore_global',
    '.lein',
]

NEOVIM_CONFIG = '.config/nvim'

def remove_links():
    home_files = [os.path.join(HOME, fn) for fn in LINK_LIST + [NEOVIM_CONFIG]]
    home_files = [path for path in home_files if os.path.exists(path) or os.path.islink(path)]

    for path in home_files:
        print('remove {0}'.format(path))
        os.remove(path)

def link_files():
    home_files = [os.path.join(HOME, fn) for fn in LINK_LIST]
    dot_files = [os.path.join(CONFIG_ROOT, fn) for fn in LINK_LIST]

    for home_file, dot_file in zip(home_files, dot_files):
        print('link\t{0}\tto\t{1}'.format(dot_file, home_file))
        os.symlink(dot_file, home_file)

def link_neovim_config():
    vim = os.path.join(CONFIG_ROOT, '.vim')
    neovim = os.path.join(HOME, NEOVIM_CONFIG)
    os.symlink(vim, neovim)

def make_dirs():
    pathes = [os.path.join(HOME, d) for d in DIRS]
    pathes = [p for p in pathes if not os.path.exists(p)]
    for path in pathes:
        os.makedirs(path)

def main():
    make_dirs()
    remove_links()
    link_files()
    link_neovim_config()


if __name__ == '__main__':
    main()
