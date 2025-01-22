# Índice / Index
- [Descripción en Español](#descripción-en-español)
- [Description in English](#description-in-english)

# Descripción en Español
_Trabajo en progreso._
**Este script debería ejecutarse en una máquina virtual dedicada para prevenir pérdidas de información en caso de que `mkarchiso` sea interrumpido (ver: [Arch Linux Wiki - Archiso - Removal of work directory](https://wiki.archlinux.org/title/Archiso#Removal_of_work_directory))**

https://wiki.archlinux.org/title/Archiso
Una herramienta para builds de imágenes personalizadas de Arch Linux, pensada com una herramienta para servicio y backups de sistemas, y para instalaciones fáciles de Arch.

Depende de los paquetes `fish`, `bash` y `archiso`.

El script de compilación copia un definición de perfil sin cambios y le agrega una lista de paquetes, entradas de configuración de Pacman (un administrador de paquetes) y otros archivos.

Cuenta con características como la configuración de la contraseña de _root_, la configuración de un usuario no-_root_ y el agregado de un repositorio disponible sin Internet (Arch se suele instalar descargando los paquetes en el momento).

## Tareas
- Limpieza


# Description in English
_Work in progress._
**This script should be run inside a dedicated VM to prevent data loss in case `mkarchiso` gets interrupted (see [Arch Linux Wiki - Archiso - Removal of work directory](https://wiki.archlinux.org/title/Archiso#Removal_of_work_directory))**

https://wiki.archlinux.org/title/Archiso
A custom Arch Linux ISO build tool, thought out for system servicing/backups and easier Arch installs.

Depends on `fish`, `bash` and `archiso` packages.

The build script copies a fresh profile definition, then adds package names, Pacman (a package manager) configuration entries and other files.

It features root password configuration, non-root user setup and an offline repo based on the added package list (Arch Linux is installed with and Internet connection most of the time).

## To Do / Issues
- Cleanup
