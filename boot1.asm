org 0x7c00
jmp 0x0000:start

start:
	XOR ax, ax
	MOV ds, ax

zerarDisco:
	mov ah,00h			;	interupt to reset disk
	mov dl, 0			;	select disk to reset
	int 13h
	jc zerarDisco 		;	if any error occur, try again

disco:
	mov ah, 02h			;	interrupt to read the disk
	mov al, 2			;	select the amount of sectors to read
	mov ch, 0			;	select the cilinder to read
	mov cl, 2			;	select the sector to read
	mov dh, 0			;	select the head to read
	mov dl, 0			;	select the disk to read
	mov bx, 0x0000
	mov es, bx			;	offset
	mov bx, 0x0500		;	segment
	int 13h
	jc disco			;	if any error occur, try again

jmp 0x0000:0x0500

times 510 -($-$$) db 0	;	ill the empty space with zeros
dw 0xaa55
