%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	newl db "",10
	len equ $-newl
	msg db "1.Succesive Addition",10
	    db "2.Booth's Multiplication",10
	    db "3.Exit",10
	    db "Enter your choice"
	ln equ $-msg
	msg1 db "Enter multiplier : ",10
	len1 equ $-msg1
	msg2 db "Enter multiplicand : ",10
	len2 equ $-msg2
	msg3 db "Result = "
	len3 equ $-msg3

section .bss
	choice resb 2
	multiplier resb 4
	multiplicand resb 4
	result resb 4

section .text
global _start
_start:
MENU:
	scall 1,1,newl,len
	scall 1,1,msg,ln
	scall 0,1,choice,2

	cmp byte[choice],31H
	je Succ_Add
	cmp byte[choice],32H
	je Booth
	cmp byte[choice],33H
	je Exit

Succ_Add:	
		scall 1,1,msg1,len1
		scall 0,1,multiplier,4
		mov rsi,multiplier
		call AtoH
		xor rax,rax
		mov al,bl
		push rax

		scall 1,1,msg2,len2
		scall 0,1,multiplicand,4
		mov rsi,multiplicand
		call AtoH
		pop rax
	
		xor rcx,rcx
		mov cl,bl
		mov rbx,rax
		dec rcx
		l1:
			add rax,rbx
			loop l1
		mov rdx,rax
		call HtoA

		scall 1,1,msg3,len3
		scall 1,1,result,4
		jmp MENU

Booth:
		scall 1,1,msg1,len1
		scall 0,1,multiplier,4
		mov rsi,multiplier
		call AtoH
		xor rdx,rdx
		mov dl,bl
		push rdx

		scall 1,1,msg2,len2
		scall 0,1,multiplicand,4
		mov rsi,multiplicand
		call AtoH
		pop rdx
		xor rax,rax
		l2:
			shr bl,01H
			jnc l3
			add rax,rdx
		l3:
			shl rdx,01H
			jnz l2

		mov rdx,rax
		call HtoA

		scall 1,1,msg3,len3
		scall 1,1,result,4
		jmp MENU
Exit:
	mov rax,60
	mov rdi,0
	syscall
AtoH:
		mov rcx,02H
		loop1:
			rol bl,04H
			mov al,byte[rsi]
			cmp al,39H
			jbe loop2
			sub al,07H
		loop2:
			sub al,30H
			mov bl,al
			inc rsi
			loop loop1
ret
HtoA:
		mov rcx,04H
		mov rdi,result
		loop3:
			rol dx,4
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

