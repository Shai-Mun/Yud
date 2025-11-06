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
	
	mov [bx+1Ah], 0C4FEh
	mov ax,0
	add al,2
	add al,2
	add al,2
	add al,2

		
exit:
	mov ax, 4c00h
	int 21h

END start


 