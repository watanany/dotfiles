#!/usr/bin/env python
# -*- coding: utf-8 -*-
import sys
import os
import shutil
import requests

HOME = os.getenv('HOME')
CONFIG_ROOT = os.path.join(HOME, 'dotfiles')

FILES = ['.zshrc', '.vimrc', '.tmux.conf', 'ghci']
DIRS = ['.zsh', '.vim', '.config/nvim']

def remove_files():
    home_files = [os.path.join(HOME, fn) for fn in FILES + DIRS]
    for fn in home_files:
        shutil.rmtree(path)

def link_files():
    home_files = [os.path.join(HOME, fn) for fn in FILES + DIRS]
    dot_files = [os.path.join(CONFIG_ROOT, fn) for fn in FILES + DIRS]
    for home_file, dot_files in zip(home_files, dot_files):
        os.link(dot_file, home_file)

def main():
    remove_files()
    link_files()


if __name__ == '__main__':
    main()
