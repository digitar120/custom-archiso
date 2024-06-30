# xfce-archiso
A custom Arch Linux ISO, thought out as a tool for system backups and easier Arch installs.

Includes all graphics drivers, a stock XFCE desktop and a Firefox install.

**Note: */etc/shadow* is included in .gitignore, and autologin is disabled. You must manually set a root password before compiling.**

# To do
- Move and symlink desktop shortcuts to mark them as trusted by XFCE.
- Fix XDM not reading hostname

- ~Desktop shortcuts for Clonezilla, GParted, Firefox and XFCE Terminal~
- ~Choose appropriate metadata for the *mkarchiso* command~
- ~Default session for root in XDM (.xsession)~