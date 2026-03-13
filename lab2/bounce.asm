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
jmp loop1

; 实现变色
next_color:
	inc byte [counter]
	mov al, [counter]
	
	; 去掉0x80之后的，防止闪烁
	cmp al, 0x80
	jl check_diff
	mov byte [counter],0x01
	jmp next_color
	
check_diff:
	; 去掉前景色和背景色一致的，便于观察
	mov bl, al
	and bl, 0x0f
	mov cl, al
	shr cl, 4
	cmp bl, cl
	je next_color

	; 颜色有效保存
	mov [color], al
	ret


loop1:
	call next_color

	; 偶数轨迹
	mov ah, 02h
	mov bh, 0
	mov dh, [x]
	mov dl, [y]
	int 10h

	mov ah, 09h
	mov al, [even]
	mov bh, 0
	mov bl, [color]
	mov cx, 1
	int 10h

	add byte [even], 2
	cmp byte [even], '9'+1
	jl ok1
	mov byte [even], '0'

ok1:
	mov al, [vx]
	add byte [x], al
	mov al, [vy]
	add byte [y], al
	
	; 碰到上下边界，dx取反
	cmp byte [x], 0
	je reverse_dx
	cmp byte [x], 24
	je reverse_dx
	
	; 碰到左右边界，dy取反
	cmp byte [y], 0
	je reverse_dy
	cmp byte [y], 79
	je reverse_dy
	
	jmp loop2

reverse_dx:
	mov al, 0
	sub al, [vx]
	mov byte [vx], al
	jmp loop2

reverse_dy:
	mov al, 0
	sub al, [vy]
	mov [vy], al

loop2:	
	; 奇数轨迹
	mov ah, 02h
	mov bh, 0
	mov dh, [m]
	mov dl, [n]
	int 10h

	mov ah, 09h
        mov al, [odd]
        mov bh, 0
        mov bl, [color]
        mov cx, 1
        int 10h

        add byte [odd], 2
        cmp byte [odd], '9'+1
        jl ok2
        mov byte [odd], '0'

ok2:
	mov al,[vm]
        add byte [m], al
	mov al, [vn]
        add byte [n], al

        ; 碰到上下边界，dm取反
        cmp byte [m], 0
        je reverse_dm
        cmp byte [m], 24
        je reverse_dm

        ; 碰到左右边界，dn取反
        cmp byte [n], 0
        je reverse_dn
        cmp byte [n], 79
        je reverse_dn
	
	jmp loop1

reverse_dm:
        mov al, 0
        sub al, [vm]
        mov [vm], al
        jmp loop1

reverse_dn:
        mov al, 0
        sub al, [vn]
        mov [vn], al


	jmp loop1

jmp $

counter db 0
color db 0

; 偶数轨迹
x db 2
y db 0
vx db 1
vy db 1
even db '0'

; 奇数轨迹
m db 6
n db 79
vm db 1
vn db 0xff
odd db '1'

times 510 - ($ - $$) db 0
db 0x55, 0xaa
