%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	fname db 'Num.txt', 0
	openmsg db "file open ok!!",10
	openlen equ $-openmsg
	errmsg db "Error while opening",10
	errlen equ $-errmsg
	msg1 db "1.Ascending",10
	     db "2.Descending",10
	     db "Enter your choice:",10
	len1 equ $-msg1

section .bss
	length resb 8
	cnt1   resb 8
	cnt2   resb 8
	fd     resb 8
	buff   resb 200
	choice resb 2

section .text
global _start
_start:
	scall 2,fname,02,777
	mov qword[fd],rax

	scall 1,1,msg1,len1
	scall 0,1,choice,2

	scall 0,[fd],buff,200
	mov qword[length],rax
	mov qword[cnt1],rax
	mov qword[cnt2],rax

BUBBLESORT1:
	mov al,byte[cnt2]
	mov byte[cnt1],al
	dec byte[cnt1]

	mov rsi,buff
	mov rdi,buff+1

	BUBBLESORT2:
		mov bl,byte[rsi]
		mov cl,byte[rdi]
		cmp byte[choice],31H
		je a		
		cmp byte[choice],32H
		je b

		a:
			cmp bl,cl
			ja SWAP
			jmp skip
		b:
			cmp bl,cl
			jb SWAP
		skip:
			inc rsi
			inc rdi
			dec byte[cnt1]
			jnz BUBBLESORT2
	dec byte[length]
 jnz BUBBLESORT1
 jmp loop1

 SWAP:
	mov byte[rsi],cl
	mov byte[rdi],bl 			
	inc rsi
	inc rdi
	dec byte[cnt1]
	jnz BUBBLESORT2
	dec byte[length]
 jnz BUBBLESORT1

	loop1:
		scall 1,1,buff,qword[cnt2]

	scall 1,[fd],buff,qword[cnt2]	



	close:	mov rax,3
		mov rdi,[fd]
		syscall
	EXIT:
		mov rax,60
		mov rdi,0
		syscall	
