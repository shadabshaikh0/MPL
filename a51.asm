%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

section .data
	extern msg3,len3,msg4,len4,msg5,len5,msg6,len6,newl,l

section .bss
	extern buff,length1,length2,length3,spacecount,linecount,ccount,chr

section .text
global main
main:
	global space,lines,characters

	space:
		mov byte[spacecount],00H
		mov rcx,[length1]
		mov rsi,buff
		ll1:
			cmp byte[rsi],20H
			jne ll2
			inc byte[spacecount]
		ll2:
			inc rsi
			loop ll1

		add byte[spacecount],30H
		scall 1,1,msg3,len3
		scall 1,1,spacecount,2
	ret
	lines:
		mov byte[linecount],00H
		mov rcx,[length2]
		mov rsi,buff
		ll3:	
			cmp byte[rsi],10
			jne ll4
			inc byte[linecount]
		ll4:
			inc rsi
			loop ll3

		add byte[linecount],30H
		scall 1,1,msg4,len4
		scall 1,1,linecount,2
	ret

	characters:
		scall 1,1,msg5,len5
		scall 0,1,chr,2

		mov byte[ccount],0H
		mov rsi,buff	
		mov rcx,[length3]
		mov bl,byte[chr]
		loop41:
			cmp byte[rsi],bl
			jne loop51
			inc byte[ccount]
		loop51:
			inc rsi
			loop loop41
		add byte[ccount],30H
		scall 1,1,msg6,len6
		scall 1,1,ccount,2
	ret

	mov rax,60
	mov rdi,0
	syscall
