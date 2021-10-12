# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/focal64'

  config.vm.network 'forwarded_port', guest: 8080, host: 8080
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 3001, host: 3001
  config.vm.network 'forwarded_port', guest: 3002, host: 3002
  # config.vm.network 'forwarded_port', guest: 8191, host: 8191
  config.vm.network 'private_network', ip: '192.168.56.10'

  config.vm.synced_folder File.expand_path('~/sanctum'), '/sanctum'

  # VirtualBox用の設定
  config.vm.provider 'virtualbox' do |v|
    # VirtualBoxのGUI画面に表示される名前
    v.name = File.basename(Dir.pwd)

    # 使用するメモリ量を設定
    v.memory = '4096'

    # CPU数を設定
    v.cpus = 4
  end

  config.vm.provision 'shell', inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -y

    apt-get install -y locales-all
    apt-get install -y build-essential
    apt-get install -y cmake libtool-bin

    add-apt-repository -y ppa:kelleyk/emacs
    apt-get update
    apt-get install -y emacs27

    apt-get install -y locales-all
    apt-get install -y zsh tmux tree ripgrep fd-find xclip fonts-firacode

    # pyenv
    # cf. <https://github.com/pyenv/pyenv/wiki#suggested-build-environment>
    apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

    # rbenv(ruby-build)
    # cf. <https://github.com/rbenv/ruby-build/wiki#suggested-build-environment>
    apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

    # nodenv(node-build)
    # cf. <https://github.com/nodenv/node-build/wiki#suggested-build-environment>
    apt-get install -y python3 g++ make
  SHELL

  config.vm.disk :disk, size: '100GB', primary: true
end

