IDEAL
STUDENT_NAME equ "Shai"


MODEL small
;public  KBInput
;public  NumByte1
;public  NumWord1
;public  NumByte2
;public  NumWord2
;public  Remainder7
;public  ShowAxDecimal
;public  Test_B
 


STACK 100h

DATASEG
 
	p db "Enter a 3 dig num:", 13, 10, "$"
	KBInput db "XX123X"
	line db 13,10, "$"
	
CODESEG

    
start: 
	mov ax, @data
	mov ds,ax
	
	mov dx, offset p
	mov ah, 9
	int 21h 
	
	mov [byte KBInput], 4
	mov dx, offset KBInput
	mov ah, 0Ah
	int 21h
	
	sub [KBInput + 2], '0'
	sub [KBInput + 3], '0'
	sub [KBInput + 4], '0'

	mov ax, 0
	mov al, [KBInput + 2]
	mov bl, 100
	mul bl
	mov dx, ax
	
	mov ax, 0
	mov al, [KBInput + 3]
	mov bl, 10
	mul bl
	add dx, ax
	
	mov ax, 0
	mov al, [KBInput + 4]
	add dx, ax
	shl dx, 1
	
	mov ax, dx
	mov bl, 100
	div bl
	mov ah, 0
	
	mov dx, offset line
	mov ah, 9
	int 21h 
	
	mov dl, al
	add dl, '0'
	mov ah, 2
	int 21h
	
exit:
	mov ax, 4c00h
	int 21h
;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;
 
;================================================
; Description - Write on screen the value of ax (decimal)
;               the practice :  
;				Divide AX by 10 and put the Mod on stack 
;               Repeat Until AX smaller than 10 then print AX (MSB) 
;           	then pop from the stack all what we kept there and show it. 
; INPUT: AX
; OUTPUT: Screen 
; Register Usage: AX  
;================================================
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


