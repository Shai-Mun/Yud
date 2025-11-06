IDEAL

macro new_line
	mov dl,13   ; cr = caridge return - go to row start position
	mov ah,2   
	int 21h
	mov dl,10   ;  lf = line feed - go down to the next line
	int 21h
endm line
;---------------------------------------------;
; macro that show one char in screen  
macro show_char  my_char
	mov dl,my_char
	mov ah,2
	int 21h
endm 
;---------------------------------------------;
macro PUSH_ALL
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
endm 
;---------------------------------------------;
macro POP_ALL
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
endm 
;---------------------------------------------;
Macro absolute a
	local l1
	cmp a, 0
	jge l1
	neg a
l1:
Endm

;---------------------------------------------;
; case: DeltaY is bigger than DeltaX		  ;
; input: p1X p1Y,		            		  ;
; 		 p2X p2Y,		           		      ;
;		 Color                                ;
; output: line on the screen                  ;
;---------------------------------------------;
Macro DrawLine2DDY p1X, p1Y, p2X, p2Y
	local l1, lp, nxt
	mov dx, 1
	mov ax, [p1X]
	cmp ax, [p2X]
	jbe l1
	neg dx ; turn delta to -1
l1:
	mov ax, [p2Y]
	shr ax, 1 ; div by 2
	mov [TempW], ax
	mov ax, [p1X]
	mov [pointX], ax
	mov ax, [p1Y]
	mov [pointY], ax
	mov bx, [p2Y]
	sub bx, [p1Y]
	absolute bx
	mov cx, [p2X]
	sub cx, [p1X]
	absolute cx
	mov ax, [p2Y]
lp:
	PUSH_ALL
	call PIXEL
	POP_ALL
	inc [pointY]
	cmp [TempW], 0
	jge nxt
	add [TempW], bx ; bx = (p2Y - p1Y) = deltay
	add [pointX], dx ; dx = delta
nxt:
	sub [TempW], cx ; cx = abs(p2X - p1X) = daltax
	cmp [pointY], ax ; ax = p2Y
	jne lp
	call PIXEL
ENDM DrawLine2DDY

;---------------------------------------------;
; case: DeltaX is bigger than DeltaY		  ;
; input: p1X p1Y,		            		  ;
; 		 p2X p2Y,		           		      ;
;		 Color -> variable                    ;
; output: line on the screen                  ;
;---------------------------------------------;
Macro DrawLine2DDX p1X, p1Y, p2X, p2Y
	local l1, lp, nxt
	mov dx, 1
	mov ax, [p1Y]
	cmp ax, [p2Y]
	jbe l1
	neg dx ; turn delta to -1
l1:
	mov ax, [p2X]
	shr ax, 1 ; div by 2
	mov [TempW], ax
	mov ax, [p1X]
	mov [pointX], ax
	mov ax, [p1Y]
	mov [pointY], ax
	mov bx, [p2X]
	sub bx, [p1X]
	absolute bx
	mov cx, [p2Y]
	sub cx, [p1Y]
	absolute cx
	mov ax, [p2X]
lp:
	PUSH_ALL
	call PIXEL
	POP_ALL
	inc [pointX]
	cmp [TempW], 0
	jge nxt
	add [TempW], bx ; bx = abs(p2X - p1X) = deltax
	add [pointY], dx ; dx = delta
nxt:
	sub [TempW], cx ; cx = abs(p2Y - p1Y) = deltay
	cmp [pointX], ax ; ax = p2X
	jne lp
	call PIXEL
ENDM DrawLine2DDX
;---------------------------------------------;
macro SHOW_MOUSE
	mov ax,1
	int 33h
endm
;---------------------------------------------;
macro HIDE_MOUSE
	mov ax,2
	int 33h
endm

MODEL small
STACK 100h

DATASEG
	vec dd ?
	
	hex      db ?,?,13,10,'$'
	hx_table db '0123456789abcdef'
	scancode db 0
	
	TempW dw ?
    pointX dw ? 
	pointY dw ?
    point1X dw ? 
	point1Y dw ?
    point2X dw ? 
	point2Y dw ?
	Color db ?
	
	ExitClick db ?
	Click db ?

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	mov es,ax
   
	;set graphic mode
    mov ax,0013h
    int 10h
	
	;show cursor
	mov ax,0
	int 33h
	
	;start
	mov ax,0a000h
    mov es,ax    
	 
	mov [Color], 61	
	SHOW_MOUSE
await:
    
	mov ax, 3h
	int 33h
	shr cx, 1
	
	cmp bx, 1
	jz left
	cmp bx, 2
	jz right
	
	jmp await
	
left:
	mov di, dx ;row of circle center  
	mov dx, cx ;column of circle center 
	mov al,04              ;colour
    mov bx,30              ;radius
	call circleV1            ;draw circle
	jmp await
	
right:
	cmp cx, 315
	jg exit
	mov [point1X], cx
	mov [point1Y], dx
	mov [point2X], 319
	mov [point2Y], 0
	call DrawLine2D
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

;---------------------------------------------;
; input: point1X point1Y,         ;
; 		 point2X point2Y,         ;
;		 Color                                ;
; output: line on the screen                  ;
;---------------------------------------------;
PROC DrawLine2D
	mov cx, [point1X]
	sub cx, [point2X]
	absolute cx
	mov bx, [point1Y]
	sub bx, [point2Y]
	absolute bx
	cmp cx, bx
	jnae @@c1        ; deltaX <= deltaY
	jmp DrawLine2Dp1 ; deltaX > deltaY
@@c1:
	mov ax, [point1X]
	mov bx, [point2X]
	mov cx, [point1Y]
	mov dx, [point2Y]
	cmp cx, dx
	jbe DrawLine2DpNxt1 ; point1Y <= point2Y
	xchg ax, bx
	xchg cx, dx
DrawLine2DpNxt1:
	mov [point1X], ax
	mov [point2X], bx
	mov [point1Y], cx
	mov [point2Y], dx
	DrawLine2DDY point1X, point1Y, point2X, point2Y
	ret
DrawLine2Dp1:
	mov ax, [point1X]
	mov bx, [point2X]
	mov cx, [point1Y]
	mov dx, [point2Y]
	cmp ax, bx
	jbe DrawLine2DpNxt2 ; point1X <= point2X
	xchg ax, bx
	xchg cx, dx
DrawLine2DpNxt2:
	mov [point1X], ax
	mov [point2X], bx
	mov [point1Y], cx
	mov [point2Y], dx
	DrawLine2DDX point1X, point1Y, point2X, point2Y
	ret
ENDP DrawLine2D



;-----------------------------------------------;
; input: pointX pointY,      					;
;           Color								;
; output: point on the screen					;
;-----------------------------------------------;
PROC PIXEL
	mov bh,0h
	mov cx,[pointX]
	mov dx,[pointY]
	mov al,[Color]
	mov ah,0Ch
	int 10h
	ret
ENDP PIXEL

END start


 