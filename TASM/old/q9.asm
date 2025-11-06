IDEAL
MODEL small
STACK 100h
DATASEG
	firstname db "John"
	lastname  db "Averbooh" 
	myarray db 100 dup('B')
CODESEG
Start:
    mov ax, @data
    mov ds, ax
    mov al, [firstname] ;A4
    mov ah, [lastname + 2] ;65
	mov bx , offset  lastname ;0004
    lea bx, [lastname]  ;0004

	
		
exit:
	mov ax, 4c00h
	int 21h

END start


 