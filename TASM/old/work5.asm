IDEAL
MODEL small
STACK 100h
DATASEG
	firstName db "Shai"
	age db 15d
	age2 dw 15d
	lastName db "Muntner"
	myArray dw 50d dup(0A504h) ;1 

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	mov bx, 0bfddh ;2
	
	xchg bh, bl ;3.a
	mov ax, [16h]
	mov [06h], ax ;3.b
	mov al, [byte ptr 05h]
	mov ah, [byte ptr 03h]
	mov [byte ptr 05h], ah
	mov [byte ptr 03h], al ;3.c
	
	mov [byte ptr 01h], 041h ;4
	
	mov [byte ptr 10h], 11110000b
	mov [byte ptr 16], 11110000b ;5.a
	mov [byte ptr 0ah], 240 ;5.b
	mov [byte ptr 0bh], -16 ;5.c, F0
	
	mov al, [100h] ;6.a, because we didn't define a value there (not sure)
	mov [101h], 0AAh ;6.b
	mov al, [50h]
	mov ch, [51h] ;6.b
	mov bx, 30h
	mov dx, [bx]
	add bx, 2
	mov cx, [bx] ;6.c, yes, we skipped 2 bytes in the A504 loop so we copied A504 twice
	
	mov cx, 7
	copyLoop:
	mov al, [lastName+di]
	mov [bx], al
	inc di
	inc bx
	loop copyLoop ;7
	
		
exit:
	mov ax, 4c00h
	int 21h

END start


 