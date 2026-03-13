org 0x7c00
[bits 16]
xor ax, ax ; eax = 0
; 初始化段寄存器, 段地址全部设为0
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax

; 初始化栈指针
mov sp, 0x7c00

; 清屏
mov ah, 06h
mov al, 0
mov bh, 0x07
mov ch, 0
mov cl, 0
mov dh, 24
mov dl, 79
int 10h


jmp loop1


loop1:
	; 取随机打印颜色
	rdtsc
	mov ecx, 256
	idiv ecx;
	mov [color], dl

	; 取打印字符
	inc byte [counter]

	; 偶数:counter*2%10+'0'
	mov al, [counter]
	mov ah, 0
	mov cl, 10
	div cl	; al = counter%10

	shl al, 1
	mov cl, 10
	div cl
	add ah, '0'
	mov [even], ah

	; 奇数：(counter*2+1)%10+'0'
	mov al, [counter]
	mov ah, 0
	mov cl, 10
	div cl

	shl al, 1
	inc al
	mov cl, 10
	div cl
	add ah, '0'
	mov [odd], ah

	; 设置光标
	mov ah, 02h
	mov bh, 0
	mov dh, [x1]
	mov dl, [y1]
	int 10h

	; 显示even
	mov ah, 09h
	mov al, [even]
	mov bh, 0
	mov bl, [color]
	mov cx, 1
	int 10h

	; 移动光标
	mov al, [dx1]
	add byte [x1], al
	mov al, [dy1]
	add byte [y1], al
	
	; 反弹检测
	cmp byte [x1], 0
	je .rev_x1
	cmp byte [x1], 24
	je .rev_x1
	jmp .check_y1
.rev_x1:
	neg byte [dx1]
.check_y1:
	cmp byte [y1], 0
	je .rev_y1
	cmp byte [y1], 79
	je .rev_y1
	jmp .loop2
.rev_y1:
	neg byte [dy1]
.loop2:
	mov ah, 02h
	mov bh, 0
	mov dh, [x2]
	mov dl, [y2]
	int 10h 
	
	mov ah, 09h
	mov al, [odd]
	mov bh, 0
	mov bl, [color]
	mov cx, 1
	int 10h

	mov al, [dx2]
	add byte [x2], al
	mov al, [dy2]
	add byte [y2], al
	
	cmp byte [x2], 0
	je .rev_x2
	cmp byte [x2], 24
	je .rev_x2
	jmp .check_y2
.rev_x2:
	neg byte [dx2]
.check_y2:
	cmp byte [y2], 0
	je .rev_y2
	cmp byte [y2],79
	je .rev_y2
	jmp .do_delay
.rev_y2:
	neg byte [dy2]

.do_delay:	
	mov dx, 0x0100
.outer:
	mov cx, 0xffff
.inner: 
	dec cx
	jnz .inner
	dec dx
	jnz .outer

	jmp loop1






color db 0
counter db 0
even db 0 
odd db 0

x1 db 2
y1 db 0
dx1 db 1
dy1 db 1

x2 db 22
y2 db 79
dx2 db 0xff
dy2 db 0xff

times 510 - ($ - $$) db 0
db 0x55, 0xaa
