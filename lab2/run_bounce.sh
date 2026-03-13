#!/bin/bash

nasm -f bin bounce.asm -o bounce_mbr.bin  # 编译后仍用num_mbr.bin
qemu-img create bounce_hd.img 10m         # 镜像仍用num_hd.img
dd if=bounce_mbr.bin of=bounce_hd.img bs=512 count=1 seek=0 conv=notrunc
qemu-system-i386 -hda bounce_hd.img -serial null -parallel stdio
