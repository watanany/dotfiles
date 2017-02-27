#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os

HOME = os.getenv('HOME')
CONFIG_ROOT = os.path.join(HOME, 'dotfiles')

FILES = ['.zshrc', '.vimrc', '.tmux.conf', '.ghci', '.iex.exs']
DIRS = ['.zsh', '.vim', '.config/nvim', '.git-subcommands']
PATH_LIST = FILES + DIRS

def remove_files():
    home_files = [os.path.join(HOME, fn) for fn in PATH_LIST]
    home_files = [path for path in home_files if os.path.exists(path)]

    for path in home_files:
        os.remove(path)

def link_files():
    home_files = [os.path.join(HOME, fn) for fn in PATH_LIST]
    dot_files = [os.path.join(CONFIG_ROOT, fn) for fn in PATH_LIST]

    for home_file, dot_file in zip(home_files, dot_files):
        print('link\t{}\tto\t{}'.format(dot_file, home_file))
        os.symlink(dot_file, home_file)

def main():
    remove_files()
    link_files()


if __name__ == '__main__':
    main()
