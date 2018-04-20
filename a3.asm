%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	newline db "",10
	newlinelen equ $-newline

	title db "1. Hex to BCD",10
		  db "2. BCD to Hex",10
		  db "3.Exit",10
	titlelen equ $-title

	msg1 db "Enter hexadecimal no ",10
	len1 equ $-msg1
	msg2 db "Enter BCD no ",10
	len2 equ $-msg2

section .bss
	choice resb 2
	count resb 2

	bcdnum resb 5
	hexnum resb 4

	bcdnum2 resb 6
	hexnum2 resb 4

section .text
global	_start
_start:
	
SHOWMENU:
	scall 1,1,title,titlelen
	scall 0,1,choice,2

	cmp byte[choice],31H
	je HextoBcd
	cmp byte[choice],32H
	je BcdtoHex
	cmp byte[choice],33H
	je Exit

HextoBcd:
	scall 1,1,msg1,len1
	scall 0,1,hexnum,4
	call AtoH
	xor rax,rax
	mov ax,dx
	xor rdx,rdx
	mov byte[count],00
	mov rbx,0x0A
	l1:
		div rbx
		push dx
		xor rdx,rdx
		inc byte[count]
		cmp ax,00
		jne l1

	l2:
		pop dx
		add dl,30H
		mov byte[bcdnum],dl
		scall 1,1,bcdnum,5
		dec byte[count]
		jnz l2
		scall 1,1,newline,newlinelen

		jmp SHOWMENU

BcdtoHex:
		scall 1,1,msg2,len2
		scall 0,1,bcdnum2,6
		xor rax,rax
		mov rbx,0x0A
		mov byte[count],05H
		mov rsi,bcdnum2
		l3:
			mul rbx
			sub byte[rsi],30H
			movsx cx,byte[rsi]
			add ax,cx
			inc rsi
			dec byte[count]
			jnz l3
		
		call HtoA
		jmp SHOWMENU
Exit:
	mov rax,60
	mov rdi,0
	syscall

AtoH:
	mov rsi,hexnum
	mov rcx,4
	xor rdx,rdx	
	loop1:
		rol dx,4
		mov al,byte[rsi]
		cmp al,39H
		jbe loop2
		sub al,07H
	loop2:
		sub al,30H
		add dx,ax
		inc rsi
		loop loop1
ret

HtoA:
		mov rcx,4
		mov rdi,hexnum2
		loop3:
			rol ax,4
			mov bl,al
			and bl,0FH
			cmp bl,09H
			jbe loop4
			add bl,07H
		loop4:
			add bl,30H
			mov byte[rdi],bl
			inc rdi
			loop loop3
		scall 1,1,hexnum2,4
ret

scall 1,1,msg2,len2
	mov rsi,array
	mov rdi,array+500H
	mov byte[count],05H
	l4:
		mov rax,qword[rsi]
		mov qword[rdi],rax
		add rsi,8
		add rdi,8
		dec byte[count]
		jnz l4

	mov rsi,array+500H
	mov rdi,array+0x10
	mov byte[count],05H
	l5:
		mov rax,qword[rsi]
		mov qword[rdi],rax
		add rsi,8
		add rdi,8
		dec byte[count]
		jnz l5

	mov rsi,array
	mov byte[count],07H
	call Display
	jmp SHOWMENU	
