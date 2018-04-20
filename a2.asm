%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	array dq 0x1AAABBBBCCCCDDDD,0x2AAABBBBCCCCDDDD,0x3AAABBBBCCCCDDDD,0x4AAABBBBCCCCDDDD,0x5AAABBBBCCCCDDDD,0,0

	menu db "1.Display Orignal Block.",10
	     db "2.Non-Overlapping Block transfer",10
	     db "3.Overlapping Block Transfer",10
	     db "4.Non-overlapping block transfer using string instruction.",10
	     db "5.Overlapping block transfer using string instruction.",10
	     db "6.Exit",10
	     db "Enter your choice:"
	menulen equ $-menu


	msg1 db "Orignal Block:",10
	len1 equ $-msg1
	msg2 db "Copied Block:",10
	len2 equ $-msg2
	colon db ":"
	colonlen equ $-colon

	newline db "",10
	nlen equ $-newline

section .bss
	choice resb 2
	count resb 2
	result resb 16

section .text
global _start
_start:
	
SHOWMENU:
	scall 1,1,menu,menulen
	scall 0,1,choice,2

	cmp byte[choice],31H
	je original	
	cmp byte[choice],32H
	je non_overlap
	cmp byte[choice],33H
	je overlap
	cmp byte[choice],34H
	je string_non_overlap	
	cmp byte[choice],35H
	je string_overlap	
	cmp byte[choice],36H
	je exit


original:
	scall 1,1,msg1,len1
	mov rsi,array
	mov byte[count],05H
	call Display
	jmp SHOWMENU

non_overlap:
	scall 1,1,msg2,len2
	mov rsi,array
	mov rdi,array+200H
	mov byte[count],05H
	l1:
		mov rax,qword[rsi]
		mov qword[rdi],rax
		add rsi,8
		add rdi,8
		dec byte[count]
		jnz l1

	mov rsi,array+200H
	mov byte[count],05H
	call Display
	jmp SHOWMENU	

overlap:
	scall 1,1,msg2,len2
	mov rsi,array+32
	mov rdi,array+48
	mov byte[count],05H
	l2:
		mov rax,qword[rsi]
		mov qword[rdi],rax
		sub rsi,8
		sub rdi,8
		dec byte[count]
		jnz l2

	mov rsi,array
	mov byte[count],07H
	call Display
	jmp SHOWMENU	


string_non_overlap:
	scall 1,1,msg2,len2
	mov rsi,array
	mov rdi,array+300H
	mov byte[count],05H
	l3:
		movsq
		dec byte[count]
		jnz l3

	mov rsi,array+300H
	mov byte[count],05H
	call Display
	jmp SHOWMENU	

string_overlap:
	 scall 1,1,msg2,len2
	mov rsi,array+32
	mov rdi,array+48
	mov byte[count],05H
	l21:
		movsq
		sub rsi,16
		sub rdi,16
		dec byte[count]
		jnz l21

	mov rsi,array
	mov byte[count],07H
	call Display
	jmp SHOWMENU

exit:
	mov rax,60 
	mov rdi,0
	syscall


Display:
		push rsi
		mov rdx,rsi
		call HtoA
		pop rsi

		push rsi
		scall 1,1,colon,colonlen
		pop rsi

		push rsi
		mov rdx,qword[rsi]
		call HtoA
		pop rsi

		push rsi
		scall 1,1,newline,nlen
		pop rsi

		add rsi,8

		dec byte[count]
		jnz Display

ret

HtoA:	
		mov rcx,0x10
		mov rdi,result
		loop1:
			rol rdx,4
			mov al,dl
			and al,0FH
			cmp al,09H
			jbe loop2
			add al,07H
		loop2:
			add al,30H
			mov byte[rdi],al
			inc rdi
			loop loop1
		scall 1,1,result,0x10
ret

