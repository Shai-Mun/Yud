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
;public  Test_A
 
	

STACK 100h

DATASEG
	TestTytle db 13,10,"Test Type A ...for "
	          db STUDENT_NAME ,13,10,"$"
	
	FromHere1 db -1
 
	 
	KBInput db "XX12X"
	NumByte1 db ?
	NumWord1 dw ?
	NumByte2 db ?
	NumWord2 dw ?
	Remainder7 db ?
	p1 db "Byte: $"
	p2 db "Word: $"
	line db 13,10, "$"

	ToHere1 db -1
	BB db 13,10,"Bye... ", STUDENT_NAME , "$"
CODESEG

    
start: 
	mov ax, @data
	mov ds,ax
	
	mov dx, offset TestTytle
	mov ah, 9
	int 21h 
	
	
	call Test_A


	mov ah,9h
	mov dx, offset BB
	int 21h
	
exit:
	mov ax, 4c00h
	int 21h
;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;
 

;; Methods 

proc Test_A

FromHere2:

	;a
	mov [byte KBInput],3
	mov dx, offset KBInput
	mov ah, 0Ah     
	int 21h

	;b
	mov al, [KBInput+3]
	sub al, '0'
	mov [NumByte1], al
	
	mov al, [KBInput+2]
	sub al, '0'
	mov cl, 10
	mul cl
	add [NumByte1], al
	 
	mov ax, 0
	mov al, [NumByte1]
	mov [NumWord1], ax
	
	;c
	mov dx, offset p1  
	mov ah, 9
	int 21h
	
	mov ax, 0
	mov al, [NumByte1]
	call ShowAxDecimal	
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dx, offset p2 
	mov ah, 9
	int 21h
	
	mov ax, 0
	mov ax, [NumWord1]
	call ShowAxDecimal
	
	;d
	mov ax, 0
	mov al, [NumByte1]
	mov cl, 7
	div cl
	mov [Remainder7], ah
	mov ah, 0
	call ShowAxDecimal
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dl, [Remainder7]
	add dl, '0'
	mov ah, 2
	int 21h	
	
ToHere2:
	ret
endp Test_A


 
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


