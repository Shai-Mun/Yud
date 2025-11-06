
IDEAL
MODEL small





STACK 0f500h


MaxFloodStackDepth = 03000h


BMP_MAX_WIDTH = 320
SCREEN_WIDTH = 320
BMP_MAX_HEIGHT = 200


DATASEG

	
   
   
    ScrLine 	db BMP_MAX_WIDTH dup (0)  ; One Color line read buffer

	;BMP File data
	FileName 	db "myPic.bmp" ,0
	FileHandle	dw ?
	Header 	    db 54 dup(0)
	Palette 	db 400h dup (0)
	
	SmallPicName db 'Pic48X78.bmp',0
	
	
	BmpFileErrorMsg    	db 'Error At Opening Bmp File', 0dh, 0ah,'$'
	ErrorFile           db 0
    BB db "BB..",'$'
	BmpLeft dw ?
	BmpTop dw ?
	BmpWidth dw ?
	BmpHeight dw ?
	
	
	PressKey db "Press Any Key ...."
	LenPressKey dw $ - PressKey
	
	
	

CODESEG
 


 
start:
	mov ax, @data
	mov ds, ax



	call SetGraphic
	
	
	mov [BmpLeft],0
	mov [BmpTop],0
	mov [BmpWidth], 320
	mov [BmpHeight] ,200
	mov dx, offset FileName
	call OpenShowBmp
	
	
	push ds
	pop es
	mov ah,13h
	mov bp , offset PressKey
	mov dx,0202h
	mov cx,[LenPressKey]
	mov al,1
	mov bh,0
	mov bl,2 ; color
	int 10h
	
	
	mov ah,0
	int 16h
		
	



	mov bh, 0  ; border color
	mov bl,5    ; fill color
	mov cx,50
	mov dx,100
	mov ah,0dh
	call Flood
	 
	 
	 mov ah,0
	int 16h
	
	
	mov bh, 0  ; border color
	mov bl,24    ; fill color
	mov cx,17
	mov dx,92
	mov ah,0dh
	call Flood2
	 
	 
	mov ah,0
	int 16h
	
	
	
	mov bh, 255  ; border color
	mov bl,4    ; fill color
	mov cx,240
	mov dx,30
	mov ah,0dh
	call Flood
	


		
exit:
	mov dx, offset BB
	mov ah,9
	;int 21h
	
	mov ah,0
	int 16h
	
	mov ax,2
	int 10h

	
	mov ax, 4c00h
	int 21h
	
	




;Recursive proc that make int int10h (0dh) till it got border color 
; or move outside of the screen 
; Input: 	;ah = (int 0dh), bl= fill color bh = border color, 
;             cx = X, dx = Y  
proc Flood	near
	
	cmp cx,BMP_MAX_WIDTH
	jae ExitFloodNoPush
	cmp dx,BMP_MAX_HEIGHT 
	jae ExitFloodNoPush
	cmp sp, MaxFloodStackDepth
	jbe ExitFloodNoPush
	
	push ax
	push cx
	push dx
	
	int 10h     ; read pixel color
	cmp al,bh	
	je ExitFlood
	cmp al,bl  
	je ExitFlood
	
	
	 
	dec ah	    ; for int 10h  ah=0ch			
	mov al,bl  
	int 10h    ; put pixel
	 
	inc ah     ; put it back to 0dh
	
	
	;Make Flood  
	dec cx
	call 	Flood	 
	inc cx
	dec dx																
	call Flood		 
	inc dx
	inc cx
	call Flood		 
	dec cx
	inc dx
	call Flood		 
	
	 
	
ExitFlood:
	pop dx
	pop cx
	pop ax
	
ExitFloodNoPush:
	ret
endp Flood
 
 
  


;Recursive proc like flood bt replace only when see border
; or move outside of the screen 
; Input: 	;ah = (int 0dh), bl= fill color bh = border color, 
;             cx = X, dx = Y  
proc Flood2	near
	
	cmp cx,BMP_MAX_WIDTH
	jae ExitFloodNoPush2
	cmp dx,BMP_MAX_HEIGHT 
	jae ExitFloodNoPush2
	cmp sp, MaxFloodStackDepth
	jbe ExitFloodNoPush2
	
	push ax
	push cx
	push dx
	
	int 10h     ; read pixel color
	cmp al,bh	
	jne ExitFlood2
	cmp al,bl  
	je ExitFlood2
	
	
	 
	dec ah	    ; for int 10h  ah=0ch			
	mov al,bl  
	int 10h    ; put pixel
 
	inc ah     ; put it back to 0dh
	
	
	;Make Flood  
	dec cx
	call 	Flood2	 
	inc cx
	dec dx																
	call Flood2		 
	inc dx
	inc cx
	call Flood2		 
	dec cx
	inc dx
	call Flood2		 
	
	 
	
ExitFlood2:
	pop dx
	pop cx
	pop ax
	
ExitFloodNoPush2:
	ret
endp Flood2
 

 
  
proc  SetGraphic
	mov ax,13h   ; 320 X 200 
				 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
	int 10h
	ret
endp 	SetGraphic


proc OpenShowBmp near
	mov [ErrorFile],0
	 
	call OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call ReadBmpHeader
	
	call ReadBmpPalette
	
	call CopyBmpPalette
	
	call  ShowBmp
	
	 
	call CloseBmpFile

@@ExitProc:
	ret
endp OpenShowBmp


	
; input dx filename to open
proc OpenBmpFile	near						 
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




proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile




; Read 54 bytes the Header
proc ReadBmpHeader	near					
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
proc CopyBmpPalette		near					
										
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
	cmp ax, 0 
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
	rep movsb ; Copy line to the screen
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	
	pop cx
	loop @@NextLine
	
	pop cx
	ret
endp ShowBMP



end start

 