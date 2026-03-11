org 0x7c00
[bits 16]
xor ax, ax ; eax = 0
; 初始化段寄存器, 段地址全部设为0
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax

; 初始化栈指针
mov sp, 0x7c00
mov ax, 0xb800
mov gs, ax

mov ah, 0x03
mov bh, 0x00
int 0x10
mov [row], dh
mov [col], dl

mov bl, 0x03 ; 青色
mov cx, 1

mov ah, 0x09
mov al, '2'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '4'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '3'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '2'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '5'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '1'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '6'
int 0x10
mov ah,0x02
inc dl
int 0x10

mov ah, 0x09
mov al, '6'
int 0x10
mov ah,0x02
inc dl
int 0x10

row db 0
col db 1

jmp $ ; 死循环

times 510 - ($ - $$) db 0
db 0x55, 0xaa
