IDEAL
MODEL small
STACK 100h
DATASEG
	printN db "Enter a 3 digit number", 13, 10, "$"
	nume db "##000#"
	printD db "Enter a 1 digit divisor", 13, 10, "$"
	deno db "##0#"
	
	line db 13,10, "$"
	targil db "xxx:x=xx(x)$"

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	mov dx, offset printN
	mov ah, 9
	int 21h

	mov [byte nume],4
	mov dx, offset nume
	mov ah, 0Ah     
	int 21h
	
	mov dx, offset line
	mov ah, 9
	int 21h
	
	mov dx, offset printD
	mov ah, 9
	int 21h
	
	mov [byte deno],2 
	mov dx, offset deno
	mov ah, 0Ah     
	int 21h
	
	mov dx, offset line
	mov ah, 9
	int 21h

	mov al, [nume+2]
	mov [targil], al
	
	mov al, [nume+3]
	mov [targil+1], al
	
	mov al, [nume+4]
	mov [targil+2], al
	
	mov ax, 0
	mov al, [nume+2]
	sub al, '0'
	mov cl, 100
	mul cl
	mov dl, al
	mov al, [nume+3]
	sub al, '0'
	mov cl, 10
	mul cl
	add al, dl
	sub [nume+4], '0'
	add al, [nume+4]
	mov cl, al
	
	mov al, [deno+2]
	mov [targil+4], al
	
	mov ax, 0
	mov al, cl

	sub [deno+2], '0'
	div [deno+2]
	
	mov dl, ah
	mov ah, 0
	mov ch, 10
	div ch
	add al, '0'
	add ah, '0'
	mov [targil+6], al
	mov [targil+7], ah

	add dl, '0'
	mov [targil+9], dl
	
	mov dx, offset targil
	mov ah, 9
	int 21h
	
exit:
	mov ax, 4c00h
	int 21h

proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	    
	   push ax
	   mov dl, 10
       mov ah, 2h
	   int 21h
	   mov dl, 13
       mov ah, 2h
	   int 21h
	   pop ax
	   
	   
	   ; check if negative
	   test ax,08000h
	   jz PositiveAx
			
	   ;  put '-' on the screen
	   push ax
	   mov dl,'-'
	   mov ah,2
	   int 21h
	   pop ax

	   neg ax ; make it positive
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
       loop pop_next
		
	   mov dl, ','
       mov ah, 2h
	   int 21h
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   ret 
endp ShowAxDecimal

END start


 