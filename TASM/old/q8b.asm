IDEAL
MODEL small
STACK 100h
DATASEG

CODESEG

start: 
	mov ax, @data
	mov ds,ax
	 mov bx,00
	  mov ax,bx
	  mov bx, 0ccddh
	  mov [byte cs:19h], 08bh
	  mov [byte cs:1ah], 0c3h
	  nop
	  nop
	  nop
		
exit:
	mov ax, 4c00h
	int 21h

END start


 