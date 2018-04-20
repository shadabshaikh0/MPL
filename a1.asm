%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	array dq 0x9AAABBBBCCCCDDDD,0x1AAABBBBCCCCDDDD,0xAAAABBBBCCCCDDDD,0xAAAABBBBCCCCDDDD
	arraycnt equ 4

	msg1 db "Positive count ="
	len1 equ $-msg1
	msg2 db "Negative count ="
	len2 equ $-msg2
	cpos db 0,10
	cneg db 0,10

section .bss
	disbuffer resb 2

section .text
global _start
_start:
	
	mov rsi,array
	mov rcx,arraycnt

	loop1:
		mov rax,qword[rsi]
		bt rax,63
		jc negcount
			inc byte[cpos]
			jmp label2
	negcount:
			inc	byte[cneg]
		label2:
		add rsi,8
		loop loop1

	scall 1,1,msg1,len1
	mov dl,byte[cpos]
	call HtoA

	xor rdx,rdx

	scall 1,1,msg2,len2
	mov dl,byte[cneg]
	call HtoA

	exit:
		mov rax,60
		mov rdi,0
		syscall

HtoA:
	mov rcx,02H
	mov rdi,disbuffer

	loop11:
		rol dl,4
		mov al,dl
		and al,0FH
		cmp al,09H
		jbe loop12
		add al,07H
	loop12:
		add al,30H
		mov byte[rdi],al
		inc rdi
		loop loop11
	
	scall 1,1,disbuffer,2
ret




