# Índice / Index
- [Descripción en Español](#descripción-en-español)
- [Description in English](#description-in-english)

# Descripción en Español

Un script de compilación para imágenes de Arch Linux personalizadas, pensado para hacer más facil backups o servicios, y para instalaciones de Arch más fáciles. Usa el script [`mkarchiso`](https://wiki.archlinux.org/title/Archiso) como base.

`mkarchiso` toma un conjunto de archivos para compilar una nueva imágen. Se pueden incluir configuracinoes, archivos y programas de arranque personalizados.

## Principales características

- Automatiza la limpieza después de cada compilación.
- Cada ejecución altera una copia hecha en el momento del perfil `releng`.
- Copia los contenidos de la carpeta `airootfs-additions` al root de la imágen. Estos archivos se vuelven disponibles en la LiveCD.
- Compila un repositorio local para instalar los paquetes. Este repositorio también se copia al entorno LiveCD para habilitar la instalación de Arch Linux sin conexión a Internet. También se incluyen las configuraciones para los repositorios principales.
- Define una contraseña para `root` y un usuario sin privilegios, junto con su contraseña y shell por defecto. El script también indica sobre el uso de `fish --private` para evitar guardar información sensible en `history`.
- Depende de los paquetes `fish`, `bash` y `archiso`.


# Description in English

A custom Arch Linux ISO build script, thought out for system servicing/backups and easier Arch installs. It uses the [`mkarchiso`](https://wiki.archlinux.org/title/Archiso) script.

`mkarchiso` will take an assortment of files and configurations to build a new ISO. Custom configurations, files and startup programs can be set up.

## Main Characteristics

- Automates the cleanup process after each build.
- Alters a fresh profile on each execution.
- Copies the contents of `airootfs-additions` to the image root. These files become available in the LiveCD environment.
- Compiles a custom local repository to install the packages. This repository is also copied to the ISO to enable offline installs. Main repos are also included, for convenience.
- Defines a root password and an unpriviledged user with their password and default shell. The script also warns to use a private `fish` instance so no sensible information is stored.
- Depends on `fish`, `bash` and `archiso` packages.
