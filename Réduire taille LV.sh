#!/bin/bash

# Demande le nom du groupe de volumes (VG)
read -p "Entrez le nom du groupe de volumes (VG) : " VG_NAME

# Demande le nom du volume logique (LV)
read -p "Entrez le nom du volume logique (LV) : " LV_NAME

# Demande la nouvelle taille du système de fichiers
read -p "Entrez la nouvelle taille du système de fichiers (ex. 1G) : " NEW_SIZE

# Ajout du commentaire dans /etc/fstab
sed -i "s/\/dev\/$VG_NAME\/$LV_NAME/#\/dev\/$VG_NAME\/$LV_NAME/g" /etc/fstab

# Démontage du système de fichiers
umount /dev/$VG_NAME/$LV_NAME

# Vérification et correction de l'intégrité du système de fichiers
e2fsck -f /dev/$VG_NAME/$LV_NAME

# Réduction du système de fichiers
resize2fs /dev/$VG_NAME/$LV_NAME $NEW_SIZE

# Réduction du volume logique
lvreduce -L -$NEW_SIZE /dev/$VG_NAME/$LV_NAME

# Suppression du commentaire dans /etc/fstab
sed -i "s/#\/dev\/$VG_NAME\/$LV_NAME/\/dev\/$VG_NAME\/$LV_NAME/g" /etc/fstab

# Remontage du système de fichiers
mount -a

# Afficher un message de confirmation
echo "La réduction de taille du volume logique $LV_NAME est terminée."

# Fin du script
