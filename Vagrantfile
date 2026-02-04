################################################################################
# DevOps - TP2: Vagrant Configuration
# Création de 2 VMs: srv-app et srv-db avec déploiement automatisé
################################################################################

Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 600  # Augmenter le timeout à 10 minutes
  # ==============================================================================
  # VM 1: SRV-APP (Application Server)
  # Rôle: Héberger Tomcat 9 et l'API Java JEE
  # ==============================================================================
  
  config.vm.define "srv-app" do |srvapp|
    srvapp.vm.box = "ubuntu/jammy64"
    srvapp.vm.box_check_update = false
    
    # ==================== CONFIGURATION RÉSEAU ====================
    # Port forwarding: Accès Tomcat depuis la machine physique
    # 🔧 Port 8888 (changé depuis 8080 pour éviter les conflits)
    srvapp.vm.network "forwarded_port", guest: 8080, host: 8888
    # Réseau privé: Communication avec srv-db
    srvapp.vm.network "private_network", ip: "192.168.56.10"
    
    # ==================== SYNCED FOLDER ====================
    # 🔄 Synchronisation automatique du projet Java
    # Modifications locales (machine physique) → VM en temps réel
    # Cela évite de recopier les fichiers manuellement
    srvapp.vm.synced_folder "./API-JEE-2025", "/vagrant/API-JEE-2025", type: "virtualbox"
    srvapp.vm.synced_folder "./scripts", "/vagrant/scripts", type: "virtualbox"
    
    # ==================== PROVISIONING ====================
    # Appel du script de déploiement externe
    # ✅ Séparation des préoccupations: logique de déploiement hors du Vagrantfile
    # ✅ Facilite la maintenance et les tests indépendants
    
    srvapp.vm.provision "shell", path: "scripts/deploy-app.sh"
    
    # ==================== VIRTUALBOX CONFIGURATION ====================
    srvapp.vm.provider "virtualbox" do |vb|
      vb.name = "srv-app"
      vb.gui = false
      vb.memory = "2048"  # 2 GB RAM
      vb.cpus = "2"       # 2 CPU cores
    end
  end

  # ==============================================================================
  # VM 2: SRV-DB (Database Server)
  # Rôle: Héberger MySQL 8 et la base de données devops_db
  # ==============================================================================

  
  config.vm.define "srv-db" do |srvdb|
    srvdb.vm.box = "ubuntu/jammy64"
    srvdb.vm.box_check_update = false
    
    # ==================== CONFIGURATION RÉSEAU ====================
    # Port forwarding: Accès MySQL depuis la machine physique
    srvdb.vm.network "forwarded_port", guest: 3306, host: 1234
    # Réseau privé: Communication avec srv-app
    srvdb.vm.network "private_network", ip: "192.168.56.11"

    # ==================== SYNCED FOLDER ====================
    # Synchronisation du dossier scripts pour flexibilité
    srvdb.vm.synced_folder "./scripts", "/vagrant/scripts", type: "virtualbox"
    
    # ==================== PROVISIONING ====================
    # Appel du script de déploiement externe
    # ✅ Séparation des préoccupations: logique de déploiement hors du Vagrantfile
    # ✅ Facilite la maintenance et les tests indépendants
    
    srvdb.vm.provision "shell", path: "scripts/deploy-db.sh"

    # ==================== VIRTUALBOX CONFIGURATION ====================
    srvdb.vm.provider "virtualbox" do |vb|
      vb.name = "srv-db"
      vb.gui = false
      vb.memory = "2048"  # 2 GB RAM
      vb.cpus = "2"       # 2 CPU cores
    end
  end 
end

