echo "Clearing working directory..."
rm -r workdir/*

echo "Before compiling, set a couple things:"

# Remove old user and password information
rm archlive/airootfs/etc/{passwd,shadow}

echo "root:x:0:0:root:/root:/usr/bin/zsh" >> archlive/airootfs/etc/passwd

echo "Root password"
echo "root:$(openssl passwd -6):14871::::::" >> archlive/airootfs/etc/shadow

read -p "Normal user username: " NORMAL_USER_USERNAME
read -p "Normal user shell binary, stored in /usr/bin: " NORMAL_USER_SHELL

echo "$NORMAL_USER_USERNAME:x:1000:1000::/home/$NORMAL_USER_USERNAME:/usr/bin/$NORMAL_USER_SHELL" >> archlive/airootfs/etc/passwd

echo "Normal user password:"
echo "$NORMAL_USER_USERNAME:$(openssl passwd -6):14871::::::" >> archlive/airootfs/etc/shadow
echo "$NORMAL_USER_USERNAME ALL=(ALL:ALL) ALL" > archlive/airootfs/etc/sudoers.d/01_normaluser

echo "Begin compiling auxiliary package database"
rm package-repository/package-repository*
repo-add package-repository/package-repository.db.tar.zst package-repository/*


mkarchiso \
	-v \
	-L CUSTOM-ARCHISO \
	-A CUSTOM-ARCHISO \
	-P digitar120 \
	-w workdir/ -o out/ archlive/
