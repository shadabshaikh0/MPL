%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall 
%endmacro

section .data
	array dd 78.90,44.33,55.33,55.21,66.22
	arraycount dd 5.0
	decm dd 100

	dot db "."
	nline db " ",10
	lenn equ $-nline
	msg1 db "Mean="
	len1 equ $-msg1
	msg2 db "Variance="
	len2 equ $-msg2
	msg3 db "Standard Deviation="
	len3 equ $-msg3

section .bss
	mean resd 2
	var  resd 2
	sd   resd 2
	printbuffer resb 2
	buffer rest 1


section .text
	global _start
	_start:

meancalculate:
	finit
	fldz
	mov rsi,array
	mov rcx,05
	loop1:
		fadd dword[rsi]
		add rsi,4
		loop loop1

		fdiv dword[arraycount]
		fst dword[mean]
		scall 1,1,msg1,len1
		call display
		scall 1,1,nline,lenn

var1:	
	 	fldz
		mov rsi,array
		mov rcx,05
	 loop2:
	 	fld dword[rsi]
	 	fsub dword[mean]
	 	fst st1
	 	fmul st1
	 	fadd dword[var]
	 	fst dword[var]
	 	add rsi,4
	 	loop loop2

    	fld dword[var]		
    	fdiv dword[arraycount]
    	fst dword[var]
		scall 1,1,msg2,len2
		call display
		scall 1,1,nline,lenn

sd1:
		fld dword[var]
		fsqrt
		fst dword[sd]
		scall 1,1,msg3,len3
		call display
		scall 1,1,nline,lenn

exit:
		mov rax,60
		mov rdi,0
		syscall


display:
		fimul dword[decm]
		fbstp [buffer]

		mov rsi,buffer+9
		mov rcx,09H

		loop3:
			mov dl,byte[rsi]
			push rsi
			push rcx
			call HtoA
			pop rcx
			pop rsi

			dec rsi 
			loop loop3

		scall 1,1,dot,1

			mov rsi,buffer
			mov dl,byte[rsi]
			call HtoA
ret

HtoA:
	mov rcx,02H
	mov rdi,printbuffer

	loop4:
		rol dl,4
		mov al,dl
		and al,09H
		cmp al,09H
		jbe loop5
		add al,07H
	loop5:
		add al,30H
		mov byte[rdi],al
		inc rdi
		loop loop4

	scall 1,1,printbuffer,2

ret














