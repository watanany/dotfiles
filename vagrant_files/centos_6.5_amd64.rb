# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  # 使用するBOX名
  box_name = 'CentOS 6.5 x86_64 with 50G dynamic disk for Docker work'
  config.vm.box = box_name
  config.vm.box_url = 'https://googledrive.com/host/0B4tZlTbOXHYWVGpHRWZuTThGVUE/centos65_virtualbox_50G.box'

  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.network 'forwarded_port', guest: 3001, host: 3001
  config.vm.network 'forwarded_port', guest: 3002, host: 3002
  config.vm.network 'private_network', ip: '192.168.56.10'

  # VirtualBox用の設定
  config.vm.provider 'virtualbox' do |v|
    # VirtualBoxのGUI画面に表示される名前
    v.name = File.basename(Dir.pwd)

    # 使用するメモリ量を設定
    v.memory = '4096'

    # CPU数を設定
    v.cpus = 4

    # IO/APICを有効化
    v.customize ['modifyvm', :id, '--ioapic', 'on']

    # これがないとvagrant upのときに固まるときがある
    v.gui = true
  end
end
