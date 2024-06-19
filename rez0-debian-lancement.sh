#!/bin/bash

# La connexion au serveur a été ouverte avec le super-admin 'root'
# mais la sécurité recommande de faire installer les services de sécurité
# par un utilisateur du groupe 'sudo' aux permissions avancées.

# Ce second script a donc été lancé par l'utilisateur 'sudo' créé précédemment.

# -------------------------------------------
# 🎨 PERSONNALISATION
# -------------------------------------------

echo " "
read -p "2 / 17 🎨 DONNER UN NOM AU SERVEUR : " newhostname
if [[ -z "$newhostname" ]]; then
    echo "Le nom du serveur hôte ne peut pas être vide - veuillez réessayer : "
    exit 1
elif [[ ! "$newhostname" =~ ^[a-zA-Z0-9-]+$ ]]; then
    echo "Le nom du serveur hôte ne peut contenir que des lettres, des chiffres et des tirets."
    echo "Il ne doit pas contenir d'espaces ou de caractères spéciaux."
    exit 1
else
    sudo hostnamectl set-hostname "$newhostname"            # changer le nom du serveur
    echo "La modification du nom du serveur hôte prendra effet"
    echo "après le redémarrage du serveur."
fi

# -------------------------------------------
## 🌐 TIME ZONE
# -------------------------------------------

echo " "
echo "3 / 17 🌐 CHOISIR UN FUSEAU HORAIRE POUR LE SERVEUR"
echo "parmi les options disponibles en francophonie ou quelques capitales : "
echo "1) Europe/Paris     2) Europe/Guernsey   3) Indian/Reunion"
echo "4) Indian/Mayotte   5) Indian/Kerguelen  6) Pacific/Tahiti"
echo "7) Pacific/Noumea   8) Pacific/Wallis    9) Africa/Abidjan"
echo "10) Africa/Douala   11) Africa/Kinshasa  12) Africa/Brazzaville"
echo "13) Africa/Libreville 14) Africa/Porto-Novo 15) Africa/Niamey"
echo "16) Africa/Ouagadougou 17) Africa/Lome    18) Africa/Algiers"
echo "19) Africa/Casablanca   20) Africa/Tunis  21) Asia/Phnom_Penh"
echo "22) Asia/Vientiane  23) Asia/Ho_Chi_Minh 24) Asia/Beirut"
echo "25) Indian/Mauritius   26) Indian/Mahe   27) Europe/London"
echo "28) America/New_York   29) Asia/Tokyo"
read -p "Saisir le numéro correspondant : " TZ_CHOICE
case $TZ_CHOICE in
    1) TZ="Europe/Paris" ;;
    2) TZ="Europe/Guernsey" ;;
    3) TZ="Indian/Reunion" ;;
    4) TZ="Indian/Mayotte" ;;
    5) TZ="Indian/Kerguelen" ;;
    6) TZ="Pacific/Tahiti" ;;
    7) TZ="Pacific/Noumea" ;;
    8) TZ="Pacific/Wallis" ;;
    9) TZ="Africa/Abidjan" ;;
    10) TZ="Africa/Douala" ;;
    11) TZ="Africa/Kinshasa" ;;
    12) TZ="Africa/Brazzaville" ;;
    13) TZ="Africa/Libreville" ;;
    14) TZ="Africa/Porto-Novo" ;;
    15) TZ="Africa/Niamey" ;;
    16) TZ="Africa/Ouagadougou" ;;
    17) TZ="Africa/Lome" ;;
    18) TZ="Africa/Algiers" ;;
    19) TZ="Africa/Casablanca" ;;
    20) TZ="Africa/Tunis" ;;
    21) TZ="Asia/Phnom_Penh" ;;
    22) TZ="Asia/Vientiane" ;;
    23) TZ="Asia/Ho_Chi_Minh" ;;
    24) TZ="Asia/Beirut" ;;
    25) TZ="Indian/Mauritius" ;;
    26) TZ="Indian/Mahe" ;;
    27) TZ="Europe/London" ;;
    28) TZ="America/New_York" ;;
    29) TZ="Asia/Tokyo" ;;
    *) TZ="Europe/Paris"; echo "Choix invalide. Le fuseau horaire par défaut (Europe/Paris) sera utilisé et pourra être changé ultérieurement." ;;
esac

sudo ln -sf /usr/share/zoneinfo/$TZ /etc/localtime          # création d'un lien symbolique vers le fuseau horaire choisi
echo "TZ=$TZ" | sudo tee /etc/environment > /dev/null       # définition du fuseau horaire dans /etc/environment
sudo dpkg-reconfigure -f noninteractive tzdata              # reconfiguration du paquet time zone data

echo "Le serveur se trouve maintenant dans la zone horaire :"
timedatectl | grep "Time zone"
sudo hwclock -w                                             # synchronisation de l'horloge matérielle avec l'heure système
echo "🕑 Heure actuelle du serveur : "
timedatectl status

# -------------------------------------------
## ♻️ MISE À JOUR
# -------------------------------------------

echo " "
echo "4 / 17 ♻️ MISE À JOUR des listes de logiciels..."
if sudo apt-get update; then
    echo "Mise à jour des listes de logiciels réussie."
else
    echo "Erreur lors de la mise à jour des listes de logiciels (vérifiez la connexion aux serveurs de mise à jour)."
    exit 1
fi

echo "MISE À JOUR des logiciels..."
if sudo apt-get upgrade -y; then
    echo "Mise à jour des logiciels réussie."
else
    echo "Erreur lors de la mise à jour des logiciels."
    exit 1
fi

echo "MISE À JOUR du système d'exploitation..."
if sudo apt-get full-upgrade -y; then
    echo "Mise à jour du système d'exploitation réussie."
else
    echo "Erreur lors de la mise à jour du système d'exploitation."
    exit 1
fi

echo "NETTOYAGE des fichiers de mise à jour..."
if sudo apt-get autoremove -y; then
    echo "Nettoyage des fichiers de mise à jour réussi."
else
    echo "Erreur lors du nettoyage des fichiers de mise à jour."
    exit 1
fi

echo "AUTOMATISER les mises à jour de sécurité ?"
if sudo apt-get install unattended-upgrades; then
    echo "Installation de l'automatisation des mises à jour de sécurité réussie."
else
    echo "Erreur lors de l'installation de l'automatisation des mises à jour de sécurité."
    exit 1
fi

echo "CONFIGURATION de l'automatisation des mises à jour de sécurité..."
if sdo dpkg-reconfigure --priority=low unattended-upgrades; then
    echo "Configuration de l'automatisation des mises à jour de sécurité réussie."
else
    echo "Erreur lors de la configuration de l'automatisation des mises à jour de sécurité."
    exit 1
fi

# -------------------------------------------
## 📦 INSTALLATION DE PAQUETS ESSENTIELS
# -------------------------------------------

echo " "
echo "5 / 17 📦 INSTALLATION DE PAQUETS ESSENTIELS"
echo "openssh-server git wget curl nano top htop atop ranger firewall-linux-rules firewall-tools sysstat"
if apt-get install openssh-server git wget curl nano top htop ranger firewall-linux-rules firewall-tools sysstat -y; then
    echo "Installation des paquets réussie."
else
    echo "Erreur lors de l'installation des paquets."
    exit 1
fi

echo "Activation du service SSH..."
if systemctl enable ssh; then
    echo "Activation du service SSH réussie."
else
    echo "Erreur lors de l'activation du service SSH."
    exit 1
fi
