IDEAL
MODEL small
STACK 100h
;include 'Macros.asm'

macro PRINT_CHAR   CHAR
	 
	mov dl,CHAR
	mov ah,2
	int 21h
	mov dl,' '
	int 21h
 
endm

macro PRINT_STR STRPARAM
	 
	mov dx, offset STRPARAM
	mov ah,9
	int 21h
	 
endm

macro NEWLINE 
	 
	mov dl,10
	mov ah,2
	int 21h
	mov dl,13
	int 21h
	 
endm

macro SHOW_MOUSE
	mov ax,1
	int 33h
endm


macro HIDE_MOUSE
	mov ax,2
	int 33h
endm


; check if cx dx clicked on rectangle  
macro CHECK_CLICK x1,y1 , x2 ,y2
	local l1
	mov [Click],0
	
	cmp cx,x1
	jb l1
 	
	cmp cx,x2
	jae l1
	
	cmp dx,y1
	jb l1
 	
	cmp dx,y2
	jae l1
	mov [Click],1
l1:
endm 


DATASEG
		YesMsg  db "Yes $"
		NoMsg  db "No  $"
		LeftClickMsg db "Left $"
		RightClickMsg db "Right $"
		NoClickMsg db "No Click $"
		ExitClick db ?
		Click db ?
CODESEG
 
start:                          
	    mov ax,@data			 
		mov ds,ax		
		
		mov ax, 13h
		int 10h
		
		mov ax,0
		int 33h
		
		SHOW_MOUSE
		mov [ExitClick],0
		
		
		HIDE_MOUSE
		
		mov al,2
		mov cx,160
		mov dx,100
		mov si,20
		mov di,30
		call Rect  ; button to click 
		
		SHOW_MOUSE
	

		; check mouse status 
		call Mouse3
		
		
		mov [ExitClick],0
NextClick5:
		; get click info
		cmp [ExitClick],1
		jz exitLoop
		
		mov al,10
		mov cx,310
		mov dx,1
		mov si,5
		mov di,5
		call Rect
		
		
		call Mouse5
		jmp NextClick5
		 
		
exitLoop:		 
		
        		
		; check mouse status 
		call Mouse3
 
exit:	
		;mov ah,0
		;int 16h
		mov ax, 2
		int 10h
		
        mov ax,4C00h
        int 21h

;;;;
;;;;
;;;;
;;;;
;;;;
;;;;
;;;;
;;;;
 
 
proc Mouse3
	push cx
 
	mov ax,3h
 	int 33h
	shr cx,1
	 
	test bx,0001h
	jnz @@LeftClick    
	test bx,0002h
	jnz @@RightClick    
	
	PRINT_STR NoClickMsg
	jmp @@ret
	
@@LeftClick :
	PRINT_STR LeftClickMsg
	jmp @@ShowXY
@@RightClick:
	PRINT_STR RIghtClickMsg
	jmp @@ShowXY
	

@@ShowXY:	
	mov ax,cx
	call ShowAxDecimal
	mov ax,dx
	call ShowAxDecimal
	jmp @@ret

@@ret:
	pop cx
	ret
endp Mouse3







proc Mouse5
	push cx

@@ClickLoop:
	mov ax,5h
	mov bx,0 ; quary the left b
	int 33h
	
	 
	cmp bx,00h
	jna @@ClickLoop  ; mouse wasn't pressed
	and ax,0001h
	jz @@ClickLoop   ; left wasn't pressed

	shr cx,1
		
	CHECK_CLICK 310, 1 , 315, 6 ; click on exit 5 X 5
	
	cmp [Click],1
	jz @@exitMain
		
		
	CHECK_CLICK 160, 100, 190, 120 
	cmp [Click],1
	jnz @@NoClick
	
	PRINT_STR YesMsg
	jmp @@ret
	
@@NoClick:	
	PRINT_STR NoMsg
	jmp @@ret
	
@@exitMain:
	mov [ExitClick],1

@@ret:
@@ShowXY:
	
star:
	mov ax,cx
	call ShowAxDecimal
	mov ax,dx
	call ShowAxDecimal

	
	
	pop cx
	ret
endp Mouse5
 
 
 

 
 proc DrawVerticalLine	near
	push si
	push dx
 
DrawVertical:
	cmp si,0
	jz @@ExitDrawLine	
	 
    mov ah,0ch	
	int 10h    ; put pixel
	
	 
	
	inc dx
	dec si
	jmp DrawVertical
	
	
@@ExitDrawLine:
	pop dx
    pop si
	ret
endp DrawVerticalLine



; cx = col dx= row al = color si = height di = width 
proc Rect
	push cx
	push di
NextVerticalLine:	
	
	cmp di,0
	jz @@EndRect
	
	cmp si,0
	jz @@EndRect
	call DrawVerticalLine
	inc cx
	dec di
	jmp NextVerticalLine
	
	
@@EndRect:
	pop di
	pop cx
	ret
endp Rect


proc ShowAxDecimal
	   push ax
       push bx
	   push cx
	   push dx
	   
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