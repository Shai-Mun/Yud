IDEAL
MODEL small
STACK 100h
DATASEG

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	mov dl, 4d
	mov al, dl
	cbw
	mov bx, ax ;13.a
	
	mov dl, -4d
	mov al, dl
	cbw
	mov bx, ax ;13.b
	
	mov cx, 254
	mov dl, cl ;13.c
	
	mov bx, -2
	mov al, bl ;13.d
	
exit:
	mov ax, 4c00h
	int 21h

END start


 