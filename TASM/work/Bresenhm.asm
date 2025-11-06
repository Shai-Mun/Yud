;---------------------------------------------
; PURPOSE : Bresenham’s line algorithm
; SYSTEM  : Turbo Assembler Ideal Mode  
;---------------------------------------------
 
IDEAL
MODEL small


macro PUSH_ALL
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push bp
endm 

macro POP_ALL
	pop bp
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
endm 


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




STACK 256
DATASEG
	TempW dw ?
    pointX dw ? 
	pointY dw ?
    point1X dw ? 
	point1Y dw ?
    point2X dw ? 
	point2Y dw ?
	Color db ?
CODESEG
start:
    mov ax, @data
    mov ds, ax
	
	mov ax, 13h
	int 10h ; set graphic mode
	
	mov [Color], 61
	mov [point1X], 319
	mov [point1Y], 0
	mov [point2X], 0
	mov [point2Y], 199
	call DrawLine2D
	; !!! The 4 variables above(point1X ... ) 
	; !!! might be changed after call to DrawLine2D
	
	mov [Color], 11
	mov [point1X], 10
	mov [point1Y], 4
	mov [point2X], 60
	mov [point2Y], 6
	call DrawLine2D
	
	
	
	mov ah, 00h
	int 16h
exit:
	mov ax,02h
	int 10h ; set text mode

    mov ax, 4C00h
    int 21h
	
	

; procedures
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
