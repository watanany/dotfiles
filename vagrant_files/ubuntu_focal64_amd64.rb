# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/focal64'

  config.vm.network 'forwarded_port', guest: 80, host: 8080
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 3001, host: 3001
  config.vm.network 'forwarded_port', guest: 3002, host: 3002
  config.vm.network 'forwarded_port', guest: 8191, host: 8191
  config.vm.network 'private_network', ip: '192.168.56.10'

  config.vm.synced_folder './data', '/vagrant_data'

  # VirtualBox用の設定
  config.vm.provider 'virtualbox' do |v|
    # VirtualBoxのGUI画面に表示される名前
    v.name = File.basename(Dir.pwd)

    # 使用するメモリ量を設定
    v.memory = '4096'

    # CPU数を設定
    v.cpus = 4

    # これがないとvagrant upのときに固まるときがある
    v.gui = true
  end

  config.vm.provision 'shell', inline: <<-SHELL
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -y

    apt-get install -y build-essential
    apt-get install -y cmake libtool-bin

    add-apt-repository -y ppa:kelleyk/emacs
    apt-get update
    apt-get install -y emacs27
  SHELL

  config.vm.disk :disk, size: '100GB', primary: true
end

