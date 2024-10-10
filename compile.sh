rm -r out/ workdir/
mkdir out workdir

echo "Before compiling, set a password for the root user:"
echo "root:$(openssl passwd -6):14871::::::" > archlive/airootfs/etc/passwd

echo "Begin compiling auxiliary package database"
rm package-repository/package-repository*
repo-add package-repository/package-repository.db.tar.zst package-repository/*


mkarchiso \
	-v \
	-L CUSTOM-ARCHISO \
	-A CUSTOM-ARCHISO \
	-P digitar120 \
	-w workdir/ -o out/ archlive/
