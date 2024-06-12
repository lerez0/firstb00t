# firstb00t
### script de premier démarrage et de sécurisation d'un serveur-web Linux Debian
Si c'est votre première expérience d'administration de serveur-web (local, virtuel ou dédié)
sachez que ce script est prévu pour être lancé lors du premier démarrage d'un serveur-web debian
(9, 10, 11 ou 12). Ce script :
- met à jour le système
- automatise l'installation de plusieurs outils de sécurité
- crée un clé d'accès sécurisée sur votre ordinateur pour accéder à votre serveur-web
- met en place un système de conteneurisation pour les futures web-apps de votre réz0

> L'étape suivante sera le lancement d'un script d'installation d'un bouquet de web-apps open-source et la mise en place d'un portail réz0 : (lien)

Il faut bien sûr disposer d'un serveur et de son adresse IP ou IPv4.

> Si vous ne disposez-pas encore d'un serveur-web, allez jeter un oeil aux offres de contabo.com 🚀

## GUIDE d'utilisation
L'exécution du script est très simple.

### CONNEXION au serveur
1. sur l'ordinateur que vous utilisez
- (mac, linux) ouvrir une fenêtre de terminal de commande (CLI) 
- (win) lancer un logiciel de type PuTTY

2. dans cette fenêtre, taper et exécuter la commande de connexion à un serveur :

> appel-du-protocol nom-de-l'utilisateur@adresse-du-serveur

> ssh username@adresse_ip_du_serveur

Exemple :
```bash
ssh my-username@222.333.444.555
```
### LANCEMENT du script
Une fois connecté au serveur

3. copier-coller cette commande de lancement dans la fenêtre du terminal et taper Enter :
```bash
apt-get update && apt-get install wget -y && wget -qO- https://raw.githubusercontent.com/lerez0/firstb00t/main/rez0-debian-premier-demarrage.sh | bash
```
### EXÉCUTION du script
4. suivre les instructions à l'écran qui se termineront par un redémarrage du serveur
auquel il faudra se reconnecter.

---
Ce script installe exclusivement des logiciels open-source
reconnus par la communauté Linux Debian à partir de leurs dépôts officiels
et exige la création de mots de passe forts.
