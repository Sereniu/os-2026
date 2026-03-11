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

; cursor当前位置
mov bh, 0x00
mov ah, 0x03
int 0x10
mov [row],dh
mov [col],dl

; 移动cursor到1行11列
mov bh, 0x00
mov dh, 0x01
mov dl, 0x0b
mov ah, 0x02
int 0x10

; 显示cursor的行号
mov al, [row]
add al, 0x30
mov bh, 0x00
mov bl, 0x03
mov cx, 1
mov ah, 0x09
int 0x10

; cursor列加一方便显示行列
mov ah, 0x02
inc dl
int 0x10

; 显示cursor的列号
mov al, [col]
add al, 0x30
mov bh, 0x00
mov bl, 0x02
mov cx, 1
mov ah, 0x09
int 0x10

row db 0
col db 0

jmp $ ; 死循环

times 510 - ($ - $$) db 0
db 0x55, 0xaa
