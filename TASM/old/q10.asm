IDEAL
MODEL small
STACK 100h
DATASEG
	num1 dw 10d
	num2 dw 20d
	
CODESEG
start:
	mov ax, @data
	mov ds, ax
	
	mov ax, [num1]
	add ax, [num2]
	
exit:
	mov ax, 4c00h
	int 21h
END start


