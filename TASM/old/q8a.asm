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
	
	mov [bx+05h], 0FEC4h
	mov [bx+01h], 0FEC4h ;8.a
	;8.b - the code changes the opcodes of the nop bytes to 8BC3, which moves BX to AX
exit:
	mov ax, 4c00h
	int 21h

END start