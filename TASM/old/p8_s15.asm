IDEAL
STUDENT_NAME equ "Shai Muntner"


;---------------------------------------------
; 
; Solution for Chapter 8 Work
;  
; This is personal task - Do not share it with others !!! 
;
;----------------------------------------------- 
 
MODEL small


;public  aTom1
;public  ZeroToNine2
;public  ZeroToNine3
;public  Array4 
;public  BufferFromEx5
;public  BufferToEx5
;public  BufferFrom6 
;public  BufferTo6
;public  BufferTo6Len
;public  MyLine7
;public  Line7Length
;public  MyWords7 
;public  MyWords7Length 
;public  MyQ8
;public  MySum8  
;public  MySet9  
;public  Count1
;public  Count2
;public  Count3
;public  Num10  
;public  BinaryStr10  
;public  EndGates11 
;public  Gate78 
;public  Num12A 
;public  Num12B 
;public  StrNum13 
;public  WordNum13 
;public  Num14Word 
;public  StrWord14 


public  ShowAxDecimal
public  ex1      
public  ex2      
public  ex3      
public  ex4      
public  ex5      
public  ex6      
public  ex7a     
public  ex7b     
public  ex8      
public  ex9      
public  ex10     
public  ex11     
public  ex12     
public  ex13     
public  ex14c 

stack 256
DATASEG

		;exercise 1
		aTom1 db 13 dup(?),"aTom1$"

		;exercise 2
		ZeroToNine2 db 10 dup(?),"ZeroToNine2$"		 

		;exercise 3
		ZeroToNine3 db 10 dup(?),"ZeroToNine3$"		 		 
		
		;exercise 4
		Array4 db 100 dup(?), "Array4$" 
		
		;exercise 5
		BufferFromEx5 db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, "BufferFromEx5$"
		BufferToEx5 db 10 dup(?), "BufferToEx5$"
		
		;exercise 6
		BufferFrom6 db -128, -115, -103, -98, -85, -79, -72, -65, -58, -50, -43, -37, -29, -24, -18, -12, -5, 0, 6, 12, 19, 25, 32, 38, 45, 51, 58, 64, 71, 77, 84, 90, 97, 103, 110, 116, 123, -127, -119, -110, -101, -93, -84, -75, -66, -57, -48, -39, -30, -21, -11, -2, "BufferFrom6$" 
		BufferTo6 db 50 dup(?), "BufferTo6$" 
		BufferTo6Len db 0, "BufferTo6Len$"
		
		;exercise 7
		MyLine7 db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, "MyLine7$"
		Line7Length db 0, "Line7Length$"
		
		;exercise 7b
		MyWords7 dw 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 0DDDDh, "$"
		MyWords7Length db 0, "MyWords7Length$"
		
		;exercise 8
		MyQ8 db 101, 130, 128, -8, 30, 201, 120, -3, 100, 255, 0, "MyQ8$"
		MySum8 dw 0, "$"
		
		;exercise 9
		MySet9 dw 0, 8000h, 6700h, 0, 8A00h, 8B00h, 1, 2300h, 0FFFFh, "$"
		Count1 db 0, "Count1$"
		Count2 db 0, "Count2$"
		Count3 db 0, "Count3$"
		
		;exercise 10
		Num10 db -128
		BinaryStr10 db 8 dup(0), "B$"
		
		
		;exercise 11
		True11 db "both 7&8 are 1 ",'$'
		False11 db "at least one of the bits 7,8 is 0",'$'
		EndGates11 db 255
		Gate78 db "x$"
		
		;exercise 12
		Num12A db 71
		Num12B db ?
		
		;exercise 13
		StrNum13 db "65535!"
		WordNum13 dw ?
		
		
		;exercise 14
		Num14Word dw ?
	 	StrWord14 db ?,?,?,?
		

CODESEG


start:
		mov ax, @data
		mov ds,ax


		 

		

		;call ex1
	 
		;call ex2
	 
		;call ex3
	 
		;call ex4
	 
		;call ex5
	 
		;call ex6
	 
		;call ex7a
		
		;call ex7b
		
		;call ex8	
		
		;call ex9
	 
		call ex10
	 
		;call ex11
	 
		;call ex12
	 
		;call ex13
		
		;mov al, 0AFh
		;call ex14b
		
		;mov [Num14Word], 41394
 		;call ex14c     ; this will call to ex14b and ex14a
	 
		
		
		
		 ; call TTTTTttttttTTT
	 

exit:
		mov ax, 04C00h
		int 21h

		
	 

		
;------------------------------------------------
;------------------------------------------------
;-- End of Main Program ... Start of Procedures 
;------------------------------------------------
;------------------------------------------------




;================================================
; Description -  Move 'a' 'm' to global var aTom1  
; INPUT: None
; OUTPUT: 
; Register Usage: ; only if value might be changed
;================================================
proc ex1
    push ax 
	push bx
	push cx

	;; TODO HERE SOLUTION for EX 1
	mov bx, offset aTom1
	xor ax, ax
	mov al, 'a'
	mov cx, 13
AToM:
	mov [bx], al
	inc al
	inc bx
	loop AToM
	
	
@@ret:
	pop cx
	pop bx
	pop ax
    ret
endp ex1





;================================================
; Description: Move '0' '9' to global var ZeroToNine2  
; INPUT: None
; OUTPUT: 
; Register Usage:  
;================================================
proc ex2
	push ax 
	push bx
	push cx

	mov bx, offset ZeroToNine2
	xor ax, ax
	mov al, '0'
	mov cx, 10
@@ZeroToNine:
	mov [bx], al
	inc al
	inc bx
	loop @@ZeroToNine

@@ret:
	pop cx
	pop bx
	pop ax
    ret
endp ex2





;================================================
; Description: Move 0 9 to global var ZeroToNine2  
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex3
 	push ax 
	push bx
	push cx

	mov bx, offset ZeroToNine3
	xor ax, ax
	mov al, 0
	mov cx, 10
@@ZeroToNine:
	mov [bx], al
	inc al
	inc bx
	loop @@ZeroToNine

@@ret:
	pop cx
	pop bx
	pop ax
    ret
endp ex3





;================================================
; Description: Move 'CC' to odd indexes and indexes that are divisible by 7 in var Array4
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex4
 	push ax 
	push bx
	push cx
	push dx
	push si
	
	xor ax, ax
	mov bx, offset Array4
	mov cx, 100
	mov si, 7	
	xor dx, dx
	
@@Array:
	test bx, 0001h
	jnz Move
	
	mov ax, bx
	div si
	cmp dx, 0
	jz Move
	
	jmp Skip
	
Move:
	mov [byte bx], 0CCh
Skip:
	xor dx, dx
	inc bx
	loop @@Array

@@ret:
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
    ret
endp ex4





;================================================
; Description: Move 10 numbers starting from var BufferFromEx5 to var BufferToEx5
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex5
	push ax 
	push si
	push cx
	push di

	mov si, offset BufferFromEx5
	mov di, offset BufferToEx5
	xor ax, ax
	mov cx, 10
@@BufferLoop:
	mov al, [si]
	mov [di], al
	mov [byte si], 0
	inc si
	inc di
	loop @@BufferLoop

@@ret:
	pop di
	pop cx
	pop si
	pop ax
    ret
endp ex5





;================================================
; Description: Move the numbers bigger than 12 starting from var BufferFrom6 to var BufferTo6, while counting all moves in var BufferTo6Len
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex6
 	push ax 
	push si
	push cx
	push di

	xor ax, ax	
	mov si, offset BufferFrom6
	mov di, offset BufferTo6
	mov cx, 49
@@BufferLoop:
	mov al, [si]
	cmp al, 12
	jna SkipM
	
	mov [di], al
	inc di
	inc [BufferTo6Len]
	
SkipM:
	inc si
	loop @@BufferLoop

@@ret:
	pop di
	pop cx
	pop si
	pop ax
    ret
endp ex6





;================================================
; Description: Count all of the numbers and stop at CR (13d) starting from var MyLine7, and save the counting in var Line7Length (the length is in bytes)
; INPUT: None  
; OUTPUT: 
; Register Usage:  
;================================================
proc ex7a
	push ax 
	push bx

	mov bx, offset MyLine7
	xor ax, ax
@@Count:
	mov al, [byte bx]
	cmp al, 13
	jz @@ret
	
	inc [Line7Length]
	inc bx
	jmp @@Count
	
@@ret:
	pop bx
	pop ax
    ret
endp ex7a





;================================================
; Description: Count all of the numbers and stop at 0DDDh starting from var MyWords7, and save the counting in var MyWords7Length (the length is in words)
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex7b
 	push ax 
	push bx

	mov bx, offset MyWords7
	xor ax, ax
@@Count:
	mov ax, [bx]
	cmp ax, 0DDDDh
	jz @@ret
	
	inc [MyWords7Length]
	add bx, 2
	jmp @@Count
	
@@ret:
	pop bx
	pop ax
    ret
endp ex7b





;================================================
; Description: Start from var MyQ8, and go through all of the numbers (in bytes), while summing up every number between 101-127
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex8
  	push ax
	push bx

	mov bx, offset MyQ8
	xor ax, ax
@@Count:
	mov al, [byte bx]
	cmp al, 0
	jz @@ret
	
	cmp al, 100
	jng @@Skip
	add [MySum8], ax
	
@@Skip:
	add bx, 1
	jmp @@Count
	
@@ret:
	pop bx
	pop ax
    ret
endp ex8





;================================================
; Description: Start from var MySet9, and go through all of the numbers (in words), while counting how many positive numbers, negative numbers, and zeros there are
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex9
	push ax
	push bx

	mov bx, offset MySet9
	xor ax, ax
@@Count:
	mov ax, [bx]
	cmp ax, 0FFFFh
	jz @@ret
	
	cmp ax, 0
	jz @@Zero
	jg @@Pos
	
	add [Count2], 1
	jmp @@Next
	
@@Zero:
	add [Count3], 1
	jmp @@Next

@@Pos:
	add [Count1], 1
	jmp @@Next
	
@@Next:
	add bx, 2
	jmp @@Count
	
@@ret:
	xor ah, ah
	mov al, [Count1]
	call ShowAxDecimal
	mov al, [Count2]
	call ShowAxDecimal
	mov al, [Count3]
	call ShowAxDecimal
	
	pop bx
	pop ax
    ret
endp ex9





;================================================
; Description: Turn a number from var Num10 into a binary base from a decimal base, and place it starting from var BinaryStr10
; INPUT: None
; OUTPUT: 
; Register Usage:  
;================================================
proc ex10
	push ax
	push bx
	push dx
	
	mov bx, offset BinaryStr10
	xor ax, ax
	mov al, [Num10]
	mov cx, 8
@@Num:
	shl al, 1
	jc @@One
	
	mov [byte bx], 0
	jmp @@Loop
	
@@One:
	mov [byte bx], 1
	
@@Loop:
	inc bx
	loop @@Num
	
	mov bx, offset BinaryStr10
	mov cx, 8
	mov ah, 2
@@Print:
	mov dl,	[bx]
	add dl, '0'
	int 21h
	inc bx
	loop @@Print
	
	mov dl,	[bx]
	int 21h

	pop dx
	pop bx
	pop ax
    ret
endp ex10





;================================================
; Description: Check if a number at var EndGates11 is bigger than 192d (meaning it has a 1 in the 7th and 8th bit), and respond accordingly
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex11
	push ax
	push dx
	
	xor ax, ax
	mov al, [EndGates11]
	test al, 80h
	jz @@F
	test al, 40h
	jz @@F
	
	mov dx, offset True11
	mov [Gate78], 'T'
	jmp @@Print
	
@@F:
	mov dx, offset False11
	mov [Gate78], 'F'
@@Print:
	mov ah, 9
	int 21h
	
	pop dx
	pop ax
    ret
endp ex11





;================================================
; Description: Check if a num at var Num12A is between 10d - 70d and if it is, copy it to Num12B
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex12
	push ax
	
	xor ax, ax
	mov al, [Num12A]
	cmp al, 10
	jb @@Skip
	cmp al, 70
	ja @@Skip
	
	mov [Num12B], al
@@Skip:
	
	pop ax
    ret
endp ex12





;================================================
; Description: Convert a string describing a number from var StrNum13 to a decimal number, and place it in var WordNum13
; INPUT: None 
; OUTPUT: 
; Register Usage:  
;================================================
proc ex13
	push ax
	push bx
	push dx
	push si
	push cx
	
	xor ax, ax
	mov bx, offset StrNum13
	mov si, 0
	mov cl, 10
	
@@Loop:
	xor dx, dx
	mov dl, [byte bx + si]
	cmp dl, '!'
	jz @@Done
	cmp si, 4
	jz @@Done
	
	sub dl, '0'
	mul cl
	add ax, dx
	
	inc si
	jmp @@Loop
	
@@Done:	
	mov [WordNum13], ax

	pop cx
	pop si
	pop dx
	pop bx
	pop ax
    ret
endp ex13





;================================================
; Description: Check the hex char at the 4 right bits, and then move the char's ascii value to dl
; INPUT: None 
; OUTPUT: 
; Register Usage: DX 
;================================================
proc ex14a
	push ax
	
	xor dx, dx
	
	and al, 0Fh
	mov dl, al
	cmp al, 0Ah
	jae @@Letter
	
	add dl, '0'
	jmp @@Skip
@@Letter:
	add dl, 'A'-10

@@Skip:
	mov ax, dx
	call ShowAxDecimal
	
	pop ax
    ret
endp ex14a





;================================================
; Description: Do the same thing as 14a, but instead of checking 4 bits, check a byte
; INPUT: None
; OUTPUT: 
; Register Usage: DX 
;================================================
proc ex14b
	push ax
	push cx
	
	xor dx, dx
	call ex14a
	shr al, 4
	push dx
	call ex14a
	pop cx
	
	xchg cl, dl
	mov dh, cl
 
	mov ax, dx
	call ShowAxDecimal
	
	pop cx
	pop ax
    ret
endp ex14b





;================================================
; Description: Do the same thing as 14b, but instead of checking a byte, check a word
; INPUT: None
; OUTPUT: 
; Register Usage: DX
;================================================
proc ex14c
	push ax
	
	mov ax, [Num14Word]
	xor dx, dx
	call ex14b
	mov [StrWord14+2], dh
	mov [StrWord14+3], dl
	shr ax, 8
	call ex14b
	mov [StrWord14], dh
	mov [StrWord14+1], dl

	mov dl, 13
	mov ah, 2
	int 21h
	mov dl, 10
	int 21h
	mov dl, [StrWord14]
	int 21h
	mov dl, [StrWord14+1]
	int 21h
	mov dl, [StrWord14+2]
	int 21h
	mov dl, [StrWord14+3]
	int 21h

	pop ax
    ret
endp ex14c







;================================================
; Description: print bytes to the screen ax times
; INPUT: bx = pointer to the bytes , ax = how many bytes
; OUTPUT: screen
; Register Usage:  ax ,bx 
;================================================
proc printBytesAXTimes
	push cx
	push dx
	
	mov cx,ax
@@ag:
	mov dl, [bx]
	mov ah,2
	int 21h
	inc bx
	loop @@ag
	
	pop dx
	pop cx
	ret
endp printBytesAXTimes





; guess what this proc does ?
; without good names and lack of description, 
; no comments .... it is very difficult
;================================================
; Description -  ??????????????????????? 
; INPUT: ????
; OUTPUT: ?????
; Register Usage: ????????????
;================================================
proc TTTTTttttttTTT
	
	mov bx,ax
	mov cx,4
CHChchchchc:
	
	mov dx,0f000h
	and dx,bx
	rol dx, 4          
	cmp dl, 9
	ja PPPFFFFpppfffff
	add dl, 48
	jmp ZzzzZzzZZZZ

PPPFFFFpppfffff:	 
	add dl, '7'

ZzzzZzzZZZZ:
	mov ah, 2
	int 33
	shl bx,4
	loop CHChchchchc
	
	ret
endp TTTTTttttttTTT





;================================================
; Description - Write on screen the value of ax (decimal)
;               the practice :  
;				Divide AX by 10 and put the Mod on stack 
;               Repeat Until AX smaller than 10 then print AX (MSB) 
;           	then pop from the stack all what we kept there and show it. 
; INPUT: AX
; OUTPUT: Screen 
; Register Usage:   
;================================================
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
 