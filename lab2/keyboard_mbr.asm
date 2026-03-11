org 0x7c00
[bits 16]

char_ascii db 0
caps_flag db 0

xor ax, ax ; eax = 0
; 初始化段寄存器, 段地址全部设为0
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax

; 初始化栈指针
mov sp, 0x7c00

mov ah, 02h
mov bh, 00h
mov dh, 08h
mov dl, 08h
int 10h

loop:
	; 保存按键（非阻塞）
	mov ah, 01h
	int 16h
	jz loop

	; 如果有消费按键
	mov ah, 00h
	int 16h

	; 判断是否为capslock
	cmp ah, 0x3A
	je capslock_change

	; 判断esc
	cmp ah, 01h
	je exit

	; 判断enter
	cmp ah, 1ch
	je enter

	; 检测F1-F12
	cmp al, 0
	je check_f	

	; 其他字符
	mov [char_ascii], al
	cmp byte [char_ascii], 0x61 ; <a
	jb display

	cmp byte [char_ascii], 0x7A ; >z
	ja display
	
	; capslock状态
	cmp byte [caps_flag], 0x01
	je to_upper 

	; shift是否长按
	call check_shift
	cmp bl, 0 ; bl=0则没有长按shift
	je display

to_upper:
	sub byte  [char_ascii], 0x20 ; 小写转大写	

display:
	mov ah, 09h
	mov al, [char_ascii]
	mov bh, 00h
	mov bl, 0x03
	mov cx, 01h
	int 10h

	; 移动cursor
	mov ah,02h
	inc dl
	int 10h

	jmp loop

check_f:
	mov al, ah
	add al, 0x26
	
	mov ah, 09h
	mov bh, 00h
	mov bl, 0x04
	mov cx, 1
	int 10h

	mov ah, 02h
	inc dl
	mov bh, 00h
	int 10h 
	
	jmp loop

capslock_change:
	xor byte [caps_flag], 0x01
	jmp loop

enter: 
	mov ah, 02h
	inc dh
	mov dl, 00h
	int 10h
	jmp loop

exit:
	jmp $

check_shift:
	mov ah, 02h
	int 16h
	and al, 03h
	cmp al, 00h
	je shift_not_pressed
	mov bl, 1
	ret

shift_not_pressed:
	mov bl, 0
	ret

times 510 - ($ - $$) db 0
db 0x55, 0xaa
