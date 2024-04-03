Vagrant.configure("2") do |config|
    config.vm.box = "TestDC"
    config.vm.box_url = "F:\path\to\vm\hard\disk"
    config.vm.hostname = "TestDC"

    config.vm.network = "domain-test", ip = "172.30.100.0/24"

    config.vm.provider "hyperv" do |hv|
        hv.cpus = "2"
        hv.memory = "2048"
        hv.vm.name = "TestDC"

    bootstrap_script_path = "C:\Path\to\bootstrap\file.ps1"

    config.vm.provision "shell", path: bootstrap_script_path
    end
end
