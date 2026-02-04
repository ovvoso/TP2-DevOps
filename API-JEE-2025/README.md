# 📋 API REST Java EE - DevOps TP2

API REST complète avec Vagrant + Tomcat + MySQL. Déploiement automatisé en une commande.

## 📁 Structure

```
scripts/
├── deploy-app.sh          # Installation srv-app (JDK 8/11/17 + Maven + Tomcat 9)
├── deploy-db.sh           # Installation srv-db (MySQL 8 + Base de données)
└── README.md              # Ce fichier
```

## 🚀 Utilisation

Les scripts sont appelés automatiquement par le Vagrantfile lors du provisioning.

### Déployer manuellement (après SSH)

```bash
# Sur srv-app
bash /vagrant/scripts/deploy-app.sh

# Sur srv-db
bash /vagrant/scripts/deploy-db.sh
```

## 📝 Détails des scripts

### deploy-app.sh

**Installe sur srv-app :**
- ✅ JDK 8 (Java 1.8)
- ✅ JDK 11 (Java 11)
- ✅ JDK 17 (Java 17) - **Défaut**
- ✅ Maven 3.x
- ✅ Tomcat 9.0.93

**Caractéristiques :**
- Les 3 versions de Java sont gérées par `update-alternatives`
- Possibilité de changer de version Java facilement
- Tomcat configuré avec utilisateur dédié
- Liens symboliques créés pour démarrage/arrêt facile

### deploy-db.sh

**Installe sur srv-db :**
- ✅ MySQL 8.x
- ✅ Création de la base `devops_db`
- ✅ Création de l'utilisateur `devops_user`
- ✅ Configuration pour connexions externes

**Caractéristiques :**
- MySQL écoute sur 0.0.0.0:3306
- Utilisateur : `devops_user`
- Mot de passe : `12345`
- Permissions complètes sur `devops_db`

## 🔗 Connectivité

### Réseau Vagrant

```
192.168.56.0/24 (Réseau privé)

srv-app: 192.168.56.10 (Tomcat + Apps)
    ↓
srv-db: 192.168.56.11 (MySQL 8)
```

### Configuration de connexion

Le fichier `persistence.xml.template` contient :

```xml
<property name="javax.persistence.jdbc.url" 
    value="jdbc:mysql://192.168.56.11:3306/devops_db?serverTimezone=UTC" />
<property name="javax.persistence.jdbc.user" value="devops_user" />
<property name="javax.persistence.jdbc.password" value="12345" />
```

## 🧪 Tests de connectivité

### Depuis srv-app vers srv-db

```bash
# Test simple
mysql -u devops_user -p12345 -h 192.168.56.11 devops_db -e "SELECT 1;"

# Voir les tables créées par Hibernate
mysql -u devops_user -p12345 -h 192.168.56.11 devops_db -e "SHOW TABLES;"
```

### Depuis la machine physique

```bash
# Port forwarding Vagrant
mysql -u devops_user -p12345 -h 127.0.0.1 -P 3306 devops_db -e "SELECT 1;"
```

## 📌 Variables d'environnement

Vous pouvez personnaliser les scripts en les modifiant avant le premier provisioning.

**À adapter si besoin :**
- Versions de Java
- Version de Tomcat
- Identifiants MySQL
- IP du réseau privé (dans Vagrantfile)

## ⚠️ Notes importantes

1. **Synced Folder** : Le dossier `API-JEE-2025` est synchronisé automatiquement
   - Modifications locales → VM en temps réel
   - Évite les copier-coller manuels

2. **Personne de résolution** : 
   - Vérifiez les IPs si la connectivité échoue
   - `vagrant network` pour voir les IPs assignées
   - `vagrant ssh` pour accéder aux VMs

3. **Redéploiement** :
   ```bash
   # Réinstaller à zéro
   vagrant destroy
   vagrant up
   ```

## 🔧 Troubleshooting

### MySQL ne démarre pas
```bash
vagrant ssh srv-db
sudo systemctl status mysql
sudo systemctl restart mysql
```

### Connexion impossible à MySQL depuis srv-app
```bash
# Vérifier que MySQL écoute bien
mysql -u root -e "SHOW VARIABLES LIKE 'bind_address';"

# Vérifier le pare-feu
sudo ufw status
```

### Java mal configuré
```bash
# Voir les alternatives disponibles
sudo update-alternatives --list java

# Reconfigurer
sudo update-alternatives --config java
```

## 📚 Ressources

- [Tomcat 9 Documentation](https://tomcat.apache.org/tomcat-9.0-doc/)
- [MySQL 8 Documentation](https://dev.mysql.com/doc/mysql-en/8.0/)
- [Java Alternatives](https://linux.die.net/man/8/update-alternatives)

## 📸 Captures d'écran

### API Tests
![Tests Postman](src/main/resources/imag/api_tests.png)

### Architecture
![Architecture VMs](src/main/resources/imag/architecture.png)

---

**Créé pour le TP DevOps - ISI DITI**
