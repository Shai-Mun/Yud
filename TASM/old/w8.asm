IDEAL
MODEL small
STACK 100h
DATASEG
	arr db 0, 1, 8 dup(0), "$"
	
	var1 db 5
	var2 db 20
	sum db 0, "$"
	p1 db "var: $"
	p2 db "sum: $"
	line db 13, 10, "$"
	
	pX db "Enter a num", 13, 10, "$"
	num1 db "xx1x"
	num2 db "xx1x"
	
	numAr db 1, 2, 3, 4, 5, 6, 7, 8, 9
	
CODESEG
    
start: 
	mov ax, @data
	mov ds,ax

	;call fibo
	;call mult
	;call printX
	call switch
	
exit:
	mov ax, 4c00h
	int 21h

proc fibo
	mov ax, 0
	mov bx, offset arr
	mov si, bx
	inc si
	mov di, si
	inc di
	
	mov cx, 8
FibLoop:
	mov al, [bx]
	add al, [si]
	mov [di], al
	
	inc bx
	inc si
	inc di
loop FibLoop

	ret
endp fibo

proc mult
	mov dx, offset p1  
	mov ah, 9
	int 21h
	
	mov ax, 0
	mov bl, 100
	mov al, [var1]
	div bl
	mov dl, al
	add dl, '0'
	mov bh, ah
	mov ah, 2
	int 21h
	mov ax, 0
	mov al, bh
	mov bl, 10
	div bl
	mov dl, al
	add dl, '0'
	mov bh, ah
	mov ah, 2
	int 21h
	mov dl, bh
	add dl, '0'
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dx, offset p1  
	mov ah, 9
	int 21h
	
	mov ax, 0
	mov bl, 100
	mov al, [var2]
	div bl
	mov dl, al
	add dl, '0'
	mov bh, ah
	mov ah, 2
	int 21h
	mov ax, 0
	mov al, bh
	mov bl, 10
	div bl
	mov dl, al
	add dl, '0'
	mov bh, ah
	mov ah, 2
	int 21h
	mov dl, bh
	add dl, '0'
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov cl, [var2]
	mov al, [var1]
	
MulLoop:
	add [sum], al
loop MulLoop

	mov dx, offset p2  
	mov ah, 9
	int 21h
	
	mov ax, 0
	mov bl, 100
	mov al, [sum]
	div bl
	mov dl, al
	add dl, '0'
	mov bh, ah
	mov ah, 2
	int 21h
	mov ax, 0
	mov al, bh
	mov bl, 10
	div bl
	mov dl, al
	add dl, '0'
	mov bh, ah
	mov ah, 2
	int 21h
	mov dl, bh
	add dl, '0'
	int 21h
	
	ret
endp mult

proc printX
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dx, offset pX
	mov ah, 9
	int 21h
	
	mov [byte num1],2 
	mov dx, offset num1
	mov ah, 0Ah     
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dx, offset pX  
	mov ah, 9
	int 21h
	
	mov [byte num2],2 
	mov dx, offset num2
	mov ah, 0Ah     
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	sub [num1 + 2], '0'
	sub [num2 + 2], '0'
	
	mov cl, [num1 + 2]
	
hei:
	mov dh, cl
	mov cl, [num2 + 2]
	wid:
		mov dl, 'x'
		mov ah, 2
		int 21h
	loop wid
	
	mov cl, dh
	mov dl, 0ah
	mov ah, 2
	int 21h
	
loop hei

	ret
endp printX

proc switch
	mov bx, offset numAr
	mov si, 0
	mov di, 8
	
	mov cx, 4
swiLoop:
	mov al, [bx+si]
	xchg al, [bx+di]
	mov [bx+si], al
	inc si
	dec di
loop swiLoop

	ret
endp switch
END start