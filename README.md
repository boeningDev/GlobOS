# GlobOS
This repository represents my efforts to create an OS, for the purposes of learning

Run using `make` command in the GlobOS (case-sensitive) directory,</br>then running `qemu-system-i386 -fda Build/globos.img`.

The structure is as follows:
    * NASM for x86
    * FAT12 Filesystem
    * 1^st^ Stage Bootloader prints a message then loads the,/brentirety of the 2^nd^ Stage
    * 2^nd^ Stage Bootloader prints a message at beginning and end</br>of the file