%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	msg1 db "Factorial is="
	len1 equ $-msg1

section .bss
	no resb 8
	result resb 16

section .text
global _start
_start:
	pop rbx
	pop rbx
	pop rbx
	mov dx,word[rbx]
	mov word[no],dx

	mov rsi,no
	call AtoH
	xor rax,rax
	mov al,bl

	mov [rsi],rbx
	cmp qword[rsi],00
	je l1
	call fact
	mov rdx,rax
	jmp l2
l1:
	mov rdx,01H
l2:
	call HtoA
	scall 1,1,msg1,len1
	scall 1,1,result,0x10
	jmp exit

exit:
	mov rax,60
	mov rdi,0
	syscall
fact:
	mov [rsi],rbx
	cmp qword[rsi],01H
	je return 
	dec rbx
	mul rbx
	call fact
return:
	ret

AtoH:
	mov rcx,02H
	xor rbx,rbx
	loop1:
		rol bl,4
		mov al,byte[rsi]
		cmp al,39H
		jbe loop2
		sub al,07H
	loop2:
		sub al,30H
		add bl,al
		inc rsi
		loop loop1
ret

HtoA:
	mov rdi,result
	mov rcx,0x10
	loop3:
		rol rdx,4
		mov al,dl
		and al,0FH
		cmp al,09H
		jbe loop4
		add al,07H
	loop4:
		add al,30H
		mov byte[rdi],al
		inc rdi
		loop loop3
ret

