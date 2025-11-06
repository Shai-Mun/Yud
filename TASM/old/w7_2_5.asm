IDEAL
MODEL small
STACK 100h
DATASEG
	print db "Enter a number", 13, 10, "$"
	printC db "Enter 4 chars", 13, 10, "$"
	InputArea db "XX1234X"
	BigStr db "XX1234X"
	SmallStr db "1234$"  
	num1 db ?
	num2 db ?
	line db 13,10, "$"
	result db "x$"

CODESEG
    
start: 
	mov ax, @data
	mov ds,ax
	
	call q2
	call q3
	call q4
	call q5
	
exit:
	mov ax, 4c00h
	int 21h

proc q2
	mov dx, offset print  
	mov ah, 9
	int 21h

	mov	ah, 1h
	int	21h	
	sub al, '0'
	mov [num1], al

	mov dx, offset line  
	mov ah, 9
	int 21h

	mov dx, offset print  
	mov ah, 9
	int 21h

	mov	ah, 1h
	int	21h	
	sub al, '0'
	mov [num2], al

	mov dx, offset line  
	mov ah, 9
	int 21h

	mov cl, [num2]
	mov al, [num1]
	mul cl
	add ax, '0'

	mov dx, ax
	mov ah, 2
	int 21h

	mov dx, offset print  
	mov ah, 9
	int 21h

	ret
endp q2

proc q3
mov dx, offset print  
	mov ah, 9
	int 21h

	mov	ah, 1h
	int	21h	
	sub al, '0'
	mov [num1], al
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dx, offset print  
	mov ah, 9
	int 21h
	
	mov	ah, 1h
	int	21h	
	sub al, '0'
	mov [num2], al
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov cl, [num2]
	mov al, [num1]
	mul cl
	add ax, '0'
	
	mov [result], al
	
	mov dx, offset result  
	mov ah, 9
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	ret
endp q3

proc q4
	mov dx, offset printC  
	mov ah, 9
	int 21h

	mov [byte InputArea],5 
	mov dx, offset InputArea
	mov ah, 0Ah     
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov dl, [InputArea+5]
	mov ah, 2
	int 21h
	mov dl, [InputArea+4]
	mov ah, 2
	int 21h
	mov dl, [InputArea+3]
	mov ah, 2
	int 21h
	mov dl, [InputArea+2]
	mov ah, 2
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	ret
endp q4

proc q5
	mov dx, offset printC  
	mov ah, 9
	int 21h

	mov [byte BigStr],5
	mov dx, offset BigStr
	mov ah, 0Ah     
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	mov al, [byte BigStr+2]
	or al, 00100000b
	mov [SmallStr], al
	
	mov al, [byte BigStr+3]
	or al, 00100000b
	mov [SmallStr+1], al
	
	mov al, [byte BigStr+4]
	or al, 00100000b
	mov [SmallStr+2], al
	
	mov al, [byte BigStr+5]
	or al, 00100000b
	mov [SmallStr+3], al
	
	mov dx, offset SmallStr  
	mov ah, 9
	int 21h
	
	mov dx, offset line  
	mov ah, 9
	int 21h
	
	ret
endp q5

END start


 