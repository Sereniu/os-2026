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
mov ax, 1                ; 逻辑扇区号第0~15位
mov cx, 0                ; 逻辑扇区号第16~31位
mov bx, 0x7e00           ; bootloader的加载地址
load_bootloader:
    call asm_read_hard_disk  ; 读取硬盘
    inc ax
    cmp ax, 5
    jle load_bootloader
jmp 0x0000:0x7e00        ; 跳转到bootloader

jmp $ ; 死循环

asm_read_hard_disk:                           
; 从硬盘读取一个逻辑扇区

; 参数列表
; ax=逻辑扇区号0~15位
; es:bx=数据缓存区地址

; 返回值
; bx=bx+512

    ; 保存寄存器
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ;lba->chs 计算扇区，磁头，柱面
    mov si, 63	  ; spt
    mov di, 18    ; hpc

    xor dx, dx
    div si	  ; ax = lba/63 dx = lba%63
    mov cl, dl
    inc cl	  ; cl 扇区号

    xor dx, dx
    div di	  ; ax = lba/63/18 dx=lba/63%18
    mov dh, dl
    mov ch, al    ; ch 柱面号低8位
    mov al, ah    ; 高两位
    shl al, 6
    or  cl, al

    ; 调用02h读扇区
    mov ah, 02h
    mov dl, 80h
    mov al, 1
    int 13h

    ; 检查是否成功读取
    jc .read_error

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    add bx, 512
    pop ax
     
    ret

.read_error:
    mov si, err_msg
    mov ah, 0x0e
    mov bx, 0x0007

.loop:
    lodsb

    or al, al
    jz .halt
    
    int 0x10
    jmp .loop

.halt:
    jmp $

err_msg db "Read Error!", 0

times 510 - ($ - $$) db 0
db 0x55, 0xaa
