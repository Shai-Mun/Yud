IDEAL
MODEL small
STACK 100h
DATASEG
	a db 127
	b db -128
	c db 1
	t db ?
	
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov [t], 0
	mov al, [t]
	add al, [a]
	add al, [b]
	sub al, [c]
	mov [t], al
	
exit:
	mov ax, 4c00h
	int 21h
END start


