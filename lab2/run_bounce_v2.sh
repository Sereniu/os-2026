#!/bin/bash
nasm -f bin mbr_bounce.asm -o mbr_bounce.bin
qemu-img create bounce_hd.img 10m
dd if=mbr_bounce.bin of=bounce_hd.img bs=512 count=1 seek=0 conv=notrunc
qemu-system-i386 -hda bounce_hd.img -serial null -parallel stdio
