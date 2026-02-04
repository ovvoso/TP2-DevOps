#!/bin/bash
################################################################################
# Script de déploiement pour srv-app
# Installation: JDK 8, 11, 17 + Maven + Tomcat 9
# Auteur: DevOps Team
# Date: 2025
################################################################################

set -e

echo "========================================="
echo "🚀 Installation srv-app (JDK, Maven, Tomcat)"
echo "========================================="
echo ""

# Mise à jour des paquets
echo "📦 Mise à jour des paquets système..."
apt-get update
apt-get install -y build-essential wget curl

# ==============================================================================
# INSTALLATION JAVA 8, 11, 17
# ==============================================================================

echo ""
echo "📦 Installation de Java 8..."
apt-get install -y openjdk-8-jdk
update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8-openjdk-amd64/bin/java 1
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac 1

echo "📦 Installation de Java 11..."
apt-get install -y openjdk-11-jdk
update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-openjdk-amd64/bin/java 2
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-11-openjdk-amd64/bin/javac 2

echo "📦 Installation de Java 17..."
apt-get install -y openjdk-17-jdk
update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-17-openjdk-amd64/bin/java 3
update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac 3

# Définir Java 17 comme version par défaut
echo "⚙️  Définition de Java 17 par défaut..."
update-alternatives --set java /usr/lib/jvm/java-17-openjdk-amd64/bin/java
update-alternatives --set javac /usr/lib/jvm/java-17-openjdk-amd64/bin/javac

# ==============================================================================
# INSTALLATION MAVEN
# ==============================================================================

echo ""
echo "📦 Installation de Maven..."
apt-get install -y maven

# ==============================================================================
# INSTALLATION TOMCAT 9
# ==============================================================================

echo ""
echo "📦 Installation de Tomcat 9..."

# Créer l'utilisateur et groupe Tomcat
groupadd -r tomcat || true
useradd -r -g tomcat tomcat || true

# Télécharger et installer Tomcat
cd /opt
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.93/bin/apache-tomcat-9.0.93.tar.gz -q
tar -xzf apache-tomcat-9.0.93.tar.gz
mv apache-tomcat-9.0.93 tomcat9
rm apache-tomcat-9.0.93.tar.gz

# Définir les permissions
chown -R tomcat:tomcat /opt/tomcat9

# Créer des liens symboliques pour démarrage/arrêt facile
ln -sf /opt/tomcat9/bin/startup.sh /usr/local/bin/tomcat-start
ln -sf /opt/tomcat9/bin/shutdown.sh /usr/local/bin/tomcat-stop

# ==============================================================================
# VÉRIFICATION DES INSTALLATIONS
# ==============================================================================

echo ""
echo "========================================="
echo "✅ VÉRIFICATION DES INSTALLATIONS"
echo "========================================="
echo ""

echo "📋 Versions Java installées:"
ls /usr/lib/jvm/ | grep openjdk || echo "⚠️  Aucun OpenJDK trouvé"

echo ""
echo "☕ Version Java active:"
java -version

echo ""
echo "📦 Version Maven:"
mvn -version

echo ""
echo "🗂️  Tomcat 9 installé dans: /opt/tomcat9"
echo "   Taille: $(du -sh /opt/tomcat9 | cut -f1)"

echo ""
echo "========================================="
echo "✅ Installation terminée avec succès!"
echo "========================================="
echo ""

echo "📋 COMMANDES UTILES :"
echo ""
echo "  Changer de version Java:"
echo "    sudo update-alternatives --config java"
echo "    sudo update-alternatives --config javac"
echo ""
echo "  Démarrer Tomcat:"
echo "    sudo /opt/tomcat9/bin/startup.sh"
echo "    (ou: sudo tomcat-start)"
echo ""
echo "  Arrêter Tomcat:"
echo "    sudo /opt/tomcat9/bin/shutdown.sh"
echo "    (ou: sudo tomcat-stop)"
echo ""
echo "  Compiler le projet Java:"
echo "    cd /vagrant/API-JEE-2025"
echo "    mvn clean package"
echo ""
echo "  Déployer sur Tomcat:"
echo "    cp target/api_diti4_jee_2025_2.war /opt/tomcat9/webapps/"
echo ""
echo "  Voir les logs de Tomcat:"
echo "    tail -f /opt/tomcat9/logs/catalina.out"
echo ""
echo "========================================="

# ==============================================================================
# CONFIGURATION DES ALIAS BASH
# ==============================================================================

echo ""
echo "⚙️  Configuration des alias bash..."

cat >> /home/vagrant/.bashrc << 'EOF'

# ===== ALIAS DE DÉPLOIEMENT AUTOMATISÉ (Ajoutés par deploy-app.sh) =====
alias deploy="bash /vagrant/scripts/deploy-app-auto.sh"
alias deploy-quick="bash /vagrant/scripts/deploy-app-auto.sh"

# Alias Tomcat rapides
alias tom-start="sudo /opt/tomcat9/bin/startup.sh"
alias tom-stop="sudo /opt/tomcat9/bin/shutdown.sh"
alias tom-restart="sudo /opt/tomcat9/bin/shutdown.sh && sleep 3 && sudo /opt/tomcat9/bin/startup.sh"
alias tom-logs="sudo tail -f /opt/tomcat9/logs/catalina.out"
alias tom-status="ps aux | grep tomcat"

# Alias Maven rapides
alias mvn-build="mvn clean package -DskipTests"
alias mvn-quick="mvn clean package -DskipTests -q"

# Alias pour aller au projet
alias cdapp="cd /vagrant/API-JEE-2025"

# ===== FIN ALIAS DE DÉPLOIEMENT =====
EOF

echo "✅ Alias bash configurés"
echo ""
echo "Alias disponibles :"
echo "  • deploy          → Compile + Déploie + Redémarre Tomcat (EN UNE SEULE COMMANDE !)"
echo "  • tom-start       → Démarrer Tomcat"
echo "  • tom-stop        → Arrêter Tomcat"
echo "  • tom-restart     → Redémarrer Tomcat"
echo "  • tom-logs        → Voir les logs en temps réel"
echo "  • tom-status      → Vérifier l'état de Tomcat"
echo "  • mvn-build       → Compiler le projet"
echo "  • cdapp           → Aller au dossier du projet"
