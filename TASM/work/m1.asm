IDEAL
MODEL small

public SetGraphic

STACK 100h

SCREEN_WIDTH = 320  
SMALL_BMP_HEIGHT = 20
SMALL_BMP_WIDTH = 20

FILE_NAME_IN equ 'bei.bmp'
DATASEG
	
CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	call SetGraphic	
		
exit:
	mov ax,2  ; back to mode text 
	int 10h
	
	mov ax, 4c00h
	int 21h

proc  SetGraphic
	; http://stanislavs.org/helppc/int_10-0.html

	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic

END start


 