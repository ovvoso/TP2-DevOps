#!/bin/bash
# Ajouter ces lignes au .bashrc pour les alias personnalisés

# Alias de déploiement automatisé
alias deploy="bash /vagrant/scripts/deploy-app-auto.sh"
alias deploy-quick="bash /vagrant/scripts/deploy-app-auto.sh"

# Alias Tomcat rapides
alias tom-start="sudo /opt/tomcat9/bin/startup.sh"
alias tom-stop="sudo /opt/tomcat9/bin/shutdown.sh"
alias tom-logs="sudo tail -f /opt/tomcat9/logs/catalina.out"
alias tom-status="ps aux | grep tomcat"

# Alias Maven rapides
alias mvn-build="mvn clean package -DskipTests"
alias mvn-quick="mvn clean package -DskipTests -q"

# Alias pour aller au projet
alias cdapp="cd /vagrant/API-JEE-2025"
