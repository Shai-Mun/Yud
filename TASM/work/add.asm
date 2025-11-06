IDEAL
MODEL small
STACK 100h
DATASEG
	
CODESEG
    ip dw ?
	
start: 
	mov ax, @data
	mov ds,ax
	
	mov ax, 9
	mov bx, 5
	
	call addNum
	
exit:
	mov ax, 4c00h
	int 21h

Proc addNum
	pop [ip]
	pop ax
	pop dx
	
	add ax, dx
	
	push [ip]
	ret
endp addNum
END start


 