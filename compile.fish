#!/bin/fish

if not set -q argv[4]; or contains -- -h $argv[1]
    echo -e "Note: This script should be executed in a private fish session, (\"fish --private\"), which avoids storing sensitive information in the history file.\nYou can also remove specific history entries with \"history delete --contains <string>\".\n\nUsage: compile.fish <root password> <non-root username> <non-root password> <non-root shell name>"
    exit
end

set ROOT_PASSWORD (echo $argv[1] | openssl passwd -6 -stdin)
set NORMAL_USER_USERNAME $argv[2]
set NORMAL_USER_PASSWORD (echo $argv[3] | openssl passwd -6 -stdin)
set NORMAL_USER_SHELL $argv[4]

echo "Clearing working directories"
rm -rf workdir archlive 

echo "Copying base archiso profile"
cp -r /usr/share/archiso/configs/releng/ archlive

echo "Applying custom changes"
cp -r airootfs-additions/* archlive/airootfs/

cat package-list-additions >> archlive/packages.x86_64
mkdir -p archlive/airootfs/home/$NORMAL_USER_USERNAME
cp -r {package-list-additions,other-payloads} archlive/airootfs/{root,home/$NORMAL_USER_USERNAME}

cat pacman-configuration-additions >> archlive/pacman.conf
# Disable autologin
rm archlive/airootfs/etc/systemd/system/getty@tty1.service.d/autologin.conf

echo "Writing user data"
echo "root:x:0:0:root:/root:/usr/bin/zsh" >> archlive/airootfs/etc/passwd
echo "root:$ROOT_PASSWORD:14871::::::" >> archlive/airootfs/etc/shadow

echo "$NORMAL_USER_USERNAME:x:1000:1000::/home/$NORMAL_USER_USERNAME:/usr/bin/$NORMAL_USER_SHELL" >> archlive/airootfs/etc/passwd

echo "$NORMAL_USER_USERNAME:$NORMAL_USER_PASSWORD:14871::::::" >> archlive/airootfs/etc/shadow
mkdir archlive/airootfs/etc/sudoers.d
echo "$NORMAL_USER_USERNAME ALL=(ALL:ALL) ALL" > archlive/airootfs/etc/sudoers.d/01_normaluser

echo "Begin compiling auxiliary package database"
rm package-repository/package-repository*
repo-add package-repository/package-repository.db.tar.zst package-repository/*

echo "Creating working and output directories"
mkdir -p workdir out

mkarchiso \
	-v \
	-L CUSTOM-ARCHISO \
	-A CUSTOM-ARCHISO \
	-P digitar120 \
	-w workdir/ -o out/ archlive/
