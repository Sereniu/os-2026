#!/bin/bash

nasm -f bin mbr_cursor.asm -o mbr_cursor.bin
qemu-img create cursor_hd.img 10m
dd if=mbr_cursor.bin of=cursor_hd.img bs=512 count=1 seek=0 conv=notrunc
qemu-system-i386 -hda cursor_hd.img -serial null -parallel stdio
