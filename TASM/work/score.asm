IDEAL
MODEL small
STACK 100h
DATASEG
	fileName db "score.txt", 0
	player db "Shai Mun09", 13, 10
	IntStr db 5 dup(?), 13, 10
	bin db ?, ?, 13, 10
	handle dw ?
	
CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	;open read
	mov al, 0
	mov dx, offset fileName
	mov ah, 3dh
	int 21h
	
	jc create
	mov [handle], ax
	
	;read
	mov bx, [handle]
	mov cx, 21
	mov dx, offset player
	mov ah, 3fh
	int 21h
	
	;close
	mov bx, [handle]
	mov ah, 3eh
	int 21h
	
	;open write
	mov al, 1
	mov dx, offset fileName
	mov ah, 3dh
	int 21h
	
	call str_to_int
	add ax, 25
	call int_to_str
	
	mov ax, [word bin]
	add ax, 25
	mov [word bin], ax
	jmp write
	
create:
	mov cx, 1
	mov ah, 3ch
	mov dx, offset fileName
	int 21h
	
	mov [handle], ax
	mov bx, [handle]
	
	mov di, offset IntStr
	mov cx, 5
Zero:
	mov [byte di], "0"
	inc di
loop Zero

	mov [bin], 0
	
write:
	mov cx, 12
	mov dx, offset player
	mov ah, 40h
	int 21h
	mov cx, 7
	mov dx, offset IntStr
	mov ah, 40h
	int 21h
	mov cx, 2
	mov dx, offset bin
	mov ah, 40h
	int 21h
	
exit:
	mov ax, 4c00h
	int 21h



;================================================
; Description - Convert String to Integer16 Unsigned
;             - Any number from 0 - 64k -1 
; INPUT:  IntStr string number ended with 10 or 13
; OUTPUT: ax as number
; Register Usage:  
;================================================
 proc str_to_int 
	push bx
	push cx
	push dx
	push si
	push di
	
	mov si, 0  ; num of digits
	mov di,10
	xor ax, ax
	
@@NextDigit:
    mov bl, [IntStr + si]   ; read next ascii byte
	cmp bl,10  ; stop condition LF
	je @@ret
	cmp bl,13  ; or 13  CR
	je @@ret
	
	mul di
	
	mov bh ,0
	
	sub bl, '0'
	add ax , bx

	inc si
	cmp si, 5     ;one more stop condition
	jb @@NextDigit
	 
@@ret:
	; ax contains the number 	
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	
	ret
endp str_to_int 


 

;================================================
; Description - Write to IntStr the num inside ax and put 13 10 after 
;			 
; INPUT: AX
; OUTPUT: IntStr 
; Register Usage: AX  
;================================================
proc int_to_str
	   push ax
	   push bx
	   push cx
	   push dx
	   
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
	   xor si, si
	   mov [IntStr], al
	   inc si
	   
		   
pop_next: 
	   pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   
	   mov [IntStr + si], al
	   inc si
	   loop pop_next
		
	   mov [IntStr + si], 13
	   mov [IntStr + si +1 ], 10
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp int_to_str

END start


 