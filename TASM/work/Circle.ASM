ideal
 
macro new_line
	mov dl,13   ; cr = caridge return - go to row start position
	mov ah,2   
	int 21h
	mov dl,10   ;  lf = line feed - go down to the next line
	int 21h
endm line
; macro that show one char in screen  
macro show_char  my_char
	mov dl,my_char
	mov ah,2
	int 21h
endm 

 

	
	


model small
stack 0100h

 

dataseg
	
	vec dd ?

	
	hex      db ?,?,13,10,'$'
	hx_table db '0123456789abcdef'
	scancode db 0


	
	
codeseg
    
start:
	  mov ax,@data
	  mov ds,ax
	  
 
	mov es,ax
   

    mov ax,0013h
    int 10h
	
    mov ax,0a000h
    mov es,ax
	
	
	 mov       dx,150              ;column of circle center 
     mov       di,100              ;row of circle center  
     mov       al,04              ;colour
     mov       bx,30              ;radius
	 call      circleV1            ;draw circle 
	 
	 
	 
	
	 mov       dx,10              ;column of circle center 
     mov       di,10              ;row of circle center  
     mov       al,04              ;colour
     mov       bx,5              ;radius
	 mov 	   cx,0               ; CX = 0 all circle 1= Up half 2= Down half 3=Left  4=Right
     call      circleV2            ;draw circle 
	 
	 
	  mov       dx,40              
      mov       di,40               
      mov       al,4              
      mov       bx,25             
	  mov 	    cx,1              
      call      circleV2          
	
	
	  mov       dx,100            
      mov       di,100             
      mov       al,05             
      mov       bx,10             
	  mov 	    cx,2                
      call      circleV2           
	
	
	  mov       dx,150              
      mov       di,150               
      mov       al,06              
      mov       bx,6             
	  mov 	   cx,3              
      call      circleV2          
	
	
	  mov       dx,250            
      mov       di,150             
      mov       al,09             
      mov       bx,10             
	  mov 	   cx,4                
      call      circleV2           

	
	
	
	
	
	
	 mov di, 100  ; row of circle center  
     mov si,di
     shl di,8
     shl si,6
     add di,si
     add di, 160  ; column of circle center 
	 mov cx, 20 ; radius
	 mov al, 2
	
     call circleV3  

	
	 
	
	
					
	
	
await:
    mov ah,0
    int 16h
    cmp ah,1
    je exit
    jmp await

exit:
	mov ax,2h
    int 10h
	
    mov ax,4c00h ; returns control to dos
    int 21h
  

proc delay 
	push cx
	
	mov cx, 1000
l1:
	push cx
	mov cx, 2000
l2:	
	loop l2
	pop cx
	loop l1
	

	pop cx 
	ret
endp delay 


;-----------------------------------------------------------------------------


;  proc to draw a circle
; 	  How to call : 
;     mov       dx,60              ;column of circle center 
;     mov       di,100              ;row of circle center  
;     mov       al,04              ;colour
;     mov       bx,50              ;radius
;     call circleV1    
proc   circleV1
					push cx
					push si
                    mov       bp,0                ;x coordinate
                    mov       si,bx               ;y coordinate
@@c00:                
					xchg      bp,si               ;swap x and y
					call      _2pixelsV1            ;2 pixels
					call      _2pixelsV1 
					
					xchg      bp,si               ;swap x and y
					call      _2pixelsV1            ;2 pixels
					call      _2pixelsV1 
					
					
					sub       bx,bp               ;d=d-x
                    inc       bp                  ;x+1
					sub       bx,bp               ;d=d-(2x+1)
					jg        @@c01                 ;>> no step for y
                    add       bx,si               ;d=d+y
                    dec       si                  ;y-1
					add       bx,si               ;d=d+(2y-1)
@@c01:
					cmp       si,bp               ;check x>y
                    jae       @@c00                 ;>> need more pixels
					
					pop si
					pop cx
                    ret
endp circleV1
				
proc _2pixelsV1
					neg       si
                    push      di
                    add       di,si
					
					mov   cx,di    ; next 5 lines mul by 320 and add column
					shl   di,6     
					shl   cx,8
					add   di,cx
					add   di,dx
					 			
					mov       [es:di+bp],al
 					sub       di,bp
                    mov       [es:di],al

 					pop       di
                    ret 
endp _2pixelsV1

;-----------------------------------------------------------------------------


; circleV2 give the ability to draw partial circle
; recursive proc to draw a circle
; 	  How to call : 
;     mov       dx,60              ;column of circle center 
;     mov       di,100              ;row of circle center  
;     mov       al,04              ;colour
;     mov       bx,50              ;radius
;     cx   0 = All circle 1=Up curve  2=Down curve 3=Left  4=Right
;     call circleV2    
  
proc circleV2
                    mov       bp,0                ;x coordinate
                    mov       si,bx               ;y coordinate
c00:                call      _8pixels            ;set 8 pixels
                    sub       bx,bp               ;d=d-x
                    inc       bp                  ;x+1
					sub       bx,bp               ;d=d-(2x+1)
					jg        c01                 ;>> no step for y
                    add       bx,si               ;d=d+y
                    dec       si                  ;y-1
					add       bx,si               ;d=d+(2y-1)
c01:
					cmp       si,bp               ;check x>y
                    jae       c00                 ;>> need more pixels
                    ret
endp circleV2


proc _8pixels       
					call      _4pixels            ;4 pixels
                    xchg      bp,si               ;swap x and y
                    call      _2pixels            ;2 pixels
					neg       si
                    push      di
                    add       di,si
					call  FindScreenOffset
					cmp cx,1
					jz @@skipDown
					 cmp cx,3 
					jz @@skipRight
					mov       [es:di+bp],al
@@skipRight:
				 	sub       di,bp
					cmp cx,4 
					jz @@skipLeft
                    mov       [es:di],al
@@skipLeft:				
@@skipDown:				
					pop       di
                    ret 
endp _8pixels
				
				
proc _4pixels
                    xchg      bp,si               ;swap x and y
                    call      _2pixels            ;2 pixels
                    
					neg       si
                    push      di
                    add       di,si
					call  FindScreenOffset
					cmp cx,1
					jz @@skipDown
                    cmp cx,3 
					jz @@skipRight
					mov       [es:di+bp],al
@@skipRight:
					sub       di,bp
					cmp cx,4 
					jz @@skipLeft
                    mov       [es:di],al
@@skipLeft:					
@@skipDown:				   
   				    pop       di
                    ret 
endp _4pixels

				
proc _2pixels
					neg       si
                    push      di
                    add       di,si
					call  FindScreenOffset
					 
					cmp cx,2
					jz skipUp
					cmp cx,3 
					jz @@skipRight
                    mov       [es:di+bp],al
@@skipRight:
					sub       di,bp
					cmp cx,4 
					jz @@skipLeft
                    mov       [es:di],al
@@skipLeft:
skipUp:			
					 
					pop       di
                    ret 
endp _2pixels


proc FindScreenOffset
	push cx
	mov   cx,di    
	shl   di,6     
	shl   cx,8
	add   di,cx
	add   di,dx
	pop cx
	ret
endp 	FindScreenOffset



;-----------------------------------------------------------------------------





	

















 
; cx = radius 
; di = point on screen where to put the center of circle 
; al - color
; circleV3 is none recursive procedure
proc circleV3  
	
	push ax
	push bx
    push dx
	push si
	push bp
	
	

	push ax   ; store the color
   
    xor bx,bx
    mov ax,cx
    shl ax,1    ; radius * 2
    mov dx,3    
    sub dx,ax   ; 3 - r * 2
	
	pop ax     ; al=color
   

    ; calculate address of center in vidmem.
   
    mov bp,di   ; center point

@@loop1:
    ; plot 8 pixels using known centerpoint and x and y offsets.
    mov di,bp  ; back to center

    add di,bx 
    mov si,cx
    shl si,6
    add di,si
    shl si,2
    add di,si
    mov [es:di],al

    sub di,si
    sub di,si
    shr si,2
    sub di,si
    sub di,si
    mov [es:di],al


    sub di,bx
    sub di,bx
    mov [es:di],al

    add di,si
    add di,si
    shl si,2
    add di,si
    add di,si
    mov [es:di],al

    mov di,bp
    add di,cx
    mov si,bx
    shl si,6
    add di,si
    shl si,2
    add di,si
    mov [es:di],al


    sub di,si
    sub di,si
    shr si,2
    sub di,si
    sub di,si
    mov [es:di],al

    sub di,cx
    sub di,cx
    mov [es:di],al


    add di,si
    add di,si
    shl si,2
    add di,si
    add di,si
    mov [es:di],al

    ; is dx still under zero?
    cmp dx,0
    jge @@loop2

    ; if, add 4*xoffset+6 to dx
    mov si,bx
    shl si,2
    add si,6
    add dx,si
    jmp @@loop3


@@loop2:
    ; if not, add 4*(xoffset-yoffset)+10 to dx
    mov si,bx
    sub si,cx
    shl si,2
    add si,10
    add dx,si
    ; decrease y coordinate
    dec cx

@@loop3:
    ; increase x coordinate
    inc bx
    ; is x offset<y offset; if is, loop again.
    cmp bx,cx
    jnl @@endProc
	jmp @@loop1

@@endProc:   
	pop bp
	pop si
	pop dx
	pop bx
	pop ax
	
	
	ret
endp circleV3
 
end start