%macro scall 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

%macro printf_ 1
	mov rdi,formatp
	sub rsp,8
	movsd xmm0,[%1]
	mov rax,1
	call printf
	add rsp,8
%endmacro

%macro printfimag 2
	sub rsp,8
	movsd xmm0,[%1]
	movsd xmm1,[%2]
	mov rax,1
	call printf
	add rsp,8
%endmacro

%macro scanf_ 1
	mov rdi,formats
	mov rsi,%1
	mov rax,1
	call scanf
%endmacro


section .data
	formats db "%lf",0
	formatp db "%lf",10,0
	formatp1 db "%lf +i %lf",10,0
	formatp2 db "%lf -i %lf",10,0
	msg1 db "Enter values of a,b,c:",10
	len1 equ $-msg1
	msg2 db "Real roots are:",10
	len2 equ $-msg2
	msg3 db " +i"
	len3 equ $-msg3
	msg4 db " -i"
	len4 equ $-msg4
	msg5 db "Equation has only one root!",10
	len5 equ $-msg5
	msg6 db "Root is:"
	len6 equ $-msg6
	msg7 db "Imaginary roots are:",10
	len7 equ $-msg7
	four dq 4
	two dq 2

section .bss
	
	a resq 1
	b resq 1
	c resq 1
	b2 resq 1
	fac resq 1
	ta resq 1
	dlt resq 1
	dsqrt resq 1
	r1 resq 1
	r2 resq 1
	ir1 resq 1
	ir2 resq 1
	r resq 1

section .text
global main
main:
	
	extern printf
	extern scanf

	scall 1,1,msg1,len1
	scanf_ a
	scanf_ b
	scanf_ c

	fild qword[four]
	fmul qword[a]
	fmul qword[c]
	fst qword[fac]

	fild qword[2]
	fmul qword[a]
	fst qword[ta]

	fld qword[b]
	fmul qword[b]
	fst qword[b2]

	fld qword[b2]
	fsub qword[fac]
	fst qword[dlt]

	btr qword[dlt],63
	jc imag
	cmp qword[dlt],00
	jc equal 

;============real roots==========

	fld qword[dlt]
	fsqrt
	fst qword[dsqrt]

	fldz
	fsub qword[b]
	fadd qword[dsqrt]
	fdiv qword[ta]
	fstp qword[r1]

	fldz
	fsub qword[b]
	fsub qword[dsqrt]
	fdiv qword[ta]
	fstp qword[r2]

	scall 1,1,msg2,len2
	printf_ r1
	printf_ r2
	jmp exit

;==========imag roots===========

imag:
	fld qword[dlt]
	fsqrt
	fst qword[dsqrt]

	fldz
	fsub qword[b]
	fdiv qword[ta]
	fstp qword[ir1]

	fldz
	fld qword[dsqrt]
	fdiv qword[ta]
	fstp qword[ir2]

	scall 1,1,msg7,len7

	mov rdi,formatp1
	printfimag ir1,ir2

	mov rdi,formatp2
	printfimag ir1,ir2
	jmp exit

;=========equal roots===========

equal:
	fldz
	fsub qword[b]
	fdiv qword[ta]
	fstp qword[r]
	scall 1,1,msg5,len5
	scall 1,1,msg6,len6
	printf_ r

exit:
	mov rax,60
	mov rdi,0
	syscall