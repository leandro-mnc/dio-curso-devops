machines = {
  "master" => {"memory" => "1024", "cpu" => "1", "ip" => "200", "image" => "bento/ubuntu-22.04"},
  "node01" => {"memory" => "1024", "cpu" => "1", "ip" => "201", "image" => "bento/ubuntu-22.04"},
  "node02" => {"memory" => "1024", "cpu" => "1", "ip" => "202", "image" => "bento/ubuntu-22.04"},
  "node03" => {"memory" => "1024", "cpu" => "1", "ip" => "203", "image" => "bento/ubuntu-22.04"}
}

Vagrant.configure("2") do |config|

  machines.each do |name, conf|
    config.vm.define "#{name}" do |machine|
      machine.vm.box = "#{conf["image"]}"
      machine.vm.hostname = "#{name}"
      machine.vm.network "public_network", bridge: "enp4s0", ip: "10.0.0.#{conf["ip"]}"
      machine.vm.synced_folder "vagrant", "/vagrant"
      machine.vm.provider "virtualbox" do |vb|
        vb.name = "#{name}"
        vb.memory = conf["memory"]
        vb.cpus = conf["cpu"]
        vb.customize ["modifyvm", "#{name}", "--vram", "12"]
        vb.customize ["modifyvm", "#{name}", "--graphicscontroller", "vmsvga"]

      end

      machine.vm.provision "shell",
        inline: "/bin/sh /vagrant/docker.sh #{name}"

      if "#{name}" == "master" then
        machine.vm.provision "shell", inline: "/bin/sh /vagrant/master.sh #{name}"
      else
        machine.vm.provision "shell", inline: "/bin/sh /vagrant/worker.sh"
      end

    end
  end

end