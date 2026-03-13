; If you meet compile error, try 'sudo apt install gcc-multilib g++-multilib' first

%include "head.include"
; you code here

your_if:
	mov eax, [a1]

	cmp eax, 12
	jl less12

	cmp eax,24
	jl less24

	shl eax, 4
	mov [if_flag], eax
	jmp your_if_end

less12:
	mov edx, 0
	mov ebx, 2
	idiv ebx
	add eax, 1
	mov [if_flag], eax
	jmp your_if_end

less24:
	mov ebx, 24
	sub ebx, eax
	imul eax, ebx
	mov [if_flag], eax

your_if_end:


your_while:
; put your implementation here
	mov ebx, [a2]

loop1:
	cmp ebx, 12
	jl your_while_end

	call my_random

	mov ecx, ebx
	sub ecx, 12
	mov edx, [while_flag]
	mov [edx+ecx], al

	dec ebx
	mov [a2], ebx
	jmp loop1

your_while_end:	
	

%include "end.include"

your_function:
; put your implementation here
	mov ecx, 0 ; ecx = i

loop2:
	mov edx, [your_string]
	mov al, byte [edx+ecx]
	cmp al, 0
	je your_function_end
	pushad
	push eax
	call print_a_char
	add esp, 4
	popad	
	inc ecx
	jmp loop2

your_function_end: 
	ret
