%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	msg1 db "File succesfully opened!!!",10
	len1 equ $-msg1
	msg2 db "Error opening file !!!",10
	len2 equ $-msg2	
	msg3 db "Copied!!!",10
	len3 equ $-msg3
	msg4 db "Deleted!!!",10
	len4 equ $-msg4

section .bss
	file1 resb 10
	file2 resb 10
	file3 resb 10
	file4 resb 10
	choice resb 10
	fd1 resb 8
	fd2 resb 8
	fd4 resb 8
	length1 resb 8
	length2 resb 8
	length4 resb 8
	buff1 resb 100
	buff2 resb 100
	buff4 resb 100

section .text
global _start
_start:
	
	pop rbx
	pop rbx
	pop rbx
	mov qword[choice],rbx
	mov rsi,[choice]
	cmp byte[rsi],43H
	je label_copy
	cmp byte[rsi],44H
	je label_delete
	jmp label_type

label_copy:
		pop rbx
		mov rsi,file1
		loop1:
			mov al,byte[rbx]
			mov byte[rsi],al
			inc rsi
			inc rbx
			cmp byte[rbx],00
			jne loop1

		scall 2,file1,02,0777
		mov qword[fd1],rax

		scall 1,1,msg1,len1

		scall 0,[fd1],buff1,100
		mov qword[length1],rax

		scall 1,1,buff1,length1


		pop rbx
		mov rsi,file2
		loop2:
			mov al,byte[rbx]
			mov byte[rsi],al
			inc rsi
			inc rbx
			cmp byte[rbx],00
			jne loop2

		scall 2,file2,02,0777
		mov qword[fd2],rax

		scall 1,[fd2],buff1,[length1]

		mov rax,3
		mov rdi,[fd2]
		syscall

		scall 2,file2,02,0777
		mov qword[fd2],rax

		scall 0,[fd2],buff2,100
		mov qword[length2],rax

		scall 1,1,buff2,qword[length2]

		mov rax,3
		mov rdi,[fd2]
		syscall

label2_delete:
	pop rbx
	mov rsi,file3
loop3:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rbx
	inc rsi
	cmp byte[rbx],00
	jne loop3

	mov rax,87
	mov rdi,file3
	syscall
	jmp exit
	
label3_type:
	pop rbx
	mov rsi,file4
loop4:
	mov al,byte[rbx]
	mov byte[rsi],al
	inc rbx
	inc rsi
	cmp byte[rbx],00
	jne loop4

	mov rax,2
	mov rdi,file4
	mov rsi,02
	mov rdx,0777
	syscall

	mov qword[fd4],rax


	mov rax,0
	mov rdi,[fd4]
	mov rsi,buff4
	mov rdx,100
	syscall

	mov qword[length4],rax

	
	mov rax,1
	mov rdi,1
	mov rsi,buff4
	mov rdx,[length4]
	syscall

	mov rax,3
	mov rdi,[fd4]
	syscall

closef1:
	mov rax,3
	mov rdi,[fd1]
	syscall

;..........................close file 2.............................

closef2:
	mov rax,3
	mov rdi,[fd2]
	syscall

;...........................exit....................................

exit:
	mov rax,60
	mov rdi,0
	syscall
	
	
	









