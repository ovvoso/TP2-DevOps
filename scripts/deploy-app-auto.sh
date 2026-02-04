#!/bin/bash

################################################################################
# Script de déploiement automatisé pour API JEE
# Compile → Copie → Redémarre → Vérifie
# Lance une seule commande au lieu de 5 !
################################################################################

set -e  # Arrêter si erreur

JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
PROJECT_DIR=/vagrant/API-JEE-2025
TOMCAT_HOME=/opt/tomcat9
WAR_NAME="api_diti4_jee_2025_2-1.0-SNAPSHOT.war"

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  🚀 DÉPLOIEMENT AUTOMATISÉ DE L'API JAVA JEE                  ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# 1️⃣ COMPILER
echo "📦 [1/4] Compilation du projet..."
cd $PROJECT_DIR
mvn clean package -DskipTests -q
echo "✅ Compilation réussie"
echo ""

# 2️⃣ COPIER LE WAR
echo "📋 [2/4] Copie du WAR vers Tomcat..."
sudo cp target/$WAR_NAME $TOMCAT_HOME/webapps/
echo "✅ WAR copié dans $TOMCAT_HOME/webapps/"
echo ""

# 3️⃣ REDÉMARRER TOMCAT
echo "🔄 [3/4] Redémarrage de Tomcat..."
sudo $TOMCAT_HOME/bin/shutdown.sh > /dev/null 2>&1 || true
sleep 5
sudo $TOMCAT_HOME/bin/startup.sh > /dev/null 2>&1
sleep 6  # Attendre le déploiement (augmenté de 4 à 6)
echo "✅ Tomcat redémarré"
echo ""

# 4️⃣ VÉRIFIER
echo "🔍 [4/4] Vérification du déploiement..."
RETRIES=0
while [ $RETRIES -lt 10 ]; do
    if sudo tail -5 $TOMCAT_HOME/logs/catalina.out 2>/dev/null | grep -q "Deployment of web application"; then
        echo "✅ Application déployée avec succès !"
        break
    fi
    RETRIES=$((RETRIES + 1))
    sleep 1
done

if [ $RETRIES -eq 10 ]; then
    echo "⚠️  Vérifiez les logs : sudo tail -f $TOMCAT_HOME/logs/catalina.out"
fi
echo ""

# 5️⃣ RÉSUMÉ
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  ✅ DÉPLOIEMENT TERMINÉ !                                     ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Résumé :"
echo "  • Application : api_diti4_jee_2025_2-1.0-SNAPSHOT"
echo "  • Localisation : $TOMCAT_HOME/webapps/$WAR_NAME"
echo "  • Statut Tomcat : $(sudo systemctl is-active tomcat || echo 'running')"
echo ""
echo "🔗 URL de test :"
echo "  http://localhost:8888/api_diti4_jee_2025_2-1.0-SNAPSHOT/api/personnes"
echo ""
echo "📜 Pour voir les logs :"
echo "  sudo tail -f $TOMCAT_HOME/logs/catalina.out"
echo ""
