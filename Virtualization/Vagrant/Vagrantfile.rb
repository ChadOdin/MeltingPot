Vagrant.configure("2") do |config|
    config.vm.box = "TestDC"
    config.vm.box_url = "F:\path\to\vm\hard\disk"
    config.vm.hostname = "TestDC"

    config.vm.network = "domain-test", ip = "172.30.100.10"

    config.vm.provider "hyperv" do |hv|
        hv.cpus = "2"
        hv.memory = "2048"
        hv.vm.name = "TestDC"

    bootstrap_script_path = "C:\Path\to\bootstrap\file.ps1"

    config.vm.provision "shell", path: bootstrap_script_path, privileged: true
        end
    end

    config.define.box "Elastisearch-SEIM" do |Elastisearch|
        config.vm.box = "Elastisearch"
        config.vm.box_url = "F:\path\to\vm\hard\disk"
        config.vm.hostname = "Elasti-SEIM"
    
        config.vm.network = "domain-test", ip = "172.30.100.11"
    
        config.vm.provider "hyperv" do |hv|
            hv.cpus = "2"
            hv.memory = "2048"
            hv.vm.name = "Elastisearch"
    
        bootstrap_script_path = "C:\Path\to\bootstrap\file.sh"
    
        config.vm.provision "shell", path: bootstrap_script_path, privileged: true
        end
    end

    config.define.box "Kibana" do |kibana|
        config.vm.box = "Kibana-SEIM"
        config.vm.box_url = "F:\path\to\vm\hard\disk"
        config.vm.hostname = "Kibana-SEIM"
    
        config.vm.network = "domain-test", ip = "172.30.100.12"
    
        config.vm.provider "hyperv" do |hv|
            hv.cpus = "2"
            hv.memory = "2048"
            hv.vm.name = "Kibana-SEIM"
    
        bootstrap_script_path = "C:\Path\to\bootstrap\file.sh"
    
        config.vm.provision "shell", path: bootstrap_script_path, privileged: true
        end
    end

    config.define.box "Logstash" do |logstash|
        config.vm.box = "LogS-SEIM"
        config.vm.box_url = "F:\path\to\vm\hard\disk"
        config.vm.hostname = "LogS-SEIM"
        
        config.vm.network = "domain-test", ip = "172.30.100.13"
        
        config.vm.provider "hyperv" do |hv|
            hv.cpus = "2"
            hv.memory = "2048"
            hv.vm.name = "Logstash-SEIM"
        
        bootstrap_script_path = "C:\Path\to\bootstrap\file.sh"
        
        config.vm.provision "shell", path: bootstrap_script_path, privileged: true
        end
    end

    config.define.box "Wazuh-Manager" do |manager|
        config.vm.box = "Wazuh-SEIM-MAN"
        config.vm.box_url = "F:\path\to\vm\hard\disk"
        config.vm.hostname = "Wazuh-SEIM-MAN"
            
        config.vm.network = "domain-test", ip = "172.30.100.14"
            
        config.vm.provider "hyperv" do |hv|
            hv.cpus = "2"
            hv.memory = "2048"
            hv.vm.name = "Wazuh-SEIM-MAN"
            
        bootstrap_script_path = "C:\Path\to\bootstrap\file.sh"
            
        config.vm.provision "shell", path: bootstrap_script_path, privileged: true
        end
    end
end 
    