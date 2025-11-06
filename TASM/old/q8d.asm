IDEAL
MODEL small
STACK 100h
DATASEG

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	push cs
	pop ds
	nop
	
	mov [word ptr bx+1Dh], 0C4FEh
	mov [byte ptr bx+1Fh], 090h
	mov ax,0
	add ah,2
	add ah,2
	add ah,2
	add ah,2

		
exit:
	mov ax, 4c00h
	int 21h

END start


 