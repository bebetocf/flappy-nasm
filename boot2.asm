org 0x0500
jmp 0x0000:start

load1: db "Trying to code in NASM...",0
load2: db "Using C++ to help...",0
load3: db "Giving the fuck to the project and starting to study to the exams...",0
ready: db " Error!",13,10,0
pronto: db " Ready!",13,10,0
prontof: db "Done!! :D",13,10,0
go: db 13,10,"Finally! I don't know what I did it, but it worked :)",13,10,0
error_msg: db " Something gone bad :/",13,10,0

;	Method to put a small delay
dl_letra:
	mov ah, 86h
	mov cx, 1
	mov dx, 2
	int 15h
	ret

;	Method to put a big delay
delay:
	mov ah, 86h
	mov cx, 20
	xor dx, dx
	mov dx, 40
	int 15h
	ret

;	Method to print a string
print:
	;	Compare if it is the end of the string
	cmp byte[si], 0
	je fim_imp

	;	Put the char in 'al' register and use the 10h interrupt to print the char
	mov ah, 0xe
	mov bh,0
	mov bl, 0
	mov al, [si]
	int 10h

	;	Call a smal delay
	call dl_letra
	inc si
	jmp print
	fim_imp:
		ret

error:
	MOV si, error_msg
	call print
	JMP $

start:

	;	Cleaning registers
	xor ax, ax
	mov ds, ax
	mov es, ax

	;	Clean the window, and set the mode to text
	mov ah, 0
	mov al, 3
	int 10h

	;	Reset cursor
	mov ah, 2
	mov dx, 0
	int 10h

	;	Print the messages on the window
	mov si, load1
	call print
	call delay
	mov si, ready
	call print

	mov si, load2
	call print
	call delay
	mov si, ready
	call print

	mov si, load3
	call print
	call delay

	mov si, go
	call print
	call delay

;	Prepare to jump to kernel
kernel:
	mov ax, 0x7e0
	mov es, ax
	xor bx, bx
	mov ah, 2
	mov al, 50
	mov ch, 0
	mov cl, 4
	mov dh, 0
	mov dl, 0
	int 13h

	jc error

	mov ah, 3
	mov bh, 0
	int 10h
	xor dl, dl
	inc dh
	mov ah, 2
	mov bh,0
	int 10h

	mov si, prontof
	call print
	call delay

	JMP 0x07e0:0x0		;	Jump to start of kernel
JMP $
