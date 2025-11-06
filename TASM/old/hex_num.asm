IDEAL
MODEL small
STACK 100h

DATASEG
	print db "Please enter 2 hex letters", 13, 10, "$"
	InputArea db "XX12X"
	line db 13, 10, "$"
	num db ?
	
CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	mov dx, offset print  
	mov ah, 9
	int 21h

	mov [byte InputArea],6 
	mov dx, offset InputArea
	mov ah, 0Ah     
	int 21h

	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov al, [InputArea+3]
	sub al, 55
	mov [num], al
	mov cl, 16
	mov al, [InputArea+2]
	sub al, 55
	mul cl
	add [num], al
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov ah, 0
	mov al, [num]
	call ShowAxDecimal
	
exit:
	mov ax, 4c00h
	int 21h


proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
	   jmp PositiveAx
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


 