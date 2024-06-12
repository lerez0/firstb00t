#!/bin/bash
# ce shebang indique au serveur quel lanceur de commande utiliser pour exécuter ce script

# 👉 ce script peut-être obtenu avec la commande : cd && (...)
# pour installer git sur son serveur : (...)

# le contenu de ce script peut aussi être copié-collé et modifié 
# dans un fichier nommé debian-firstboot-init-script.sh (par exemple)

# -------------------------------------------
## 🚀 LANCEMENT
# -------------------------------------------

echo "🚀 LANCEMENT"
echo "Ce script effectue les tâches habituelles lors du premier démarrage"
echo "d'un serveur Linux Debian (version 9, 10, 11, 12) fraîchement installé"
echo "(sur VPS, home-server, machine virtuelle ou tout autre environnement)"
echo "et met en place des services améliorant sa sécurité."
echo " "
echo "Ce script installe exclusivement des logiciels open-source"
echo "reconnus par la communauté Linux Debian depuis leurs dépôts officiels"
echo "et recommande la création de mots de passe forts."
echo " "

# -------------------------------------------
# ⭐️ SUDO USER
# -------------------------------------------

echo "1/12 ⭐️ CRÉATION D'UN UTILISATEUR AVEC DROITS D'ADMINISTRATION sudo..."
echo "La première bonne pratique en matière de sécurité consiste à exécuter ce script"
echo "via un utilisateur aux permissions limitées (membre du groupe sudo)."
echo "L'utilisation de sudo permet de 'journaliser' l'activité du serveur"
echo "en offrant une traçabilité des commandes exécutées."

if grep -q "^sudo:" /etc/group; then          # vérification de l'existence du groupe sudo
    echo "Le groupe sudo existe déjà sur ce système."
else
    groupadd sudo                             # création du groupe sudo si nécessaire
    echo "Le groupe sudo a été créé."
fi

read -p "Entrer le nom du nouvel utilisateur à créer : " sudousername
if id "$sudousername" &>/dev/null; then
    echo "L'utilisateur $sudousername existe déjà."
else
    adduser --gecos "" "$sudousername"        # création de l'utilisateur sudo
    usermod -aG sudo "$sudousername"          # ajout de l'utilisateur au groupe sudo
    echo "L'utilisateur $sudousername a été ajouté avec succès au groupe sudo."
    echo "Définir un mot de passe fort pour l'utilisateur $sudousername."
    passwd "$sudousername"                    # définition d'un mot de passe pour l'utilisateur
fi

echo "Désactivation de la connexion à distance du super-admin 'root'"
if sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config; then
    echo "Désactivation effectuée."
else
    echo "Erreur lors de la désactivation de la connexion à distance du super-admin 'root'."
    exit 1
fi

echo "Réduction de la visibilité du nouveau compte utilisateur et du dossier /home"
echo "aux seuls administrateurs du système ; les rendant invisibles aux autres utilisateurs."
if sed -i 's/DIR_MODE=[0-9]*/DIR_MODE=750/' /etc/adduser.conf && chmod 701 /home; then
    echo "Les permissions du dossier /home ont été modifiées."
else
    echo "Erreur lors de la modification des permissions du dossier /home."
    exit 1
fi

echo "REDÉMARRAGE DU SERVICE SSH..."
if systemctl restart ssh; then
    echo "Service SSH redémarré avec succès."
else
    echo "Erreur lors du redémarrage du service SSH."
    exit 1
fi

echo "LANCEMENT DU SECOND SCRIPT AVEC LE NOUVEL UTILISATEUR sudo..."
su - $sudousername -c "sudo wget -qO- https://raw.githubusercontent.com/lerez0/firstb00t/main/rez0-debian-lancement.sh | bash"
