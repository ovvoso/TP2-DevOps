#!/bin/bash
################################################################################
# Script de déploiement pour srv-db
# Installation: MySQL 8 + Création de la base de données
# Auteur: DevOps Team
# Date: 2025
################################################################################

set -e

echo "========================================="
echo "🚀 Installation srv-db (MySQL 8)"
echo "========================================="
echo ""

# Mise à jour des paquets
echo "📦 Mise à jour des paquets système..."
apt-get update

# ==============================================================================
# INSTALLATION MYSQL 8
# ==============================================================================

echo ""
echo "📦 Installation de MySQL 8..."
apt-get install -y mysql-server

# ==============================================================================
# CONFIGURATION MYSQL
# ==============================================================================

echo ""
echo "⚙️  Configuration de MySQL pour accepter les connexions externes..."

# Modifier la configuration pour écouter sur toutes les interfaces (0.0.0.0)
sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Démarrer le service MySQL
echo "🔄 Démarrage du service MySQL..."
systemctl start mysql
systemctl enable mysql

# ==============================================================================
# CRÉATION DE LA BASE DE DONNÉES ET DE L'UTILISATEUR
# ==============================================================================

echo ""
echo "🗄️  Création de la base de données et de l'utilisateur..."

mysql -u root <<EOF
CREATE USER IF NOT EXISTS 'devops_user'@'%' IDENTIFIED BY '12345';
CREATE DATABASE IF NOT EXISTS devops_db;
GRANT ALL PRIVILEGES ON devops_db.* TO 'devops_user'@'%';
FLUSH PRIVILEGES;
EOF

# Redémarrer MySQL pour appliquer les changements
echo "🔄 Redémarrage de MySQL..."
systemctl restart mysql

# ==============================================================================
# VÉRIFICATION DE L'INSTALLATION
# ==============================================================================

echo ""
echo "========================================="
echo "✅ VÉRIFICATION DE L'INSTALLATION"
echo "========================================="
echo ""

echo "📋 Statut du service MySQL:"
systemctl status mysql --no-pager | head -3

echo ""
echo "🗄️  Bases de données créées:"
mysql -u root -e "SHOW DATABASES;"

echo ""
echo "👤 Utilisateur créé:"
mysql -u root -e "SELECT User, Host FROM mysql.user WHERE User='devops_user';"

echo ""
echo "========================================="
echo "✅ Installation MySQL terminée!"
echo "========================================="
echo ""

echo "📋 INFORMATIONS DE CONNEXION :"
echo ""
echo "  Host/IP:     192.168.56.11"
echo "  Port:        3306"
echo "  Database:    devops_db"
echo "  Username:    devops_user"
echo "  Password:    12345"
echo ""

echo "📋 COMMANDES UTILES :"
echo ""
echo "  Tester la connexion depuis la VM app:"
echo "    mysql -u devops_user -p12345 -h 192.168.56.11 devops_db -e 'SELECT 1;'"
echo ""
echo "  Voir les tables de la base (après déploiement):"
echo "    mysql -u devops_user -p12345 devops_db -e 'SHOW TABLES;'"
echo ""
echo "  Voir l'état de MySQL:"
echo "    systemctl status mysql"
echo ""
echo "  Redémarrer MySQL:"
echo "    systemctl restart mysql"
echo ""
echo "========================================="
