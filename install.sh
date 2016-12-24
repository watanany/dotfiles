#!/bin/bash

script_dir=`dirname $0`

# copy files
for file in .zshrc .vimrc .tmux.conf .ghci
do
  echo "copy file $file to ~/$file (created ~/$file.bak file as backup)"
  [ -e ~/$file ] && mv ~/$file ~/$file.bak
  ln -s `readlink -f $script_dir/$file` ~/$file
done

# copy directories
for dir in .zsh .vim
do
  echo "copy directory $dir to ~/$dir"
  rm -rf ~/$dir
  ln -s `readlink -f $script_dir/$dir` ~/$dir
done


# NeoBundle
echo "Install NeoBundle for Vim"
rm -rf $script_dir/.vim/bundle
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh 2>&1 >/dev/null

# tmux plugin manager
# echo "Install tmux plugin manager - tpm"
# rm -rf ~/.tmux
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
