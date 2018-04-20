%macro scall 4
	 mov rax,%1
	 mov rdi,%2
	 mov rsi,%3
	 mov rdx,%4
	 syscall
%endmacro

section .data
	newl db " ",10
	l equ $-newl
	msg1 db "Protected mode is on",10
	len1 equ $-msg1
	msg2 db "Protected mode is off",10
	len2 equ $-msg2
	msg3 db "Contents of GDTR = "
	len3 equ $-msg3
	msg4 db "Contents of LDTR = "
	len4 equ $-msg4
	msg5 db "Contents of IDTR = "
	len5 equ $-msg5
	msg6 db "Contents of TR = "
	len6 equ $-msg6
	msg7 db "Contents of MSW = "
	len7 equ $-msg7
section .bss
	gmem resb 6
	imem resb 6
	lmem resb 2
	tr   resb 2
	mmem resb 4
	res  resb 4

section .text
	global _start
	_start:
	 
      smsw eax
      bt eax,0
      jc m1
      scall 1,1,msg2,len2
   m1:
      scall 1,1,msg1,len1

      scall 1,1,msg3,len3
      sgdt [gmem]
      mov dx,word[gmem+4]
      call HtoA
      scall 1,1,res,4
      mov dx,word[gmem+2]
      call HtoA
      scall 1,1,res,4
      mov dx,word[gmem]
      call HtoA
      scall 1,1,res,4

      scall 1,1,msg5,len5
      sidt [imem]
      mov dx,word[imem+4]
      call HtoA
      scall 1,1,res,4
      mov dx,word[imem+2]
      call HtoA
      scall 1,1,res,4
      mov dx,word[imem]
      call HtoA
      scall 1,1,res,4


      scall 1,1,msg4,len4
      sldt [lmem]
      mov dx,word[lmem]
      call HtoA
      scall 1,1,res,4

      scall 1,1,msg6,len6
      str [tr]
      mov dx,word[tr]
      call HtoA
      scall 1,1,res,4


      scall 1,1,msg7,len7
      smsw [mmem]
      mov dx,word[mmem+2]
      call HtoA
      scall 1,1,res,4
      mov dx,word[mmem]
      call HtoA
      scall 1,1,res,4

    mov rax,60
    mov rdi,0
    syscall


   HtoA:
   		mov rcx,04
   		mov rdi,res
   		loop1:
   			rol dx,4
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
   	ret


