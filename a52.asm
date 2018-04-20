%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	global msg3,len3,msg4,len4,msg5,len5,msg6,len6,newl,l
	msg1 db "File Successfully open",10
	len1 equ $-msg1
	msg2 db "Error while open",10
	len2 equ $-msg2
	msg3 db "Space count="
	len3 equ $-msg3
	msg4 db "Line count="
	len4 equ $-msg4
	msg5 db "Enter character"
	len5 equ $-msg5
	msg6 db "Character occurerence="
	len6 equ $-msg6
	msg7 db "1.Count number of spaces",10
	     db "2.Count number of lines",10
	     db "3.Count number of occurence of character",10
	     db "4.Exit",10
	     db "Enter your choice"
	len7 equ $-msg7

	fname db "File.txt",0
	newl db "",10
	l equ $-newl

section .bss
	global buff,length1,length2,length3,spacecount,linecount,ccount,chr
	buff resb 100
	fd resb 8
	length1 resb 8
	length2 resb 8
	length3 resb 8
	spacecount resb 2
	linecount resb 2
	ccount resb 2
	chr resb 2
	choice resb 2

section .text
global _start
_start:
	
	extern space,lines,characters

	scall 2,fname,02,777
	mov qword[fd],rax

	scall 0,[fd],buff,100
	mov qword[length1],rax
	mov qword[length2],rax
	mov qword[length3],rax

menu: 
	scall 1,1,newl,l
	scall 1,1,msg7,len7

	scall 0,1,choice,2
		 
    cmp byte[choice],31H
	je p1
	cmp byte[choice],32H
	je p2
	cmp byte[choice],33H
	je p3
	cmp byte[choice],34H
	je closef

	p1:
		call space
		jmp menu
	p2:
		call lines
		jmp menu
	p3:
		call characters
		jmp menu


;====close file===

closef:
	mov rax,3
	mov rdi,[fd]
	syscall


;=====exit===
exit:
	mov rax,60
	mov rdi,0
	syscall



