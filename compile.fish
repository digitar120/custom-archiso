#!/bin/fish

## Alternative to bash's -e option, which automatically terminates the script if any section fails.
function try
  if ! $argv
    echo "ERROR ($argv)"
    exit 1
  end
end



# Main script, meant to be executed after download.fish, which downloads all packages.

if not set -q argv[4]; or contains -- -h $argv[1]
    echo -e "Notes:\n\n- This script should be executed in a private fish session, (\"fish --private\"), which avoids storing sensitive information in the history file.\nYou can also remove specific history entries with \"history delete --contains <string>\".\n\n- If the build fails, use findmnt(8) to check if there are mount binds (see https://wiki.archlinux.org/title/Archiso#Removal_of_work_directory).\n\nUsage: compile.fish <root password> <non-root username> <non-root password> <non-root shell name>"
    exit
end


# Variable setup
set ROOT_PASSWORD (echo $argv[1] | openssl passwd -6 -stdin)
set NORMAL_USER_USERNAME $argv[2]
set NORMAL_USER_PASSWORD (echo $argv[3] | openssl passwd -6 -stdin)
set NORMAL_USER_SHELL $argv[4]
set PACKAGE_WORKING_DIRECTORY "/custom-archiso-packages"



# Context setup
echo "Clearing working directories"
rm -rf workdir archlive 

echo "Copying base archiso profile"
try cp -r /usr/share/archiso/configs/releng/ archlive
## Set image filename details
sed -i 's/^iso_name=.*/iso_name="Ulysses"/' archlive/profiledef.sh
sed -i 's/^iso_label=.*/iso_label="ULYSSES_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"/' archlive/profiledef.sh
sed -i 's|^iso_publisher=.*|iso_publisher="Gabriel Pérez <https://github.com/digitar120>"|' archlive/profiledef.sh
sed -i 's/^iso_application=.*/iso_application="Ulysses Custom Arch Linux Live Media"/' archlive/profiledef.sh

echo "Applying custom changes"
set ROOT_DIR archlive/airootfs
cp -r airootfs-additions/* $ROOT_DIR

mkdir -p $ROOT_DIR/local-package-repository


## Test if the database directory exists
if not test -d /custom-archiso-packages
    echo "Package directory does not exist. Run download.fish first."    
    exit
end

try cp -r $PACKAGE_WORKING_DIRECTORY/packages/* $ROOT_DIR/local-package-repository



# Pacman configuration
## Config file to be saved in the bootable image. Local repo, plus remote repos deactivated.
echo "[options]
HoldPkg     = pacman glibc
Architecture = auto
ParallelDownloads = 5
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional

# Disable the local repo before enabling the remote ones

#[core]
#Include = /etc/pacman.d/mirrorlist
#[extra]
#Include = /etc/pacmna.d/mirrorlist
#[multilib]
#Include = /etc/pacman.d/mirrorlist
[local-package-repository]
SigLevel = Optional TrustAll
Server = file:///local-package-repository/" > $ROOT_DIR/etc/pacman.conf


## Pacman configuration to be used by this program, and mkrachiso
echo "[options]
HoldPkg     = pacman glibc
Architecture = auto
ParallelDownloads = 5
SigLevel    = Required DatabaseOptional
LocalFileSigLevel = Optional

[local-package-repository]
SigLevel = Optional TrustAll
Server = file://$PACKAGE_WORKING_DIRECTORY/packages" > archlive/pacman.conf

cat main-repository-packages aur-packages >> archlive/packages.x86_64

printf "\n\nNote: Remote repositories core and extra are disabled. You can enable them back up by editing '/etc/pacman.conf'.\n\n" >> $ROOT_DIR/etc/motd



# ISO home directories setup
## Create home directories, and copy files intended for those.
mkdir -p $ROOT_DIR/{root/,home/$NORMAL_USER_USERNAME/}
cat main-repository-packages aur-packages > user-directory-payloads/package-list-additions

for i in $ROOT_DIR/{root,home/$NORMAL_USER_USERNAME}/
    cp -r user-directory-payloads/* $i/
end


# User configuration
## Disable autologin
rm $ROOT_DIR/etc/systemd/system/getty@tty1.service.d/autologin.conf

echo "Writing user data"
echo "root:x:0:0:root:/root:/usr/bin/zsh" >> $ROOT_DIR/etc/passwd
echo "root:$ROOT_PASSWORD:14871::::::" >> $ROOT_DIR/etc/shadow

echo "$NORMAL_USER_USERNAME:x:1000:1000::/home/$NORMAL_USER_USERNAME:/usr/bin/$NORMAL_USER_SHELL" >> $ROOT_DIR/etc/passwd

echo "$NORMAL_USER_USERNAME:$NORMAL_USER_PASSWORD:14871::::::" >> $ROOT_DIR/etc/shadow
mkdir $ROOT_DIR/etc/sudoers.d
echo "$NORMAL_USER_USERNAME ALL=(ALL:ALL) ALL" > $ROOT_DIR/etc/sudoers.d/01_normaluser

echo "Creating working and output directories"
mkdir -p workdir out



# Execution
mkarchiso \
	-v \
	-L CUSTOM-ARCHISO \
	-A CUSTOM-ARCHISO \
	-P digitar120 \
	-w workdir/ -o out/ archlive/

