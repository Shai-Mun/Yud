IDEAL
MODEL small
STACK 08080h
 
LEFT = 5
RIGHT = 155
SCREEN_WIDTH = 320  
DATASEG
    ScrLine 	db SCREEN_WIDTH dup (0)  ; One Color line read buffer

	;BMP File data
 
	WallPicName 	db "nof.bmp" ,0
	GalgalFileName  db 'galgal.bmp',0
	 
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	 
	BmpFileErrorMsg    	db 'Error At Opening Bmp File ', 0dh, 0ah,'$'
	ErrorFile           db 0
    BB db "BB..",'$'
	; array for mouse int 33 ax=09 (not a must) 64 bytes
	
	BmpLeft dw ?
	BmpTop dw ?
	BmpWidth dw ?
	BmpHeight dw ?
	
	Galgal1Top dw ?
	Galgal1Left dw ?
	
	Galgal2Top dw ?
	Galgal2Left dw ?
	
	gotSpace db 0
	dif dw 0
	stop1 db 0
	stop2 db 0
	
CODESEG
 
start:
	mov ax, @data
	mov ds, ax
	
	call SetGraphic

	call showNof
	

	
	mov [Galgal1Left],20
	mov [Galgal1Top],20
    call DrawGalgal1 
	
	mov [Galgal2Left],155
	mov [Galgal2Top],20
	call DrawGalgal1 
 
	 
	mov [gotSpace] , 0
ag:
	
	call CheckAndReadKey
	jc noKey
	cmp ah ,1
	jne c1
	jmp exit

c1:	
	cmp [gotSpace] ,1
	je Arrows
	cmp al,' '
	je MarkSpace
	;call _100MiliSecDelay
	jmp ag
	 
	
MarkSpace:
	mov [gotSpace],1
	jmp ag
	
Arrows:
	cmp ah,4bh
	jnz n1
	sub [Galgal1Left], 2
	jmp show
n1:
	cmp ah,48h
	jnz n2
	sub [Galgal1Top], 2
	jmp show
n2:
    cmp ah,4dh
	jnz n3
	add [Galgal1Left], 2
	jmp show
n3:
	cmp ah,50h
	jnz noKey
	add [Galgal1Top], 2
	jmp show
 
noKey:
	cmp [gotSpace] ,1
	je long
	jmp endLoop
long:
 
	mov ax, [Galgal1Left]
	sub ax, 5
	
	mov [dif], ax
	mov ax, 100
	add ax, [dif]
	cmp [Galgal1Top], ax
	jbe sto
	cmp [Galgal1Left], 155
	jae sto2
	add [Galgal1Left], 10
	add [Galgal1Top], 10
	jmp sto
	
sto2:
	mov [stop1], 1
	jmp show
	
sto:
	mov [stop1], 0
	inc [Galgal1Top] 
	cmp [Galgal1Top] , 200
	ja exit
show:
	cmp [Galgal2Top] , 131
	jbe skip
	
	mov [stop2], 1
	jmp skip2
skip:
	inc [Galgal2Top]
skip2:	

	cmp [stop1], 1
	jne nvm
	cmp [stop2], 1
	je exit

nvm:
	Call showNof
	cmp [stop2], 1
	jne keep
	
	mov cx, 155
	mov dx, 180
	mov al, 5
	mov si, 10
	mov di, 50
	call Rect
keep:
	call DrawGalgal1
	call DrawGalgal2
	 
	
endLoop:	
	 
	jmp ag
	
 	 
exit:
	
	mov dx, offset BB
	mov ah,9
	int 21h
	
	mov ah,0
	int 16h
	
	mov ax,2
	int 10h
	
	 

	
	mov ax, 4c00h
	int 21h
 
	
	
	
;==========================
;==========================
;===== Procedures  Area ===
;==========================
;==========================
; 
proc showNof
	mov dx, offset WallPicName
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpWidth], 320
	mov [BmpHeight] ,200
	call OpenShowBmp
	

	ret
endp showNof

proc DrawGalgal1
    mov dx, offset GalgalFileName
	mov ax, [Galgal1Top]
	mov [BmpTop], ax
	
	mov ax, [Galgal1Left]
	mov [BmpLeft], ax
	mov [BmpWidth], 56
	mov [BmpHeight] ,48
	call OpenShowBmp
	

	ret
endp DrawGalgal1

 proc DrawGalgal2
    mov dx, offset GalgalFileName
	mov ax, [Galgal2Top]
	mov [BmpTop], ax
	
	mov ax, [Galgal2Left]
	mov [BmpLeft], ax
	mov [BmpWidth], 56
	mov [BmpHeight] ,48
	call OpenShowBmp
	

	ret
endp DrawGalgal2


proc  SetGraphic 
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic

 
proc CheckAndReadKey
	  mov ah,1
	  int 16h
	  jz @@setC
	   
	  mov ah ,0
	  int 16h
	  clc
	  jmp @@ret
@@setC:
	  stc
@@ret:
	  ret
endp CheckAndReadKey

 
proc CheckAndReadLastKey
	push bx
    mov ah ,1
	int 16h
	jz @@setC
@@nextKey:
	mov ah ,0
	int 16h
	mov bx, ax
	mov ah ,1
	int 16h
	jz @@cleaerC
	jmp @@nextKey
@@cleaerC:
	mov ax, bx
	clc
	jmp @@ret
	
@@setC:
	stc
@@ret:
	pop bx
	ret
endp CheckAndReadLastKey


proc ClearScreen
star:
	push es
	push ax
	push cx
	push di
	
	push ax
	cld
	mov ax, 0a000h
	mov es,ax
	mov di,0
	pop ax
	mov ah,al
	mov cx, 32000
	rep stosw
	
	pop di
	pop cx
	pop ax
	pop es
	
	ret
endp ClearScreen
 
 
 
 
proc _200MiliSecDelay
	call _100MiliSecDelay
	call _100MiliSecDelay
	ret
 
endp _200MiliSecDelay



proc smallDelay
	push cx
	
	mov cx ,50 
@@Self1:
	
	push cx
	mov cx,60 

@@Self2:	
	loop @@Self2
	
	pop cx
	loop @@Self1
	
	pop cx
	ret
endp smallDelay




proc _100MiliSecDelay
	push cx
	
	mov cx ,500 
@@Self1:
	
	push cx
	mov cx,600 

@@Self2:	
	loop @@Self2
	
	pop cx
	loop @@Self1
	
	pop cx
	ret
endp _100MiliSecDelay



proc _400MiliSecDelay
	call _200MiliSecDelay
	call _200MiliSecDelay
	ret
endp _400MiliSecDelay

 

 
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

proc ShowAxHex
	
	mov bx,ax
	mov cx,4
@@Next:
	
	mov dx,0f000h
	and dx,bx
	rol dx, 4          
	cmp dl, 9
	ja @@n1
	add dl, '0'
	jmp @@n2

@@n1:	 
	add dl, ('A' - 10)

@@n2:
	mov ah, 2
	int 21h
	shl bx,4
	loop @@Next
	
	mov dl,'h'
	mov ah, 2
	int 21h
	
	ret
endp ShowAxHex





 
 
proc delay
	push cx
	
	mov cx,500
@@l1:
	push cx
	mov cx, 100
@@l2: loop @@l2
	pop cx
	loop @@l1

	pop cx
	ret
endp delay	

 
proc OpenShowBmp  
	mov [ErrorFile],0
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call ShowBMP
	
	 
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp

	
; input dx filename to open
proc OpenBmpFile	 near						 
	mov ah, 3Dh
	xor al, al
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
 
 
 



proc CloseBmpFile  near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile




; Read 54 bytes the Header
proc ReadBmpHeader	 near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader



proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette	 near						
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette



 

 
 
proc ShowBMP   
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov ax,[BmpWidth] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	mov bp, 0
	and ax, 3
	jz @@row_ok
	mov bp,4
	sub bp,ax
	
	
@@row_ok:	
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,[BmpLeft]
	cld ; Clear direction flag, for movsb forward
	; rep movsb  = mov [es:di++/--], [ds:si ++/--]
	mov cx, [BmpHeight]
@@NextLine:
	push cx
 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpWidth]  
	add cx,bp  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory es:di
	
	mov cx,[BmpWidth]  
	mov si,offset ScrLine

tst:
	cmp [byte si], 0FBh
	jne move
	inc si
	inc di
	jmp lp
	
move:
	movsb ; Copy line to the screen   mov cx times [es:di], [ds:si] di++ si++
lp:
loop tst
 	
@@endLoop:	
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	
	
	pop cx
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP

 
 
proc DrawHorizontalLine	near
	push si
	push cx
DrawLine:
	cmp si,0
	jz ExitDrawLine	
	 
    mov ah,0ch	
	int 10h    ; put pixel
	 
	
	inc cx
	dec si
	jmp DrawLine
	
	
ExitDrawLine:
	pop cx
    pop si
	ret
endp DrawHorizontalLine



proc DrawVerticalLine  	near
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
proc Rect  near
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


 
 

 proc DrawDiagonal
	mov cx, 10
	mov dx, 150
	mov si, 45
	mov al,4
@@ag:
	
	
	mov ah,0ch
	int 10h
	inc cx
	inc dx

	dec si
	cmp si,0
	jnz @@ag
	
 
	ret
 endp DrawDiagonal
 
 
 
  
 


 
END start


