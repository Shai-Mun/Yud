IDEAL
MODEL small
STACK 100h
DATASEG
	num1 dw 10d
	num2 dw 20d
	sum dw 0d
	
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov ax, [num1]
	mov [sum], ax
	mov ax, [num2]
	add [sum], ax
	
exit:
	mov ax, 4c00h
	int 21h
END start


