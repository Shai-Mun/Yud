IDEAL
MODEL small
STACK 100h
DATASEG

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	;cbw extends al into ax based on the MSB on al, if it's a 0 it extends al into ax from ??xy to
	;00xy, if it's a 1 then it extends from ??xy to FFxy.
	;cbw is a command with no operands and it always works with ax.
exit:
	mov ax, 4c00h
	int 21h

END start


 