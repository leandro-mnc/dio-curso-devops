machines = {
  "node01" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"},
  "node02" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"},
  "node03" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"},
  "node04" => {"memory" => "1024", "cpu" => "1", "image" => "bento/ubuntu-22.04"}
}

Vagrant.configure("2") do |config|

  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      machine.vm.box = "#{conf["image"]}"
      machine.vm.hostname = "#{name}"
      machine.vm.network "public_network", bridge: "enp4s0"
      machine.vm.synced_folder "vagrant", "/vagrant"
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
        vb.customize ["modifyvm", "#{name}", "--vram", "12"]
        vb.customize ["modifyvm", "#{name}", "--graphicscontroller", "vmsvga"]

      end

      machine.vm.provision "shell",
        inline: "/bin/sh /vagrant/install.sh #{name}"

      machine.trigger.after :up do |trigger|
        trigger.run_remote = {inline: "/bin/sh /vagrant/trigger-up.sh #{name}"}
      end
    end
  end

end