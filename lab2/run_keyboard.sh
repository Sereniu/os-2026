#!/bin/bash

nasm -f bin keyboard_mbr.asm -o keyboard_mbr.bin
qemu-img create keyboard_hd.img 10m
dd if=keyboard_mbr.bin of=keyboard_hd.img bs=512 count=1 seek=0 conv=notrunc
qemu-system-i386 -hda keyboard_hd.img -serial null -parallel stdio
