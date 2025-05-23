#!/bin/fish

set AUR_HELPER_USER $argv[1]
set EXECUTE_DATE $(date +%Y-%m-%d_%H-%M)
set DOWNLOAD_DIRECTORY "/custom-archiso-packages"

if test -d $argv; or contains -- -h $argv[1]
    echo -e "You need to specify an user with which to execute the aur helper, as it should not be executed with priviledges.\n\n"
    exit
end


# Folder setup

echo $EXECUTE_DATE > $DOWNLOAD_DIRECTORY/execute-date.log

mkdir -p $DOWNLOAD_DIRECTORY

mkdir -p $DOWNLOAD_DIRECTORY/{packages,database}

# Directly setting the user and group in the chown command doesn't seem to work. This does, for some reason
set USER_AND_GROUP $AUR_HELPER_USER:$AUR_HELPER_USER

chown -R $USER_AND_GROUP $DOWNLOAD_DIRECTORY

# Is this necessary?
chmod -R 700 $DOWNLOAD_DIRECTORY

# Create a dedicated repo folder, with an empty database
mkdir -p $DOWNLOAD_DIRECTORY/aur-packages
repo-add $DOWNLOAD_DIRECTORY/aur-packages/aur-packages.db.tar.zst

# Echo a pacman configuration for use with aurutils
set PACMAN_CONFIGURATION_FILE "$DOWNLOAD_DIRECTORY/aurutils-pacman.conf"

echo "[options]
HoldPkg     = pacman glibc
Architecture = auto
ParallelDownloads = 5
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional

[core]
Include = /etc/pacman.d/mirrorlist
[extra]
Include = /etc/pacman.d/mirrorlist
[multilib]
Include = /etc/pacman.d/mirrorlist
[aur-packages]
SigLevel = Optional TrustAll
Server = file://$DOWNLOAD_DIRECTORY/aur-packages/" > $PACMAN_CONFIGURATION_FILE

chown $USER_AND_GROUP $PACMAN_CONFIGURATION_FILE


# Descarga de paquetes AUR según un archivo
sudo -u $AUR_HELPER_USER aur sync --pacman-conf $PACMAN_CONFIGURATION_FILE $(cat aur-packages)

# Debería usar un cat entre paquetes main y paquetes aur
pacman -Syw --config $PACMAN_CONFIGURATION_FILE --noconfirm --cachedir $DOWNLOAD_DIRECTORY/packages --dbpath $DOWNLOAD_DIRECTORY/database $(cat main-repository-packages aur-packages)

rm $DOWNLOAD_DIRECTORY/packages/local-package-repository*

echo "Begin compiling package database"

# Fish does not support this kind of wildcard
bash -c "repo-add $DOWNLOAD_DIRECTORY/packages/local-package-repository.db.tar.zst $DOWNLOAD_DIRECTORY/packages/*[^sig]"
