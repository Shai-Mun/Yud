IDEAL
MODEL compact
STACK 100h

SCREEN_WIDTH = 320
C_BMP_HEIGHT = 18
C_BMP_WIDTH = 18

EnemySize = 24
EnemyTearSize = 15
PlayerTearSize = 5

KeyboardInterruptPosition = 9 * 4


COOLDOWN = 100
ECOOLDOWN = 1
BCOOLDOWN = 200
INVINCIBILITY_FRAME = 100

macro SHOW_MOUSE
	mov ax,1
	int 33h
endm


macro HIDE_MOUSE
	mov ax,2
	int 33h
endm

;@@Check if cx dx clicked on rectangle
macro CHECK_CLICK x1,y1 , x2 ,y2
	local l1
	mov [Click],0

	cmp cx,x1
	jb l1

	cmp cx,x2
	jae l1

	cmp dx,y1
	jb l1

	cmp dx,y2
	jae l1
	mov [Click],1
l1:
endm

macro absolute a
	local l1
	cmp a, 0
	jge l1
	neg a
l1:
endm

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

macro MOVE_POINTS
	mov ax, [word di]
	add ax, 4
	mov [word bx], ax
	mov [word point1Y], ax

	mov ax, [word di+2]
	add ax, 4
	mov [word bx+2], ax
	mov [word point1X], ax

	mov ax, [word PLeft]
	add ax, 4
	mov [word point2X], ax
	
	mov ax, [word PTop]
	add ax, 4
	mov [word point2Y], ax
endm


DATASEG

	ScrLine 	db SCREEN_WIDTH dup (0)  ; One Color line read buffer

	;BMP File data
	TSPic db "TitleScn.bmp",0
	LoadPic db "Load.bmp",0
	PausePic db "Pause.bmp",0
	ArrowPic db "Arrow.bmp",0
	GameOverPic db "GameOver.bmp",0
	GameWonPic db "GameWon.bmp",0
	StarPic db "Star.bmp",0
	
	
	CPic db "Player.bmp",0
	PTPic db "PTear.bmp",0
	FullH db "FullH.bmp",0
	HalfH db "HalfH.bmp",0
	CoinsPic db "Coin.bmp",0
	MoneyHex db "00"
	MoneyDec db 0
	DmgPic db "Dmg.bmp",0 
	DmgHex db "03"
	
	GaperPic db "Gaper.bmp",0
	ETPic db "ETear.bmp",0
	BossPic db "FBoss.bmp",0
	DangerPic db "Danger.bmp",0
	BossDie db 0
	
	DangerX dw ?
	DangerY dw ?
	
	EArray db 24*4 dup(0) ;2 for Top, 2 for Left, 1 for Health, 1 for type, 2 for CD, 2 for delta Top, 2 for delta Left, 2 for tempW, 2 for delta
	;1 for main type (1 - x+, 2 - x-, 3 - y+, 4 - y-), 2 for cooldown
	ETArray db 15*4 dup(0) ;2 for Top, 2 for Left, 2 for delta Top, 2 for delta Left, 2 for tempW, 2 for delta
	;1 for main type (1 - x+, 2 - x-, 3 - y+, 4 - y-), 2 for cooldown
	
	Boss db 24 dup(0)
	BossT db 15*3 dup (0)
	Phase2 db 0
	JumpCD dw 150 ;550 - normal, 150 - jump, 50 - warn, 0 - land
	
	CurrEnemies db ?
	
	ErrorPic db "Error.bmp",0
	
	BmpLeft dw ?
	BmpTop dw ?
	BmpWidth dw ?
	BmpHeight dw ?

	FileHandle dw ?
	Header db 54 dup(0)
	Palette db 400h dup(0)
	ErrorFile db 0

	Click db ?
	PTop dw ?
	PLeft dw ?
	PMHealth db 6 ;Player Max Health
	PCHealth db 6 ;Player Current Health
	DmgDec db 3 ;Player Current Damage
	
	TArray db 5*10 dup(0) ;2 for X, 2 for Y, 1 for dir and split (1 for split, 7 for dir)
	
	TDir db ?
	TearCD dw COOLDOWN

	RndCurrentPos dw 0
	
	FirstRoom db 0
	Room db ?
	RetryMap db 255
	
	R1Pic db "R1.bmp",0
	R2Pic db "R2.bmp",0
	R3Pic db "R3.bmp",0
	R1MSPic db "R1M1.bmp",0, "R1M2.bmp",0, "R1M3.bmp",0
	R2MSPic db "R2M1.bmp",0, "R2M2.bmp",0, "R2M3.bmp",0
	R3MSPic db "R3M1.bmp",0, "R3M2.bmp",0, "R3M3.bmp",0
	SpecialRooms db "Treasure.bmp",0, "Shop.bmp",0, "Boss.bmp",0
	ItemCheck db 0
	ShopCheck db 0
	BossCheck db 0
	SpecialCheck db 0
	
	HDPic db "UDoor.bmp",0, "DDoor.bmp",0
	VDPic db "LDoor.bmp",0, "RDoor.bmp",0
	
	map dw 25 dup(0)
	CurrAddress dw ?
	RoomCnt db ?

	RPressed db 1
	EscPressed db 1
	WPressed db 1 ;0 = pressed, 1 = released
	APressed db 1 ;0 = pressed, 1 = released
	SPressed db 1 ;0 = pressed, 1 = released
	DPressed db 1 ;0 = pressed, 1 = released
	UpPressed db 1
	DownPressed db 1
	LeftPressed db 1
	RightPressed db 1
	
	SpacePressed db 1 ;0 = pressed, 1 = released
	
	oldintruptoffset dw ?
	oldintruptsegment dw ?
	key db ?
	
	Quit db 1
	Win db 0
	
	Moved db 0
	VMove db 0
	HMove db 0
	HasDoor db 0
	
    point1X dw ? 
	point1Y dw ?
    point2X dw ? 
	point2Y dw ?
	
	;items and effects
	AnalogPic db "Analog.bmp",0
	PentagramPic db "Penta.bmp",0
	CupidPic db "Cupid.bmp",0
	WedgePic db "Cricket.bmp",0
	SadOnionPic db "SadOnion.bmp",0
	DinnerPic db "Dinner.bmp",0
	PriceHex db "$00"
	PriceDec db ?
	
	Dir8 db 0
	Piercing db 0
	Splitting db 0
	Fast db 0
	
	Invin dw 0
	
CODESEG

start:

	mov ax, @data
	mov ds,ax

	;---------------------------------------------------------------------------------------------------------------------------------------------------;
	
	;---------------------------------------------------------------------------------------------------------------------------------------------------;
	;graphic
	mov ax, 13h
	int 10h

	;cursor
	mov ax,0
	int 33h
	
	call SetAsyncKeyboard
	
TitleScreen:
	mov dx, offset TSPic
	call DrawBg
	
	SHOW_MOUSE
	call Mouse5
	HIDE_MOUSE
	
	cmp [byte Quit], 1
	je StartG
	jmp exit	
	
StartG:
	call ResetGame
	
movedR:

	call GenerateRoom

	cmp [byte RetryMap], 0
	jne @@good
	jmp StartG
	@@good:
	call DrawRoom
	call DrawDoors
	call DrawHUD
	mov [byte Moved], 0
	
ag:
	call MoveRoom
	cmp [byte Moved], 1
	je movedR

	call AddT
	call MoveT
	
	call AddET
	call MoveET
	
	call CheckTHitbox
	call DrawT
	
	call CheckETHitbox
	call DrawET

	
	call MoveP
	mov dx, offset CPic
	push [PTop]
	push [PLeft]
	call DrawC
	call CheckEHitbox
	
	call MoveE
	call DrawEnemies

	call DrawItem
	call GetItem
	

	cmp [EscPressed], 1
	je @@NotEsc
	
	call PauseScreen
	call DrawRoom
	call DrawDoors
	call DrawHUD
	
	cmp [EscPressed], 0
	jne @@NotR
	jmp TitleScreen
	
@@NotEsc:
	cmp [RPressed], 1
	je @@NotR
	
	jmp StartG
	
@@NotR:
	
	cmp [byte Quit], 0
	je EndG
	
	jmp ag


EndG:	
	call GameOver
	
	cmp [byte Quit], 1
	jne exit
	jmp	StartG
exit:

	
	
	call RestoreKeyboardInt
	
	mov ax,2  ; back to mode text
	int 10h

	mov ax, 4c00h
	int 21h
	
	
;-----------------------------------------------------------------------------------------------------------------------------------------------------------;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------;
;--------------------------------------------------------------------;PROCEDURES;---------------------------------------------------------------------------;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------;
;-----------------------------------------------------------------------------------------------------------------------------------------------------------;



;***********************************************************************************************************************************************************;
;																Keyboard & mouse procs
;***********************************************************************************************************************************************************;

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

;Description:Makes Keyboard Async
;Input: none
;Output: none
proc SetAsyncKeyboard
	push es
	push cx
	push dx
	push ax
	push si
	
	xor ax, ax
	mov es, ax
	
	mov si, KeyboardInterruptPosition
	
	mov dx, [es:si]
	mov cx, [es:si+2]
	
	mov [oldintruptoffset], dx
	mov [oldintruptsegment], cx
	
	cli
	mov ax, offset Keyboard_handler
	mov [word es:si], ax
	mov ax, cs
	mov [word es:si + 2], ax
	sti
	
	pop si
	pop ax
	pop dx
	pop cx
	pop es
	ret
endp SetAsyncKeyboard

;Description: Makes Keyboard interrupt (int 9h) back to defult
;******************DID NOT @@Check***********************************
proc RestoreKeyboardInt
	push es
	push cx
	push dx
	push ax
	push si
	
	xor ax, ax
	mov es, ax
	
	mov si, KeyboardInterruptPosition
	
	mov dx, [oldintruptoffset]
	mov cx, [oldintruptsegment]
	
	cli
	mov [word es:si], dx
	mov [word es:si + 2], cx
	sti
	
	pop si
	pop ax
	pop dx
	pop cx
	pop es
	ret
endp RestoreKeyboardInt

;Description: This procedure is the procedure that happens when key is pressed (int 9h)
;Input: a key from the port
;Output: changes the value of the pressed keys
proc Keyboard_handler near
    push ax
    push bx
    push cx
    push dx                                          
    push sp
    push bp
    push si
    push di


    ; Gets the pressed key and stores it in [key]
    in al, 60h         
    mov [byte key], al

    mov al, 20h
    out 20h, al
	
	cmp [byte key], 11h ;w
	jnz @@NotW
	mov [WPressed], 0
	jmp @@endproc
@@NotW:

	cmp [byte key], 91h
	jnz @@NotWR
	mov [WPressed], 1
	jmp @@endproc
@@NotWR:

	cmp [byte key], 01fh ;a
	jnz @@NotS
	mov [SPressed], 0
	jmp @@endproc
@@NotS:
	
	cmp [byte key], 09fh
	jnz @@NotSR
	mov [SPressed], 1
	jmp @@endproc
@@NotSR:
	
	cmp [byte key], 1eh ;s
	jnz @@NotA
	mov [APressed], 0
	jmp @@endproc
@@NotA:

	cmp [byte key], 9eh
	jnz @@NotAR
	mov [APressed], 1
	jmp @@endproc
@@NotAR:

	cmp [byte key], 20h ;d
	jnz @@NotD
	mov [DPressed], 0
	jmp @@endproc
@@NotD:

	cmp [byte key], 0a0h
	jnz @@NotDR
	mov [DPressed], 1
	jmp @@endproc
@@NotDR:
	
	cmp [byte key], 048h ;up
	jnz @@NotUp
	mov [UpPressed], 0
	jmp @@endproc
@@NotUp:
	
	cmp [byte key], 0C8h
	jnz @@NotUpR
	mov [UpPressed], 1
	jmp @@endproc
@@NotUpR:

	cmp [byte key], 050h ;down
	jnz @@NotDown
	mov [DownPressed], 0
	jmp @@endproc
@@NotDown:

	cmp [byte key], 0D0h
	jnz @@NotDownR
	mov [DownPressed], 1
	jmp @@endproc
@@NotDownR:

	cmp [byte key], 04Bh ;left
	jnz @@NotLeft
	mov [LeftPressed], 0
	jmp @@endproc
@@NotLeft:

	cmp [byte key], 0CBh
	jnz @@NotLeftR
	mov [LeftPressed], 1
	jmp @@endproc
@@NotLeftR:

	cmp [byte key], 04Dh ;right
	jnz @@NotRight
	mov [RightPressed], 0
	jmp @@endproc
@@NotRight:

	cmp [byte key], 0CDh
	jnz @@NotRightR
	mov [RightPressed], 1
	jmp @@endproc
@@NotRightR:
	
	cmp [byte key], 1h
	jnz @@NotESC
	mov [EscPressed], 0
	jmp @@endproc
@@NotESC:
	
	cmp [byte key], 13h
	jnz @@NotR
	mov [RPressed], 0
	jmp @@endproc
@@NotR:	
	
	cmp [byte key], 39h
	jnz @@NotSpace
	mov [byte SpacePressed], 0
@@NotSpace:

	cmp [byte key], 0b9h
	jnz @@NotSpaceR
	
	mov [byte SpacePressed], 1
@@NotSpaceR:
	
	
	
	
@@endproc:
    pop di
    pop si
    pop bp
    pop sp
    pop dx
    pop cx
    pop bx
    pop ax    
    IRET
endp Keyboard_handler

proc Mouse5
	push cx

@@ClickLoop:
	mov ax,5h
	mov bx,0 ; quary the left b
	int 33h


	cmp bx,00h
	jna @@ClickLoop  ; mouse wasn't pressed
	and ax,0001h
	jz @@ClickLoop   ; left wasn't pressed

	shr cx,1

	CHECK_CLICK 246, 70, 282, 95
	cmp [Click],1
	jne @@NotQuit
	mov [Quit], 0
	jmp @@Clicked
	
@@NotQuit:
	CHECK_CLICK 122, 157, 191, 181
	cmp [Click],1
	jne @@ClickLoop
	mov [EscPressed], 1
	
@@Clicked:
	pop cx
	ret
endp Mouse5



;***********************************************************************************************************************************************************;
;																Room related procs
;***********************************************************************************************************************************************************;


;=======================================================================================
;Description: Define all the room array's cells to 0
;Input: none
;Output: none
;=======================================================================================
proc StartRoom
	mov di, offset map
	mov cx, 25
@@Reset:
	mov [word di], 0
	add di, 2
loop @@Reset	
	
	ret
endp StartRoom

;=======================================================================================
;Description: Generate a room (kind, doors, enemies, status)
;Input: none
;Output: a new room at [word CurrAddress] (which is the map offset + room)
;More info: The room is built like this: A room is 2 bytes, the first nibble is the room kind when each number represents a different room, and the second
;			nibble is the doors, when each bit represents a door (up down left right), then the third nibble is the enemies' layout (like the room kind)
;			and the last nibble is the status for the minimap
;=======================================================================================
proc GenerateRoom
	
	mov [byte RetryMap], 255

	cmp [byte FirstRoom], 1
	je @@NotFirst
	
	;First room
	mov bl, 0
	mov bh, 24
	call RandomByCs
	shl al, 1
	mov [byte Room], al
	
	mov di, offset map
	xor ax, ax
	mov al, [byte Room]
	add di, ax
	
	mov [word CurrAddress], di
	
	or [byte di], 10h
	jmp @@RanDoor
	
@@NotFirst:
	mov di, [word CurrAddress]

	mov al, [byte di]	
	and al, 0F0h
	
	cmp al, 70h
	je @@ExitR
	
	test [byte di+1], 04h
	jnz @@ExitR
	
	cmp al, 60h
	jne @@NotBossR
	
	mov al, 7
	jmp @@SkipRan
	
	@@NotBossR:
	;randomize enemies/items:
	;enemies: 1 - 2 following, 2 - 2 shooting, 3 - 1 following and 1 following+shooting, 4 - 3 following, 5 - 3 shooting, 6 - 2 following+shooting
	;items: 1 - shoot all 8 dirs, 2 - damage up, 3 - piercing, 4 - splitting. 5 - faster shooting rate, 6 - more HP
	mov bl, 1
	mov bh, 6
	call RandomByCs
	
	@@SkipRan:
	shl al, 4
	or [byte di+1], al
	
	jmp @@RanDoor
	
	@@ExitR:
	jmp @@NoRoom
	
@@RanDoor:
	dec [byte RetryMap]
	cmp [byte RetryMap], 0
	jne @@NotYet
	
	jmp @@NoRoom
	@@NotYet:
	;Randomize doors (4 bits, up down left right)
	mov bl, 1
	mov bh, 15
	call RandomByCs
	mov bl, al
	
	;Remove doors that lead to out of bounds
	cmp [byte Room], 8
	ja @@NotRow1
	
	;Row 1
	and bl, 07h ;7 - 0111
	jmp @@NotRow5

@@NotRow1:
	;Row 5
	cmp [byte Room], 40
	jb @@NotRow5
	
	and bl, 0Bh ;B - 1011

@@NotRow5:
	;Coloumn 1
	xor ax, ax
	mov al, [byte Room]
	mov ch, 10
	div ch
	cmp ah, 0
	
	jnz @@NotCol1
	
	and bl, 0Dh ;D - 1101
	jmp @@RemoveIllegal
	
@@NotCol1:
	;Coloumn 5
	xor ax, ax
	mov al, [byte Room]
	sub al, 8
	mov ch, 10
	div ch
	cmp ah, 0
	
	jnz @@RemoveIllegal
	
	and bl, 0Eh ;E - 1110
	;Done removing out of bounds doors
	
	
@@RemoveIllegal:
	;Remove doors that shouldn't be possible to a specific room kind
	mov ah, [byte di]
	and ah, 0F0h
	
	cmp ah, 20h
	jne @@NotHCorr
	
	and bl, 03h ;3 - 0011
	jmp @@NotSpecial
	
@@NotHCorr:
	cmp ah, 30h
	jne @@NotVCorr
	
	and bl, 0Ch ;C - 1100
	jmp @@NotSpecial
	
@@NotVCorr:

	cmp ah, 10h
	je @@NotSpecial
	
	mov bl, [byte di]
	and bl, 0Fh
	jmp @@GenNearby
	
@@NotSpecial:
	;Check if the rooms that have doors for them should exist or not
	test bl, 08h
	jz @@NU
	
	mov al, [byte di-10]
	and al, 0F0h
	cmp al, 70h
	jne @@NU
	
	and bl, 07h ;7 - 0111
	
@@NU:	
	test bl, 04h
	jz @@ND
	
	mov al, [byte di+10]
	and al, 0F0h
	cmp al, 70h
	jne @@ND

	and bl, 0Bh ;B - 1011

@@ND:
	test bl, 02h
	jz @@NL
	
	mov al, [byte di-2]
	and al, 0F0h
	cmp al, 70h
	jne @@NL

	and bl, 0Dh ;D - 1101

@@NL:
	test bl, 01h
	jz @@Check
	
	mov al, [byte di+2]
	and al, 0F0h
	cmp al, 70h
	jne @@Check

	and bl, 0Eh ;E - 1110

@@Check:
	
	cmp [byte RoomCnt], 5
	jbe @@ConCheck
	mov bh, bl
	dec bh
	
	cmp [byte Room], 0
	je @@Only2
	cmp [byte Room], 8
	je @@Only2
	cmp [byte Room], 40
	je @@Only2
	cmp [byte Room], 48
	je @@Only2	
	
	mov dl, [byte di]
	and dl, 0F0h
	cmp dl, 20h
	je @@Only2
	cmp dl, 30h
	je @@Only2
	
	
	and bh, bl
	mov al, bh
	dec al
	and al, bh
	jnz @@ConCheck
	jmp @@RanDoor
	
@@Only2:
	and bh, bl
	jnz @@ConCheck
	jmp @@RanDoor
	
@@ConCheck:
	test bl, 0Fh
	jnz @@GenNearby
	jmp @@RanDoor
	
@@GenNearby:
	mov cl, [byte di]

	or [byte di], bl
	
	;Status (0 - doesn't exist, 1 - haven't been in, 2 - current, 3 - cleared)
	or [byte di + 1], 02h
	mov al, [byte di]
	and al, 0Fh
	
	mov [byte SpecialCheck], 0
	
	mov ah, [byte di-10]
	test ah, 0F0h
	jnz @@NoUp

	test al, 08h
	jnz @@ConUp
	
	or [byte di-10], 70h
	jmp @@NoUp
	
	@@ConUp:
	mov si, di
	sub si, 10
	sub [byte Room], 10
	or [byte si], 04h	
	
	cmp [byte RoomCnt], 0
	ja @@SpawnU

	mov [byte di], cl
	jmp @@NoRoom
	
	@@SpawnU:
	
	cmp [byte RoomCnt], 1
	je @@SkipU
	
	call GenType	
	dec [byte RoomCnt]
	add [byte Room], 10
	jmp @@NoUp
	
	@@SkipU:
	and [byte di-10], 0Fh
	or [byte di-10], 60h
	or [byte di-9], 01h
	mov [byte BossCheck], 1
	dec [byte RoomCnt]
	add [byte Room], 10

@@NoUp:
	
	
	
	mov ah, [byte di+10]
	test ah, 0F0h
	jnz @@NoDown

	test al, 04h
	jnz @@ConDown
	
	or [byte di+10], 70h
	jmp @@NoDown
	
	@@ConDown:
	mov si, di
	add si, 10
	add [byte Room], 10
	or [byte si], 08h	
	
	cmp [byte RoomCnt], 0
	ja @@SpawnD

	mov [byte di], cl
	jmp @@NoRoom
	
	@@SpawnD:
	
	cmp [byte RoomCnt], 1
	je @@SkipD
	
	call GenType	
	dec [byte RoomCnt]
	sub [byte Room], 10
	jmp @@NoDown
	
	@@SkipD:
	and [byte di+10], 0Fh
	or [byte di+10], 60h
	or [byte di+11], 01h
	mov [byte BossCheck], 1
	dec [byte RoomCnt]
	sub [byte Room], 10

@@NoDown:

	
	
	mov ah, [byte di-2]
	test ah, 0F0h
	jnz @@NoLeft
	
	mov al, [byte di]
	and al, 0Fh
	
	test al, 02h
	jnz @@ConLeft
	
	or [byte di-2], 70h
	jmp @@NoLeft
	
	@@ConLeft:
	mov si, di
	sub si, 2
	sub [byte Room], 2
	
	or [byte si], 01h

	cmp [byte RoomCnt], 0
	ja @@SpawnL

	mov [byte di], cl
	jmp @@NoRoom
	
	@@SpawnL:
	
	cmp [byte RoomCnt], 1
	je @@SkipL
	
	call GenType	
	dec [byte RoomCnt]
	add [byte Room], 2
	jmp @@NoLeft
	
	@@SkipL:
	and [byte di-2], 0Fh
	or [byte di-2], 60h
	or [byte di-1], 01h
	mov [byte BossCheck], 1
	dec [byte RoomCnt]
	add [byte Room], 2
	
@@NoLeft:
	
	
	
	mov ah, [byte di+2]
	test ah, 0F0h
	jnz @@NoRoom
	
	mov al, [byte di]
	and al, 0Fh
	
	test al, 01h
	jnz @@ConRight
	
	or [byte di+2], 70h
	jmp @@NoRoom
	
	@@ConRight:
	mov si, di
	add si, 2
	add [byte Room], 2
	
	or [byte si], 02h
	
	cmp [byte RoomCnt], 0
	ja @@SpawnR

	mov [byte di], cl
	jmp @@NoRoom
	
	@@SpawnR:

	cmp [byte RoomCnt], 1
	je @@SkipR
	
	call GenType	
	dec [byte RoomCnt]
	sub [byte Room], 2
	jmp @@NoRoom
	
	@@SkipR:
	and [byte di+2], 0Fh
	or [byte di+2], 60h
	or [byte di+3], 01h
	
	mov [byte BossCheck], 1
	dec [byte RoomCnt]
	sub [byte Room], 2
	
@@NoRoom:
	mov [byte FirstRoom], 1
	
	ret
endp GenerateRoom

;si - room offset
proc GenType
	PUSH_ALL
	
	
@@ag:
	;Room kind (1 - normal, 2 - horizontal corridor, 3 - vertical corridor, 4 - item room, 5 - shop, 6 - boss, 7 - doesn't exist, 8 - yet to exist)
	mov bl, 1
	mov bh, 6
	call RandomByCs
	
	;Check if there were doors before, if there were and the room type isn't good for the doors then reroll the room type
	cmp al, 1
	jne @@NotR1
	jmp @@OkayRoom
	
@@NotR1: ;Check horizontal corridor
	mov ah, [byte si]
	and ah, 0Fh
	
	cmp al, 2
	jne @@NotR2
	
	push ax
	
	;Coloumn 1
	xor ax, ax
	mov al, [byte Room]
	mov ch, 10
	div ch
	cmp ah, 0
	
	jnz @@NotCol1
	
	pop ax
	jmp @@ag
	
@@NotCol1:
	;Coloumn 5
	xor ax, ax
	mov al, [byte Room]
	sub al, 8
	mov ch, 10
	div ch
	cmp ah, 0
	
	jnz @@ConR2
	
	pop ax
	jmp @@ag
	
	@@ConR2:
	
	pop ax
	test ah, 0Ch
	jz @@OkayRoom
	jmp @@ag


@@NotR2: ;Check vertical corridor
	cmp al, 3
	jne @@NotR3
	
	;Row 1
	cmp [byte Room], 8
	ja @@NotRow1
	
	jmp @@ag

@@NotRow1:
	;Row 5
	cmp [byte Room], 40
	jb @@NotRow5
	
	jmp @@ag

@@NotRow5:
	
	test ah, 03h
	jz @@OkayRoom
	jmp @@ag
	
@@NotR3: ;Check special rooms
	cmp al, 6
	jne @@NotR6

	cmp [byte FirstRoom], 0
	jne @@NotR6

	jmp @@ag

@@NotR6:
	
	mov [byte HasDoor], 0
	
	test ah, 08h
	jz @@SpecialU
	inc [byte HasDoor]
	
	@@SpecialU:
	test ah, 04h
	jz @@SpecialD
	inc [byte HasDoor]
	
	@@SpecialD:
	test ah, 02h
	jz @@SpecialL
	inc [byte HasDoor]
	
	@@SpecialL:
	test ah, 01h
	jz @@SpecialR
	inc [byte HasDoor]
	
	@@SpecialR:
	cmp [byte HasDoor], 1
	je @@OkayRoom
	jmp @@ag
	
@@OkayRoom:
	
	;I'll check if the special rooms were already spawned
	cmp al, 4
	jne @@NotItem4
	
	cmp [byte ItemCheck], 0
	je @@ConItem
	jmp @@ag

	@@ConItem:
	cmp [byte SpecialCheck], 0
	je @@YesItem
	jmp @@ag
	
	@@YesItem:
	mov [byte ItemCheck], 1
	mov [byte SpecialCheck], 1
	jmp @@NotBoss6
	
@@NotItem4:
	cmp al, 5
	jne @@NotShop5
	
	cmp [byte ShopCheck], 0
	je @@ConShop
	jmp @@ag

	@@ConShop:
	cmp [byte SpecialCheck], 0
	je @@YesShop
	jmp @@ag
	
	@@YesShop:
	mov [byte ShopCheck], 1
	mov [byte SpecialCheck], 1
	jmp @@NotBoss6
	
@@NotShop5:
	
	cmp al, 6
	jne @@NotBoss6
	
	cmp [byte BossCheck], 0
	je @@ConBoss
	jmp @@ag

	@@ConBoss:
	mov [byte BossCheck], 1
	mov [byte SpecialCheck], 1
	
@@NotBoss6:

	shl al, 4
	or [byte si], al
	
	or [byte si+1], 01h

@@Exit:
	POP_ALL
	ret
endp GenType

;=======================================================================================
;Description: Check if a player touched a door, and if he does - move to the next room
;Input: none
;Output: none
;=======================================================================================
proc MoveRoom
	;mov cx, 11h
	
	cmp [byte CurrEnemies], 0
	je @@CanMove
	jmp @@No
	
@@CanMove:
	mov di, [word CurrAddress]
	
	mov al, [byte di]
	and al, 0Fh
	mov ah, [byte di]
	and ah, 0F0h
	
	;First I check if I even need to check for vertical moving (up/down)
	cmp [word PLeft], 152
	jae @@VCon1
	jmp @@PreL

@@VCon1:
	cmp [word PLeft], 157
	jbe @@VCon2
	jmp @@PreL
	
@@VCon2:
	;I see if there's a door up
	test al, 08h
	jz @@NoU
	
	;Room 2 has different y positions for doors
	cmp ah, 20h
	jne @@ConU
	jmp @@NoD
	
@@ConU:
	cmp [word PTop], 22
	ja @@NoU
	
	cmp [VMove], 0
	je @@YesU
	jmp @@No
	
@@YesU:

	mov [word PTop], 163
	mov [word PLeft], 152
	
	and [byte di+1], 0F4h ;
	or [byte di+1], 07h ;Prev room was spawned (4h) + visited (3h)
	
	sub [byte Room], 10
	sub [word CurrAddress], 10
	
	mov di, [word CurrAddress]
	and [byte di+1], 0F4h
	or [byte di+1], 02h
	mov [VMove], 1
	
	jmp @@Move
	
	
@@NoU:

	;I see if there's a door down
	test al, 04h
	jz @@NoD
	
	;Room 2 has different y positions for doors
	cmp ah, 20h
	je @@NoD
	
	cmp [word PTop], 158
	jb @@PreL
	
	cmp [VMove], 0
	je @@YesD
	jmp @@No
	
@@YesD:
	mov [word PTop], 18
	mov [word PLeft], 152

	and [byte di+1], 0F4h ;
	or [byte di+1], 07h ;Prev room was spawned (4h) + visited (3h)

	add [byte Room], 10
	add [word CurrAddress], 10
	
	mov di, [word CurrAddress]
	and [byte di+1], 0F4h
	or [byte di+1], 02h
	mov [VMove], 1

	jmp @@Move
	
@@PreL:
	cmp [word PTop], 22
	jbe @@NoD
	cmp [word PTop], 178
	jae @@NoD
	mov [VMove], 0
	
@@NoD:
	
	;Now I'll check if I even need to check for horizontal moving (left/right)
	cmp [word PTop], 84
	jae @@HCon1
	jmp @@PreNo

@@HCon1:
	cmp [word PTop], 89
	jbe @@HCon2
	jmp @@PreNo

@@HCon2:
	;I see if there's a door left
	test al, 02h
	jz @@NoL
	
	;Room 3 has different X positions for doors
	cmp ah, 30h
	jne @@ConL
	jmp @@No

@@ConL:
	cmp [word PLeft], 22
	ja @@NoL
	
	cmp [HMove], 0
	je @@YesL
	jmp @@No
	
@@YesL:
	
	mov [word PTop], 84
	mov [word PLeft], 282
	
	and [byte di+1], 0F4h ;
	or [byte di+1], 07h ;Prev room was spawned (4h) + visited (3h)
	
	sub [byte Room], 2
	sub [word CurrAddress], 2
	
	mov di, [word CurrAddress]
	and [byte di+1], 0F4h
	or [byte di+1], 02h
	mov [HMove], 1
	
	jmp @@Move
	
	
@@NoL:
	
	;In case I changed ax
	mov al, [byte di]
	and al, 0Fh
	mov ah, [byte di]
	and ah, 0F0h
	
	;I see if there's a door right
	test al, 01h
	jz @@No

	;Room 3 has different X positions for doors
	cmp ah, 30h
	je @@No

	cmp [word PLeft], 278
	jb @@PreNo
	
	cmp [HMove], 0
	je @@YesR
	jmp @@No
	
@@YesR:
	mov [word PTop], 84
	mov [word PLeft], 18
	
	and [byte di+1], 0F4h ;
	or [byte di+1], 07h ;Prev room was spawned (4h) + visited (3h)
	
	add [byte Room], 2
	add [word CurrAddress], 2
	
	mov di, [word CurrAddress]
	and [byte di+1], 0F4h
	or [byte di+1], 02h
	mov [HMove], 1
	
@@Move:
	call DeleteAllET
	call DeleteAllT
	mov [Moved], 1
	jmp @@No
	
@@PreNo:
	cmp [word PLeft], 22
	jbe @@No
	cmp [word PLeft], 278
	jae @@No
	mov [HMove], 0
	
@@No:
	
	ret
endp MoveRoom

;=======================================================================================
;Description: Check what enemy layout should be generated, and spawn enemies (if they weren't spawned before)
;Input: none
;Output: none
;=======================================================================================
proc SpawnEnemies
	mov di, [word CurrAddress]

	mov al, [byte di+1]
	test al, 04h
	jnz @@out
	
	shr al, 4
	
	mov bx, offset EArray
	
	mov cx, 4
@@Check:
	cmp [word bx], 0
	jne @@Out
	
	add bx, EnemySize
	
loop @@Check
	
	mov bx, offset EArray	
	jmp @@Add
	
@@Out:
	jmp @@Exit2
	
@@Add:
	
	mov al, [byte di+1]
	shr al, 4
	
	cmp al, 0
	jne @@Not0
	jmp @@Exit2
	
@@Not0:
	;1 - 2 following
	cmp al, 1
	jne @@Not1
	
	mov [word bx], 60 ;Y
	mov [word bx+2], 80 ;X
	mov [byte bx+4], 15 ;HP
	mov [byte bx+5], 1 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 130 ;Y
	mov [word bx+2], 230 ;X
	mov [byte bx+4], 15 ;HP
	mov [byte bx+5], 1 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	mov [byte CurrEnemies], 2
	jmp @@Exit2
	
@@Not1:
	;2 - 2 shooting
	cmp al, 2
	jne @@Not2
	
	mov [word bx], 60 ;Y
	mov [word bx+2], 80 ;X
	mov [byte bx+4], 12 ;HP
	mov [byte bx+5], 2 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 130 ;Y
	mov [word bx+2], 230 ;X
	mov [byte bx+4], 12 ;HP
	mov [byte bx+5], 2 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	mov [byte CurrEnemies], 2
	jmp @@Exit2
	
@@Not2:
	;3 - 1 following and 1 both
	cmp al, 3
	jne @@Not3
	
	mov [word bx], 60 ;Y
	mov [word bx+2], 80 ;X
	mov [byte bx+4], 15 ;HP
	mov [byte bx+5], 1 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 130 ;Y
	mov [word bx+2], 230 ;X
	mov [byte bx+4], 9 ;HP
	mov [byte bx+5], 3 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	mov [byte CurrEnemies], 2

	jmp @@Exit2
	
@@Not3:
	;4 - 3 following
	cmp al, 4
	jne @@Not4
	
	mov [word bx], 53 ;Y
	mov [word bx+2], 70 ;X
	mov [byte bx+4], 15 ;HP
	mov [byte bx+5], 1 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 53 ;Y
	mov [word bx+2], 232 ;X
	mov [byte bx+4], 15 ;HP
	mov [byte bx+5], 1 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 110 ;Y
	mov [word bx+2], 150 ;X
	mov [byte bx+4], 15 ;HP
	mov [byte bx+5], 1 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	mov [byte CurrEnemies], 3
	
	jmp @@Exit2
	
@@Not4:
	;5 - 3 shooting
	cmp al, 5
	jne @@Not5
	
	mov [word bx], 125 ;Y
	mov [word bx+2], 75 ;X
	mov [byte bx+4], 12 ;HP
	mov [byte bx+5], 2 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 60 ;Y
	mov [word bx+2], 150 ;X
	mov [byte bx+4], 12 ;HP
	mov [byte bx+5], 2 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 100 ;Y
	mov [word bx+2], 215 ;X
	mov [byte bx+4], 12 ;HP
	mov [byte bx+5], 2 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	mov [byte CurrEnemies], 3

	jmp @@Exit2
	
@@Not5:
	;6 - 2 both
	cmp al, 6
	jne @@Not6
	
	mov [word bx], 95 ;Y
	mov [word bx+2], 100 ;X
	mov [byte bx+4], 9 ;HP
	mov [byte bx+5], 3 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	add bx, EnemySize
	
	mov [word bx], 85 ;Y
	mov [word bx+2], 200 ;X
	mov [byte bx+4], 9 ;HP
	mov [byte bx+5], 3 ;TYPE
	mov [word bx+21], ECOOLDOWN
	
	mov [byte CurrEnemies], 2
	jmp @@Exit2
	
@@Not6:
	;7 - boss
	cmp al, 7
	jne @@Exit
	
	mov bx, offset Boss
	mov [word bx], 76 ;Y
	mov [word bx+2], 136 ;X
	mov [byte bx+4], 90 ;HP
	mov [byte bx+5], 3 ;TYPE
	mov [word bx+21], 20
	
	mov [byte CurrEnemies], 1
	jmp @@Exit2
	
@@Exit:
	mov [byte CurrEnemies], 0

@@Exit2:
	
	ret
endp SpawnEnemies


proc GetItem
	mov di, [word CurrAddress]
	
	mov al, [byte di+1]
	and al, 0F0h
	jnz @@Con
	jmp @@Exit
	
	@@Con:
	cmp [word PTop], 72
	jnb @@ok1
	jmp @@Exit
	
@@ok1:
	cmp [word PTop], 108
	jna @@ok2
	jmp @@Exit

@@ok2:
	cmp [word PLeft], 137  
	jnb @@ok3
	jmp @@Exit
	
@@ok3:
	cmp [word PLeft], 193
	jna @@ok4
	jmp @@Exit
	
@@ok4:
	
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 40h
	je @@Item
	cmp al, 50h
	je @@Shop
	jmp @@Exit

	@@Shop:
	mov dl, [byte PriceDec]
	cmp [byte MoneyDec], dl
	jb @@Exit

	sub [byte MoneyDec], dl
	
	@@Item:

	mov al, [byte di+1]
	and al, 0F0h
	shr al, 4
	
	cmp al, 1
	jne @@NotAnalog
	mov [byte Dir8], 1
	jmp @@Done
	
@@NotAnalog:
	cmp al, 2
	jne @@NotPentagram
	add [byte DmgDec], 3
	
	call UpdateHex
	jmp @@Done
	
@@NotPentagram:
	cmp al, 3
	jne @@NotCupid
	mov [byte Piercing], 1
	jmp @@Done
	
@@NotCupid:
	cmp al, 4
	jne @@NotCricket
	mov [byte Splitting], 1
	jmp @@Done	
	
@@NotCricket:
	cmp al, 5
	jne @@NotSadOnion
	mov [byte Fast], 1
	jmp @@Done	
	
@@NotSadOnion:
	cmp al, 6
	jne @@Exit
	add [byte PMHealth], 2
	add [byte PCHealth], 2

	
	
@@Done:
	and [byte di+1], 0Fh
	call UndrawItem	

	call DrawHUD
@@Exit:
	ret
endp GetItem


proc UpdateHex
	PUSH_ALL
	
	xor ax, ax
	mov al, [byte MoneyDec]
	mov bh, 10
	div bh
	
	add al, '0'
	add ah, '0'
	
	mov [byte MoneyHex], al
	mov [byte MoneyHex+1], ah

	xor ax, ax
	mov al, [byte DmgDec]
	mov bh, 10
	div bh
	
	add al, '0'
	add ah, '0'
	
	mov [byte DmgHex], al
	mov [byte DmgHex+1], ah

	POP_ALL
	ret
endp UpdateHex



;***********************************************************************************************************************************************************;
;																Drawing related procs
;***********************************************************************************************************************************************************;



;=======================================================================================
;Description: Draw a background image, all background images are 320x200
;Input: dx - image offset
;Output: none
;=======================================================================================
proc DrawBg

	mov [BmpTop], 0
	mov [BmpLeft], 0
	mov [BmpWidth], 320
	mov [BmpHeight], 200
	call OpenShowBmp

	ret
endp DrawBg

;=======================================================================================
;Description: Draw a character image, all character images are 18x18
;Input: dx - image offset, bp+6 - y of character, bp+4 - x of character
;Output: none
;=======================================================================================
proc DrawC
	push bp
	mov bp, sp

	mov ax, [bp+6]
	cmp ax, 0
	je @@Skip
	
	mov [BmpTop], ax
	mov ax, [bp+4]
	mov [BmpLeft], ax
	mov [BmpWidth], C_BMP_WIDTH
	mov [BmpHeight] ,C_BMP_HEIGHT
	call OpenShowBmp

@@Skip:
	pop bp
	ret 4
endp DrawC


proc DrawBoss
	push bp
	mov bp, sp

	mov ax, [bp+6]
	cmp ax, 0
	je @@Skip
	
	mov dx, offset BossPic
	mov [BmpTop], ax
	mov ax, [bp+4]
	mov [BmpLeft], ax
	mov [BmpWidth], 24
	mov [BmpHeight], 24
	call OpenShowBmp

@@Skip:
	pop bp
	ret 4
endp DrawBoss

;=======================================================================================
;Description: Draw the current room based on kind
;Input: none
;Output: none
;=======================================================================================
proc DrawRoom
	mov di, [word CurrAddress]
	
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 10h
	je @@R1
	cmp al, 60h
	jne @@NotR1
	
@@R1:
	mov dx, offset R1Pic
	jmp @@Show
	
@@NotR1:
	cmp al, 20h
	jne @@NotR2
	mov dx, offset R2Pic
	jmp @@Show
	
@@NotR2:
	cmp al, 30h
	jne @@NotR3
	mov dx, offset R3Pic
	jmp @@Show
	
@@NotR3:
	cmp al, 50h
	ja @@Error
	
	mov dx, offset R1Pic
	call DrawBg
	
	jmp @@Exit
	
@@Error:
	mov dx, offset ErrorPic
	
@@Show:
	call DrawBg
	call SpawnEnemies

@@Exit:
	
	ret
endp DrawRoom

;=======================================================================================
;Description: Draw all the current room's doors
;Input: none
;Output: none
;=======================================================================================
proc DrawDoors
	mov di, [word CurrAddress]
	
	mov al, [byte di]
	and al, 0Fh
	
	mov ah, [byte di]
	and ah, 0F0h
	
	mov [word BmpLeft], 152
	mov [word BmpWidth], 25
	mov [word BmpHeight], 17
	
	test al, 08h
	jz @@NotUD
	
	mov [word BmpTop], 1

	cmp ah, 20h
	jne @@Not2U
	add [word BmpTop], 33
	
@@Not2U:
	mov dx, offset HDPic
	push ax
	call OpenShowBmp
	pop ax
	
	
@@NotUD:
	test al, 04h
	jz @@NotDD
	
	mov [word BmpTop], 183

	cmp ah, 20h
	jne @@Not2D
	sub [word BmpTop], 32
	
@@Not2D:
	mov dx, offset HDPic
	add dx, 10
	push ax
	call OpenShowBmp
	pop ax	
	
	
@@NotDD:
	mov [word BmpTop], 84
	mov [word BmpWidth], 17
	mov [word BmpHeight], 25
	
	test al, 02h
	jz @@NotLD

	mov [word BmpLeft], 1

	cmp ah, 30h
	jne @@Not3L
	add [word BmpLeft], 50
	
@@Not3L:
	mov dx, offset VDPic 
	push ax
	call OpenShowBmp
	pop ax


@@NotLD:
	test al, 01h
	jz @@NotRD

	mov [word BmpLeft], 303

	cmp ah, 30h
	jne @@Not3R
	sub [word BmpLeft], 50
	
@@Not3R:
	mov dx, offset VDPic
	add dx, 10
	push ax
	call OpenShowBmp
	pop ax

@@NotRD:
	ret
endp DrawDoors

;=======================================================================================
;Description: Draw all the HUD (Heads Up Display) for the player (meaning hearts, coins, damage, and the minimap)
;Input: none
;Output: none
;=======================================================================================
proc DrawHUD
	PUSH_ALL
	
	mov [BmpLeft], 15
	mov [BmpTop], 0
	mov [BmpWidth], 15
	mov [BmpHeight], 15
	
	push cx
	push si
	push di
	
	mov cx, 32
	mov dx, 0
	mov al, 0
	mov si, 15
	mov di, 70
	call Rect
	
	pop di
	pop si
	pop cx
	
	
	xor cx, cx
	mov cl, [byte PCHealth]
	shr cl, 1
@@Lp:
	cmp cx, 0
	je @@Exit
	
	add [BmpLeft], 18
	mov dx, offset FullH
	
	call OpenShowBmp	
	
	dec cx
jmp @@Lp
	
@@Exit:
	xor ax, ax
	mov al, [byte PCHealth]
	shr al, 1
	jnc @@Skip
	
	mov [BmpWidth], 8
	add [BmpLeft], 18
	mov dx, offset HalfH
	
	call OpenShowBmp	
	
@@Skip:
	mov [BmpTop], 13
	mov [BmpLeft], 3
	mov [BmpWidth], 9
	mov [BmpHeight], 13
	mov dx, offset CoinsPic
	call OpenShowBmp

	mov [BmpTop], 30
	mov dx, offset DmgPic
	call OpenShowBmp

	push bp
	push es
	
	push ds
	pop es
	
	mov ah, 13h
	mov bp, offset MoneyHex
	mov dx, 0202h
	mov cx, 2
	mov al, 1
	mov bh, 0
	mov bl, 6
	int 10h

	mov bp, offset DmgHex
	mov dx, 0402h
	mov cx, 2
	int 10h
	
	pop es
	pop bp
	
	call DrawMiniMap

	cmp [word Boss], 0
	je @@NotBoss
	
	push cx
	push si
	push di
	
	mov cx, 69
	mov dx, 183
	mov al, 0
	mov si, 17
	mov di, 182
	call Rect
	
	pop di
	pop si
	pop cx
	
	xor cx, cx
	mov cl, [byte Boss+4]
	cmp cl, 0
	jng @@NotBoss
	
	mov bx, 70
	
@@HpBar:
	push cx
	
	mov cx, bx
	mov dx, 184
	mov al, 04Fh
	mov si, 15
	mov di, 2
	call Rect
	
	pop cx
	add bx, 2
loop @@HpBar
	
	@@NotBoss:
	
	POP_ALL
	

	ret
endp DrawHUD

;=======================================================================================
;Description: Draw the mini map in the upper right corner
;Input: none
;Output: none
;=======================================================================================
proc DrawMiniMap
	push cx
	push dx
	push si
	push di
	
	;Layout for minimap
	mov cx, 279
	mov dx, 0
	mov al, 0FFh
	mov si, 41
	mov di, 41
	call Rect
	
	mov [BmpWidth], 9
	mov [BmpHeight], 9
	
	mov di, offset map
	add di, 48
	mov cx, 5
	
@@Row:
	push cx
	dec cx
	shl cx, 3
	mov [BmpTop], cx
	
	mov cx, 5

	@@Col:
		mov al, [byte di]
		and al, 0F0h
		
		cmp al, 10h
		jne @@NotR1
		mov dx, offset R1MSPic
		jmp @@Status
		
	@@NotR1:
		cmp al, 20h
		jne @@NotR2
		mov dx, offset R2MSPic
		jmp @@Status
		
	@@NotR2:
		cmp al, 30h
		jne @@NotR3
		mov dx, offset R3MSPic
		jmp @@Status
		
	@@NotR3:
		cmp al, 70h
		jae @@Skip
		mov dx, offset R1MSPic
		
	@@Status:
		mov [BmpLeft], cx
		dec [BmpLeft]
		shl [BmpLeft], 3
		add [BmpLeft], 279
	
		call DrawMiniRoom
	@@Skip:

		sub di, 2
	loop @@Col

	pop cx
loop @@Row
		
	pop di
	pop si
	pop dx
	pop cx
	ret
endp DrawMiniMap

;=======================================================================================
;Description: Draw a room in the mini map based on kind and status
;Input: none
;Output: none
;=======================================================================================
proc DrawMiniRoom
	push cx
	push ax
	push di
	
	mov al, [byte di + 1]
	and al, 3
	
	cmp al, 0
	jnz @@Con
	jmp @@Done
	
	@@Con:
	cmp al, 1
	jnz @@NotS1
	jmp @@Show
	
@@NotS1:
	cmp al, 2
	jnz @@NotS2
	add dx, 9
	jmp @@Show

@@NotS2:
	cmp al, 3
	jz @@ConS3
	jmp @@Done
	
	@@ConS3:
	add dx, 18
	
@@Show:
	
	push di
	call OpenShowBmp
	pop di
	
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 40h
	jb @@Done
	
	mov dx, offset SpecialRooms
	push [BmpTop]
	push [BmpLeft]
	push [BmpWidth]
	push [BmpHeight]
	
	jne @@NotItem
	add [BmpTop], 3
	add [BmpLeft], 2
	mov [BmpWidth], 5
	mov [BmpHeight], 3
	jmp @@ShowSpecial
	
@@NotItem:
	cmp al, 50h
	jne @@NotShop
	
	add dx, 13
	add [BmpTop], 2
	add [BmpLeft], 3
	mov [BmpWidth], 3
	mov [BmpHeight], 5
	jmp @@ShowSpecial
	
@@NotShop:
	cmp al, 60h
	jne @@PopBMP
	
	add dx, 22
	add [BmpTop], 3
	add [BmpLeft], 3
	mov [BmpWidth], 3
	mov [BmpHeight], 3
	
	
@@ShowSpecial:
	call OpenShowBmp
	
@@PopBMP:
	pop [BmpHeight]
	pop [BmpWidth]
	pop [BmpLeft]
	pop [BmpTop]
	
@@Done:
	pop di
	pop ax
	pop cx
	ret
endp DrawMiniRoom

proc DrawItem
	mov di, [word CurrAddress]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 40h
	je @@ItemOrShop
	cmp al, 50h
	je @@ItemOrShop
	jmp @@Skip
	
@@ItemOrShop:
	mov al, [byte di+1]
	and al, 0F0h
	shr al, 4
	
	cmp al, 0
	jne @@ItemExists
	jmp @@Skip
	
@@ItemExists:
	cmp al, 1
	jne @@NotAnalog
	mov dx, offset AnalogPic
	jmp @@Show
	
@@NotAnalog:
	cmp al, 2
	jne @@NotPentagram
	mov dx, offset PentagramPic
	jmp @@Show
	
@@NotPentagram:
	cmp al, 3
	jne @@NotCupid
	mov dx, offset CupidPic
	jmp @@Show
	
@@NotCupid:
	cmp al, 4
	jne @@NotCricket
	mov dx, offset WedgePic
	jmp @@Show	
	
@@NotCricket:
	cmp al, 5
	jne @@NotSadOnion
	mov dx, offset SadOnionPic
	jmp @@Show	
	
@@NotSadOnion:
	cmp al, 6
	jne @@Skip
	mov dx, offset DinnerPic

@@Show:
	
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 50h
	jne @@Item
	
	push dx
	
	mov [byte PriceDec], 5
	
	xor ax, ax
	mov al, [byte PriceDec]
	mov bh, 10
	div bh
	
	add al, '0'
	add ah, '0'
	
	mov [byte PriceHex+1], al
	mov [byte PriceHex+2], ah
	
	push bp
	push es
	
	push ds
	pop es
	
	mov ah, 13h
	mov bp, offset PriceHex
	mov dx, 0913h
	mov cx, 3
	mov al, 1
	mov bh, 0
	mov bl, 6
	int 10h
	
	pop es
	pop bp
	
	pop dx
	
	@@Item:
	mov [BmpTop], 90
	mov [BmpLeft], 155
	mov [BmpWidth], 20
	mov [BmpHeight], 20
	call OpenShowBmp

@@Skip:
	ret
endp DrawItem

proc UndrawItem
	push cx
	push si
	push di
	
	mov dx, 90 ;Top
	mov cx, 155 ;Left
	mov al, 7
	mov si, 20
	mov di, 20
	call Rect
	
	pop di
	pop si
	pop cx	
	
	ret
endp UndrawItem



;***********************************************************************************************************************************************************;
;																Player related procs
;***********************************************************************************************************************************************************;



;=======================================================================================
;Description: Check what buttons are pressed and move accordingly
;Input: none
;Output: none
;=======================================================================================
proc MoveP
	push ax
	
	cmp [word Invin], 0
	je @@Con
	dec [word Invin]
	
	@@Con:
	cmp [WPressed], 0
	jnz @@NoW 
	push offset PTop
	call CMoveUp
	
@@NoW:	
	cmp [DPressed], 0
	jnz @@NoD
	push offset PLeft
	call CMoveRight
	
@@NoD:
	cmp [SPressed], 0
	jnz @@NoS
	push offset PTop
	call CMoveDown
	
@@NoS:
	cmp [APressed], 0
	jnz @@ex
	push offset PLeft
	call CMoveLeft
	
@@ex:
	
	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset Boss
	mov cx, 1
	jmp @@Lp
	
	@@NotBoss:
	mov bx, offset EArray
	mov cx, 4
	@@Lp:
		push cx
		
		cmp [word bx], 0
		je @@Add
		
		mov ax, [word bx+2]
		mov [word point1X], ax
		mov ax, [word bx]
		mov [word point1Y], ax
		
		mov ax, [word PLeft]
		mov [word point2X], ax
		mov ax, [word PTop]
		mov [word point2Y], ax
	
		call CalcEnemyPath
		
		@@Add:
		add bx, EnemySize
		
		pop cx
	loop @@Lp
	
	cmp [byte BossDie], 1
	jne @@Skip
	
	cmp [word PTop], 85
	jb @@Skip
	cmp [word PTop], 115
	ja @@Skip
	cmp [word PLeft], 145
	jb @@Skip
	cmp [word PLeft], 175
	ja @@Skip
	
	mov [byte Quit], 0

@@Skip:
	pop ax
	ret
endp MoveP

proc CMoveUp
	push bp
	mov bp, sp
	push bx
	
	mov di, [word CurrAddress]	
	
	mov bx, [word bp+4]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 20h
	jz @@R2
	cmp [word bx], 18
	ja @@Sub
	jmp @@Skip
	
@@R2:
	cmp [word bx], 51
	jbe @@Skip
	
	
@@Sub:
	sub [word bx], 1

@@Skip:
	pop bx
	pop bp
	ret 2
endp CMoveUp

proc CMoveRight
	push bp
	mov bp, sp
	push bx
	
	mov di, [word CurrAddress]	

	mov bx, [word bp+4]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 30h
	jz @@R3
	cmp [word bx], 282
	jb @@Add
	jmp @@Skip
	
@@R3:
	cmp [word bx], 232
	jae @@Skip
	
@@Add:
	add [word bx], 1
	
@@Skip:
	pop bx
	pop bp
	ret 2
endp CMoveRight

proc CMoveDown
	push bp
	mov bp, sp
	push bx
	
	mov di, [word CurrAddress]
	
	mov bx, [word bp+4]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 20h
	jz @@R2
	cmp [word bx], 163
	jb @@Add
	jmp @@Skip
	
@@R2:
	cmp [word bx], 130
	jae @@Skip
	
@@Add:
	add [word bx], 1

@@Skip:
	pop bx
	pop bp
	ret 2
endp CMoveDown

proc CMoveLeft
	push bp
	mov bp, sp
	push bx
	
	mov di, [word CurrAddress]	

	mov bx, [word bp+4]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 30h
	jz @@R3
	cmp [word bx], 18
	ja @@Sub
	jmp @@Skip
	
@@R3:
	cmp [word bx], 68
	jbe @@Skip
	
@@Sub:
	sub [word bx], 1
	
@@Skip:
	pop bx
	pop bp
	ret 2
endp CMoveLeft

;=======================================================================================
;Description: Add a tear to the player's tear array if the cooldown is finished and a button was pressed
;Input: none
;Output: a tear in the empty cell
;=======================================================================================
proc AddT
	push bx
	push cx
	push si

	cmp [word TearCD], 0
	jz @@Try
	dec [word TearCD]
	jmp @@ex
	
@@Try:

	mov bx, offset TArray
	mov si, 0
	mov cx, 10
	
	
@@Lp1:
	mov ax, [word bx+si]
	cmp ax, 0
	je @@yes
	
	add si, PlayerTearSize
loop @@Lp1
	
	jmp @@ex	
@@yes:

	cmp [byte Dir8], 1
	jne @@Not8
	
	mov al, [UpPressed]
	or al, [RightPressed]
	jnz @@Not2
	mov [byte TDir], 2
	jmp @@PlayerShot
	
@@Not2:
	mov al, [RightPressed]
	or al, [DownPressed]
	jnz @@Not4
	mov [byte TDir], 4
	jmp @@PlayerShot
	
@@Not4:	
	mov al, [DownPressed]
	or al, [LeftPressed]
	jnz @@Not6
	mov [byte TDir], 6
	jmp @@PlayerShot	

@@Not6:
	mov al, [LeftPressed]
	or al, [UpPressed]
	jnz @@Not8
	mov [byte TDir], 8
	jmp @@PlayerShot
	
@@Not8:
	cmp [UpPressed], 0
	jnz @@Not1
	mov [byte TDir], 1
	jmp @@PlayerShot
	
@@Not1:
	cmp [RightPressed], 0
	jnz @@Not3
	mov [byte TDir], 3
	jmp @@PlayerShot
	
@@Not3:
	cmp [DownPressed], 0
	jnz @@Not5
	mov [byte TDir], 5
	jmp @@PlayerShot

@@Not5:
	cmp [LeftPressed], 0
	jnz @@Not7
	mov [byte TDir], 7
	jmp @@PlayerShot
	
@@Not7:
	cmp [byte TDir], 0
	je @@ex
	jmp @@Shoot
	
	
@@PlayerShot:
	cmp [byte Splitting], 1
	jne @@Shoot
	
	or [byte bx+si+4], 80h
	
@@Shoot:
	
	mov ax, [word PTop]
	mov [word bx+si], ax ;Tear Top
	mov ax, [word PLeft]
	mov [word bx+si+2], ax ;Tear Left
	mov al, [byte TDir]
	or [byte bx+si+4], al ;Tear Direction
	
	
	
@@Skip:
	add [word bx+si], 4
	add [word bx+si+2], 4
	
	mov [word TearCD], COOLDOWN
	cmp [byte Fast], 1
	jne @@ex
	sub [word TearCD], 50
@@ex:
	pop si
	pop cx
	pop bx

	mov [byte TDir], 0
	
	ret
endp AddT

;=======================================================================================
;Description: Delete one of the player's tears
;Input: bx - offset of tear array, si - i of the array
;Output: none
;=======================================================================================
proc DeleteT
	push cx
	push si
	
	mov dx, [word bx+si] ;Tear Top
	mov cx, [word bx+si+2] ;Tear Left
	mov al, 7
	mov si, 10
	mov di, 10
	call Rect
	
	pop si
	pop cx
	
	mov [word bx+si], 0
	mov [word bx+si+2], 0
	mov [byte bx+si+4], 0
	
	ret
endp DeleteT

;=======================================================================================
;Description: Delete all player tears
;Input: none
;Output: none
;=======================================================================================
proc DeleteAllT
	push bx
	push si
	push cx
	
	mov bx, offset TArray
	mov si, 0
	mov cx, 25

@@Lp:
	mov [word bx+si], 0
	add si, 2
loop @@Lp

	pop cx
	pop si
	pop bx
endp DeleteAllT

;=======================================================================================
;Description: Go through the player's tear array and draw all existing tears
;Input: none
;Output: none
;=======================================================================================
proc DrawT
	push bx
	push si
	push cx
	push dx
	
	mov bx, offset TArray
	mov si, 0
	mov cx, 10
	
	mov [BmpWidth], 10
	mov [BmpHeight], 10

@@Lp:
	cmp [byte bx+si+4], 0
	jz @@Skip
	mov dx, offset PTPic

	mov ax, [word bx+si] ;Tear Top
	mov [BmpTop], ax
	mov ax, [word bx+si+2] ;Tear Left
	mov [BmpLeft], ax
	
	push si
	push bx
	call OpenShowBmp
	pop bx
	pop si

@@Skip:
	add si, PlayerTearSize
loop @@Lp

	pop dx
	pop cx
	pop si
	pop bx
	ret
endp DrawT

;=======================================================================================
;Description: Go through the player's tear array and move all existing tears
;Input: none
;Output: none
;=======================================================================================
proc MoveT
	push bx
	push si
	push cx

	mov bx, offset TArray
	mov si, 0
	mov cx, 10

@@Lp:
	mov al, [byte bx+si+4]
	and al, 0Fh
	
	cmp al, 0
	jne @@1
	jmp @@Skip
	
@@1:
	cmp al, 1
	jne @@Not1
	sub [word bx+si], 1
	jmp @@Check
	
@@Not1:
	cmp al, 2
	jne @@Not2
	sub [word bx+si], 1
	add [word bx+si+2], 1
	jmp @@Check

@@Not2:
	cmp al, 3
	jne @@Not3
	add [word bx+si+2], 1
	jmp @@Check
	
@@Not3:
	cmp al, 4
	jne @@Not4
	add [word bx+si], 1
	add [word bx+si+2], 1
	jmp @@Check

@@Not4:
	cmp al, 5
	jne @@Not5
	add [word bx+si], 1
	jmp @@Check
	
@@Not5:
	cmp al, 6
	jne @@Not6
	add [word bx+si], 1
	sub [word bx+si+2], 1
	jmp @@Check

@@Not6:
	cmp al, 7
	jne @@Not7
	sub [word bx+si+2], 1
	jmp @@Check
	
@@Not7:
	cmp al, 8
	jne @@Check
	sub [word bx+si], 1
	sub [word bx+si+2], 1

@@Check:
	mov di, [word CurrAddress]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 20h
	jne @@NotR2
	
	cmp [word bx+si], 52
	jbe @@Del
	cmp [word bx+si], 140
	jae @@Del
	
	jmp @@X

@@NotR2:
	cmp [word bx+si], 18
	jbe @@Del
	cmp [word bx+si], 172
	jae @@Del

@@X:
	cmp al, 30h
	jne @@NotR3
	
	cmp [word bx+si+2], 68
	jbe @@Del
	cmp [word bx+si+2], 242
	jae @@Del
	
@@NotR3:
	cmp [word bx+si+2], 18
	jbe @@Del
	cmp [word bx+si+2], 292
	jae @@Del
	
	jmp @@Skip
	
@@Del:
	call DeleteT
		
@@Skip:	
	add si, PlayerTearSize
	
	dec cx
	cmp cx, 0
	je @@exit
	jmp @@Lp
	
@@exit:
	pop cx
	pop si
	pop bx
	ret
endp MoveT

;=======================================================================================
;Description: Go through the player's tear array and check if a tear hit an enemy
;Input: none
;Output: none
;=======================================================================================
proc CheckTHitbox

	mov cx, 10

	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset BossT
	mov di, offset Boss
	mov si, 0

@@NotBoss:
	mov bx, offset TArray
	mov di, offset ETArray
	mov si, 0
	
@@Lp:
	mov ah, 0dh

	cmp [word bx+si], 0
	jne @@Con
	jmp @@add
	
	@@Con:
	push bx
	push cx

	mov dx, [word bx+si] ;y
	mov cx, [word bx+si+2] ;x
	mov bh, 0
	
	;Top left check
	inc dx
	inc cx
	int 10h
	
	cmp al, 0D5h
	jne @@ConTL
	jmp @@BossHit
	
	@@ConTL:
	cmp al, 44h
	jne @@NotTL
	
	
	
	sub dx, 5	
	sub cx, 8
	
	jmp @@Hit

@@NotTL:
	;Top right check
	add cx, 7
	int 10h
	
	cmp al, 0D5h
	jne @@ConTR
	jmp @@BossHit
	
	@@ConTR:
	cmp al, 44h
	jne @@NotTR
	
	sub dx, 8	
	sub cx, 5
	
	jmp @@Hit
	
@@NotTR:
	;Bottom right check
	add dx, 7
	int 10h
	
	cmp al, 0D5h
	jne @@ConBR
	jmp @@BossHit	
	
	@@ConBR:
	cmp al, 44h
	jne @@NotBR
	
	sub dx, 5	
	sub cx, 5
	
	jmp @@Hit
	
@@NotBR:	
	;Bottom left check
	sub cx, 7
	int 10h
	
	cmp al, 0D5h
	jne @@ConBL
	jmp @@BossHit
	
	@@ConBL:
	cmp al, 44h
	je @@ConBL2
	jmp @@Skip
	
	@@ConBL2:
	sub dx, 8	
	sub cx, 8
	
	jmp @@Hit
	
@@BossHit:
	
	mov bx, offset Boss
	jmp @@DMG

@@Hit:

	call FindClosest

@@DMG:	

	mov al, [byte DmgDec]
	call DamageE
	
	pop cx
	pop bx
	
	mov dl, [byte bx+si+4]
	test dl, 80h
	jz @@Dont
	
	and dl, 0Fh
	push [word TearCD]
	push [word PTop]
	push [word PLeft]
	
	mov [word TearCD], 0
	mov ax, [word bx+si] ;y
	add ax, 4
	mov [word PTop], ax
	mov ax, [word bx+si+2] ;x
	add ax, 4
	mov [word PLeft], ax

	xor ax, ax
	mov al, dl
	add al, 10
	mov dh, 8
	div dh
	mov [byte TDir], ah
	call AddT
	
	mov dl, [byte bx+si+4]
	and dl, 0Fh
	xor ax, ax
	mov al, dl
	add al, 6
	mov dh, 8
	div dh
	mov [byte TDir], ah
	call AddT
	
	pop [word PLeft]
	pop [word PTop]
	pop [word TearCD]
	
@@Dont:
	
	cmp [byte Piercing], 1
	jne @@Del
	call Pierce
	jmp @@Add
	
@@Del:
	call DeleteT

	jmp @@Add
	
@@Skip:
	pop cx
	pop bx
	
@@Add:
	add si, PlayerTearSize

dec cx
cmp cx, 0
je @@out
jmp @@Lp

@@Out:
	ret
endp CheckTHitbox


proc Pierce
	
	push si
	
	mov dx, [word bx+si] ;Tear Top
	mov cx, [word bx+si+2] ;Tear Left
	mov al, 7
	mov si, 10
	mov di, 10
	call Rect
	
	pop si
	
	mov al, [byte bx+si+4]
	and al, 0Fh
	
	cmp al, 0
	jne @@1
	jmp @@Skip
	
@@1:
	cmp al, 1
	jne @@Not1
	sub [word bx+si], 18
	jmp @@Skip
	
@@Not1:
	cmp al, 2
	jne @@Not2
	sub [word bx+si], 14
	add [word bx+si+2], 14
	jmp @@Skip

@@Not2:
	cmp al, 3
	jne @@Not3
	add [word bx+si+2], 18
	jmp @@Skip
	
@@Not3:
	cmp al, 4
	jne @@Not4
	add [word bx+si], 14
	add [word bx+si+2], 14
	jmp @@Skip

@@Not4:
	cmp al, 5
	jne @@Not5
	add [word bx+si], 18
	jmp @@Skip
	
@@Not5:
	cmp al, 6
	jne @@Not6
	add [word bx+si], 14
	sub [word bx+si+2], 14
	jmp @@Skip

@@Not6:
	cmp al, 7
	jne @@Not7
	sub [word bx+si+2], 18
	jmp @@Skip
	
@@Not7:
	cmp al, 8
	jne @@Skip
	sub [word bx+si], 14
	sub [word bx+si+2], 14

@@Skip:
	ret
endp Pierce


;=======================================================================================
;Description: Damage the player and redraw the hud
;Input: al - damage
;Output: none
;=======================================================================================
proc Damage

	cmp [word Invin], 0
	jne @@Skip
	
	sub [byte PCHealth], al
	mov [word Invin], INVINCIBILITY_FRAME
	
	cmp [byte PCHealth], 0
	jg @@Yes
	
	mov [byte Win], 1
	mov [byte quit], 0
	jmp @@Skip
	
@@Yes:
	
	call DrawHUD
	
@@Skip:
	ret
endp Damage



;***********************************************************************************************************************************************************;
;																Enemy related procs
;***********************************************************************************************************************************************************;


proc MoveE
	
	cmp [word Boss], 1
	jne @@P2
	
	jmp @@Exit
	
	@@P2:
	
	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset Boss
	mov cx, 1
	jmp @@Lp
	
	@@NotBoss:
	mov bx, offset EArray
	
	mov cx, 4
	
@@Lp:
	cmp [word bx], 0
	jne @@Ok
	jmp @@Skip
	;+2 - x, +4 - delta y, +6 = delta x, +8 - tempW, +10 - delta +12 - dir +13 - cooldown
@@Ok:
	
	cmp [byte bx+5], 2
	jne @@Con
	jmp @@Skip
	
@@Con:
	cmp [word bx+21], 0
	je @@Move
	
	dec [word bx+21]
	jmp @@Skip
	
	@@Move:
	cmp [byte bx+20], 2
	jbe @@X
	jmp @@PreY
	
@@X:
	cmp [byte bx+20], 1
	jne @@DecX

	add [word bx+2], 2 ;inc x

@@DecX:
	dec [word bx+2] ;dec x

	cmp [word bx+16], 0 ;cmp tempW
	jge nxt
	
	mov dx, [word bx+14] 
	add [word bx+16], dx ; dx = abs(p2X - p1X) = deltax
	
	mov dx, [word bx+18]
	add [word bx], dx ; dx = delta
nxt:
	mov dx, [word bx+12]
	sub [word bx+16], dx ; dx = abs(p2Y - p1Y) = deltay
	mov [word bx+21], ECOOLDOWN
	jmp @@Skip

@@PreY:
	cmp [byte bx+20], 4
	jbe @@Y
	jmp @@Skip

@@Y:	
	cmp [byte bx+20], 3
	jne @@DecY

	add [word bx], 2 ;inc y
	
@@DecY:
	dec [word bx] ;dec y

	cmp [word bx+16], 0
	jge nxt2
	
	mov dx, [word bx+12]
	add [word bx+8], dx ; dx = (p2Y - p1Y) = deltay
	
	mov dx, [word bx+18]
	add [word bx+2], dx ; dx = delta
nxt2:
	mov dx, [word bx+14]
	sub [word bx+16], dx ; dx = abs(p2X - p1X) = daltax
	mov [word bx+21], ECOOLDOWN
	
@@Skip:
	add bx, EnemySize
	dec cx
	cmp cx, 0
	je @@Exit
jmp @@Lp	
	
@@Exit:	
	
	ret
endp MoveE



proc FindClosest
	push si
	mov bx, offset EArray
	mov di, 0
	
	mov [word point1X], cx
	mov [word point1Y], dx
	
	mov [byte point2X], 16 ;using point2X as min distance
	mov [word point2Y], bx ;using point2Y as offset of min distance
	
	mov cx, 4
	
@@Lp:
	
	cmp [word bx], 0
	jne @@Con
	jmp @@No
	
@@Con:
	mov ax, [word point1X]
	sub ax, [word bx+2]
	absolute ax
	
	mov ah, 0
	mul al
	
	mov si, ax ;store the number
	
	mov ax, [word point1Y]
	sub ax, [word bx]
	absolute ax
	
	mov ah, 0
	mul al
	
	add ax, si ;add 2 numbers
	mov dx, ax
	
	mov si, 0         ; si = candidate sqrt (result)
next_try:
	inc di
    inc si
	xor ax, ax
    mov ax, si
    mul al            ; DX:AX = si * si (we only care about AX)
    cmp dx, ax        ; compare si*si to original AX
    ja next_try       ; if si*si <= AX, keep going

    dec si            ; last si was too big, so back off

    mov ax, si         ; store result
	
	cmp al, [byte point2X]
	jae @@No
	
	mov [byte point2X], al
	mov [word point2Y], bx
	
@@No:
	add bx, EnemySize
	
loop @@Lp
	
	mov bx, [word point2Y]
	
	pop si
	ret
endp FindClosest

;=======================================================================================
;Description: Add a tear to the enemies' tear array if the cooldown is finished
;Input: none
;Output: a tear in every empty cell of an enemy's array
;=======================================================================================
proc AddET
	
	cmp [word Boss], 0
	je @@NotBoss
	
	call BossAttack
	jmp @@Exit
	
	@@NotBoss:
	mov di, offset EArray
	mov bx, offset ETArray
	
	;Check CD
	
	mov cx, 4
@@Add:
	
	cmp [word di], 0
	je @@Skip
	
	cmp [byte di+5], 2
	jb @@Skip
	
	cmp [word bx], 0
	jne @@Skip

	cmp [word bx+13], 0 ;CD
	je @@Yes
	dec [word bx+13]
	
@@Skip:
	add di, EnemySize
	add bx, EnemyTearSize
loop @@Add

	jmp @@Exit

@@Yes:

	mov ax, [word di]
	add ax, 4
	mov [word bx], ax
	mov [point1Y], ax

	mov ax, [word di+2]
	add ax, 4
	mov [word bx+2], ax
	mov [point1X], ax
	
	mov ax, [PLeft]
	add ax, 4
	mov [point2X], ax
	
	mov ax, [PTop]
	add ax, 4
	mov [point2Y], ax

	call CalcTearPath
	mov [word bx+13], COOLDOWN
	
	cmp [byte bx+5], 2
	jne @@Exit
	sub [word bx+13], 40

@@Exit:
	ret
endp AddET

;=======================================================================================
;Description: Delete one of the enemies' tears
;Input: bx - offset of the tear in the tear array
;Output: none
;=======================================================================================
proc DeleteET
	push cx
	push si
	push di
	
	mov dx, [word bx] ;Tear Top
	mov cx, [word bx+2] ;Tear Left
	mov al, 7
	mov si, 10
	mov di, 10
	call Rect
	
	mov [word bx], 0
	mov [word bx+2], 0
	mov [word bx+4], 0
	mov [word bx+6], 0
	mov [word bx+8], 0
	mov [word bx+10], 0
	mov [byte bx+12], 0
	
	pop di
	pop si
	pop cx
	
	ret
endp DeleteET

proc DeleteAllET
	cmp [word Boss], 1
	jne @@P2
	
	jmp @@Exit
	
	@@P2:
	
	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset BossT
	mov cx, 3
	jmp @@Lp
	
	@@NotBoss:
	mov bx, offset ETArray
	mov cx, 4
	
@@Lp:
	call DeleteET
	
	add bx, EnemyTearSize
loop @@Lp

@@Exit:
	ret
endp DeleteAllET

;=======================================================================================
;Description: Go through the enemies' tear arrays and draw all existing tears
;Input: none
;Output: none
;=======================================================================================
proc DrawET
	
	cmp [word Boss], 1
	jne @@P2
	
	jmp @@Exit
	
	@@P2:
	
	mov [BmpWidth], 10
	mov [BmpHeight], 10
	
	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset BossT
	mov cx, 3
	jmp @@Lp
	
	@@NotBoss:
	
	mov bx, offset ETArray
	mov cx, 4
@@Lp:

	cmp [word bx], 0
	jz @@Skip

	mov dx, offset ETPic

	mov ax, [word bx] ;Tear Top
	mov [BmpTop], ax
	mov ax, [word bx+2] ;Tear Left
	mov [BmpLeft], ax

	push cx
	push bx
	call OpenShowBmp
	pop bx
	pop cx
	
@@Skip:
	add bx, EnemyTearSize
loop @@Lp
	
@@Exit:
	ret
endp DrawET

;=======================================================================================
;Description: Go through the enemies' tear arrays and move all existing tears
;Input: none
;Output: none
;=======================================================================================
proc MoveET

	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset BossT
	mov cx, 3
	jmp @@Lp
	
	@@NotBoss:

	mov bx, offset ETArray
	mov cx, 4
	
@@Lp:
	cmp [word bx], 0
	jne @@Ok
	jmp @@Skip
	;+2 - x, +4 - delta y, +6 = delta x, +8 - tempW, +10 - delta +12 - dir +13 - cooldown
@@Ok:
	
	cmp [byte bx+12], 2
	jbe @@X
	jmp @@PreY
	
@@X:
	cmp [byte bx+12], 1
	jne @@DecX

	add [word bx+2], 2 ;inc x

@@DecX:
	dec [word bx+2] ;dec x

	cmp [word bx+8], 0 ;cmp tempW
	jge @@nxt
	
	mov dx, [word bx+6] 
	add [word bx+8], dx ; dx = abs(p2X - p1X) = deltax
	
	mov dx, [word bx+10]
	add [word bx], dx ; dx = delta
@@nxt:
	mov dx, [word bx+4]
	sub [word bx+8], dx ; dx = abs(p2Y - p1Y) = deltay
	jmp @@Check

@@PreY:
	cmp [byte bx+12], 4
	jbe @@Y
	jmp @@Skip

@@Y:	
	cmp [byte bx+12], 3
	jne @@DecY

	add [word bx], 2 ;inc y
	
@@DecY:
	dec [word bx] ;dec y

	cmp [word bx+8], 0
	jge @@nxt2
	
	mov dx, [word bx+4]
	add [word bx+8], dx ; dx = (p2Y - p1Y) = deltay
	
	mov dx, [word bx+10]
	add [word bx+2], dx ; dx = delta
@@nxt2:
	mov dx, [word bx+6]
	sub [word bx+8], dx ; dx = abs(p2X - p1X) = daltax

@@Check:
	mov di, [word CurrAddress]
	mov al, [byte di]
	and al, 0F0h
	
	cmp al, 20h
	jne @@NotR2
	
	cmp [word bx], 52
	jbe @@Del
	cmp [word bx], 140
	jae @@Del
	
	jmp @@XCheck

@@NotR2:
	cmp [word bx], 18
	jbe @@Del
	cmp [word bx], 172
	jae @@Del

@@XCheck:
	cmp al, 30h
	jne @@NotR3
	
	cmp [word bx+2], 68
	jbe @@Del
	cmp [word bx+2], 242
	jae @@Del
	
@@NotR3:
	cmp [word bx+2], 18
	jbe @@Del
	cmp [word bx+2], 292
	jae @@Del
	
	jmp @@Skip
	
@@Del:
	call DeleteET

@@Skip:
	add bx, EnemyTearSize

	dec cx
	cmp cx, 0
	je @@Exit
jmp @@Lp	
	
@@Exit:
	ret
endp MoveET

;=======================================================================================
;Description: Go through the enemies' tear arrays and check if a tear hit the player
;Input: al = damage , bx+si - offset of the tear
;Output: none
;=======================================================================================
proc CheckETHitbox
	
	cmp [word Boss], 1
	jne @@P2
	
	jmp @@Exit
	
	@@P2:
	
	mov si, 0

	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset BossT
	mov di, offset Boss
	mov cx, 3
	jmp @@Lp
	
	@@NotBoss:
	mov bx, offset ETArray
	mov di, offset EArray
	mov cx, 4
	
@@Lp:
	mov ah, 0dh
	cmp [word bx+si], 0
	je @@Add

	push bx
	push cx

	mov dx, [word bx] ;y
	mov cx, [word bx+2] ;x
	mov bh, 0
	
	;Top left check
	inc dx
	inc cx
	int 10h
	
	cmp al, 8h
	je @@Del

	;Top right check
	add cx, 7
	int 10h
	
	cmp al, 8h
	je @@Del
	
	;Bottom right check
	add dx, 7
	int 10h
	
	cmp al, 8h
	je @@Del
	
	;Bottom left check
	sub cx, 7
	int 10h
	
	cmp al, 8h
	jne @@Skip
	
@@Del:
	xor ax, ax
	mov al, 1
	call Damage
	
	pop cx
	pop bx
	
	call DeleteET
	
	jmp @@Add
	
@@Skip:
	pop cx
	pop bx
	
@@Add:
	add bx, EnemyTearSize
	add di, EnemySize
loop @@Lp

@@Exit:
	ret
endp CheckETHitbox


proc CheckEHitbox

	mov si, 0

	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset Boss
	mov cx, 2
	jmp @@Lp
	
	@@NotBoss:
	mov bx, offset EArray

	mov cx, 4
	
@@Lp:
	mov ah, 0dh
	cmp [word bx+si], 0
	je @@Add

	push bx
	push cx

	mov dx, [word bx] ;y
	mov cx, [word bx+2] ;x
	mov bh, 0
	
	;Top left check
	inc dx
	inc cx
	int 10h
	
	cmp al, 8h
	je @@Del

	;Top right check
	add cx, 7
	int 10h
	
	cmp al, 8h
	je @@Del
	
	;Bottom right check
	add dx, 7
	int 10h
	
	cmp al, 8h
	je @@Del
	
	;Bottom left check
	sub cx, 7
	int 10h
	
	cmp al, 8h
	jne @@Skip
	
@@Del:
	mov al, 2
	call Damage
	
	pop cx
	pop bx
	
	jmp @@Add
	
@@Skip:
	pop cx
	pop bx
	
@@Add:
	add bx, EnemySize
loop @@Lp

	ret
endp CheckEHitbox


;=======================================================================================
;Description: Damage the enemy and check if it should be deleted, if it should - randomize the amount of money the player gets
;Input: al - damage, bx - offset of the enemy
;Output: none
;=======================================================================================
proc DamageE
	PUSH_ALL	
	
	sub [byte bx+4], al
	
	cmp [byte bx+4], 0
	jg @@No
	
	cmp [word Boss], 0
	je @@NotBoss
	
	push bx
	mov [byte Win], 0
	call EmptyBar
	pop bx
	
	@@NotBoss:
	dec [byte CurrEnemies]
	call UndrawE
	
	push bx
	mov bl, 0
	mov bh, 3
	call RandomByCs
	
	add [byte MoneyDec], al
	
	call UpdateHex
	
	pop bx
@@No:
	
	cmp [word Boss], 0
	je @@Nevermind
	
	cmp [byte bx+4], 45
	ja @@Nevermind

	mov [byte Phase2], 1
	
	@@Nevermind:
	
	call DrawHUD
	
@@Skip:
	POP_ALL
	ret
endp DamageE

;=======================================================================================
;Description: Delete an enemy
;Input: bx - offset of the enemy
;Output: none
;=======================================================================================
proc UndrawE
	push cx
	push si
	push di
	
	mov dx, [word bx] ;Enemy Top
	mov cx, [word bx+2] ;Enemy Left
	mov al, 7
	
	cmp [word Boss], 0
	je @@NotBoss
	mov si, 24
	mov di, 24
	jmp @@Show
	
	@@NotBoss:
	mov si, 18
	mov di, 18
	
	@@Show:
	call Rect
	
	cmp [byte Phase2], 1
	jne @@Con
	
	cmp [word JumpCD], 150
	jne @@Nvm
	
	mov [word Boss], 1

	@@Nvm:
	
	cmp [word Boss], 1
	je @@DontDelete
	
@@Con:
	
	mov [word bx], 0
	mov [word bx+2], 0
	mov [word bx+4], 0
	mov [word bx+6], 0
	mov [word bx+8], 0
	mov [word bx+10], 0
	mov [word bx+12], 0
	mov [word bx+14], 0
	mov [word bx+16], 0
	mov [word bx+18], 0
	mov [word bx+20], 0
	mov [byte bx+22], 0
	
@@DontDelete:
	pop di
	pop si
	pop cx	
	
	ret
endp UndrawE

;=======================================================================================
;Description: Draw all existing enemies when entering a room
;Input: none
;Output: none
;=======================================================================================
proc DrawEnemies
	mov bx, offset EArray
	
	cmp [word Boss], 1
	jne @@P2
	
	jmp @@Exit
	
	@@P2:
	
	cmp [word Boss], 0
	je @@NotBoss
	
	push [word Boss]
	push [word Boss+2]
	call DrawBoss
	jmp @@Exit

@@NotBoss:
	mov cx, 4
	
@@Lp:
	cmp [word bx], 0
	je @@Delay
	
	push bx
	push cx
	
	mov dx, offset GaperPic
	push [word bx]
	push [word bx+2]
	call DrawC	
	
	pop cx
	pop bx
	jmp @@Skip
	
@@Delay:	
	call DelayE
	
@@Skip:
	add bx, EnemySize
loop @@Lp

	
@@Exit:
	ret
endp DrawEnemies

;=======================================================================================
;Description: Undraw all enemies
;Input: none
;Output: none
;=======================================================================================
proc UndrawEnemies

	cmp [word Boss], 0
	je @@NotBoss
	
	mov bx, offset Boss
	mov cx, 1
	jmp @@Lp
	
	@@NotBoss:
	mov bx, offset EArray
	mov cx, 4
	
@@Lp:
	call UndrawE
	add bx, EnemySize
loop @@Lp

	ret
endp UndrawEnemies


proc BossAttack
	
	cmp [byte Phase2], 1
	jne @@Normal
	
	push bx
	call BossAttack2
	pop bx
	
	@@Normal:
	
	cmp [word Boss], 1
	jne @@P2
	
	jmp @@Done
	
	@@P2:
	mov di, offset Boss
	mov bx, offset BossT
	
@@Yes:
	
	mov cx, 3
@@Lp:
	cmp [word bx], 0
	je @@Skip1
	jmp @@Done
	@@Skip1:
	cmp [word bx+13], 0 ;CD
	je @@Skip2
	dec [word bx+13]
	jmp @@Done
	@@Skip2:
loop @@Lp

	MOVE_POINTS
	
	call CalcTearPath
	mov [word bx+13], COOLDOWN
	
	cmp [byte bx+12], 2
	jbe @@y
	
	;X based shot
	add bx, EnemyTearSize
	
	MOVE_POINTS
	
	sub [word point2X], 30
	mov ax, [word point2X]
	cmp ax, [word PLeft]
	jb @@okX1
	
	mov [word point2X], 0
	
	@@okX1:
	call CalcTearPath
	
	add bx, EnemyTearSize
	
	MOVE_POINTS
	
	add [word point2X], 30
	call CalcTearPath
	
	jmp @@Done
	
@@y:
	
	add bx, EnemyTearSize
	
	MOVE_POINTS
	
	sub [word point2Y], 30
	mov ax, [word point2Y]
	cmp ax, [word PTop]
	jb @@okY1
	
	mov [word point2Y], 0
	
	@@okY1:
	call CalcTearPath
	
	add bx, EnemyTearSize
	
	MOVE_POINTS
	
	add [word point2Y], 30
	call CalcTearPath
	;bx + 12 = 1,2 - x, 3,4 - y
	
@@Done:
	call DelayE
	call DelayE
	call DelayE

	ret
endp BossAttack


proc BossAttack2
	
	cmp [word JumpCD], 150
	je @@Jump
	
	cmp [word JumpCD], 50
	je @@Warn
	
	cmp [word JumpCD], 0
	je @@Land
	
	cmp [word JumpCD], 50
	ja @@Nvm
	
	call DrawDanger
	
	@@Nvm:
	jmp @@Exit
	
@@Jump:
	call DeleteAllET
	mov bx, offset Boss
	call UndrawE
	jmp @@Exit
	
@@Warn:

	mov ax, [word PTop]
	mov [word DangerY], ax
	
	cmp [word DangerY], 153
	jbe @@ok1
	
	mov [word DangerY], 153
	
	@@ok1:
	cmp [word DangerY], 18
	jae @@ok2
	
	mov [word DangerY], 18

	@@ok2:
	
	mov ax, [word PLeft]
	mov [word DangerX], ax
	
	cmp [word DangerX], 273
	jbe @@ok3
	
	mov [word DangerX], 273
	
	@@ok3:
	cmp [word DangerX], 18
	jae @@ok4
	
	mov [word DangerX], 18

	@@ok4:
	call DrawDanger
	
	jmp @@Exit
	
	
@@Land:
	call UndrawDanger
	
	mov [word JumpCD], 550
	mov ax, [word DangerY]
	mov [word Boss], ax
	mov ax, [word DangerX]
	mov [word Boss+2], ax
	

	
@@Exit:
	dec [word JumpCD]

	ret
endp BossAttack2

proc DrawDanger
	
	mov dx, offset DangerPic
	mov [BmpWidth], 30
	mov [BmpHeight], 30
	mov ax, [word DangerX]
	mov [word BmpLeft], ax
	mov ax, [word DangerY]
	mov [word BmpTop], ax
	
	call OpenShowBmp
	
	ret
endp DrawDanger

proc UndrawDanger
	
	push cx
	push si
	push di
	
	mov dx, [word DangerY] ;Danger Top
	mov cx, [word DangerX] ;Danger Left
	mov al, 7
	mov si, 30
	mov di, 30
	call Rect
	
	pop di
	pop si
	pop cx
	

	ret
endp UndrawDanger


;***********************************************************************************************************************************************************;
;																	Miscellaneous procs
;***********************************************************************************************************************************************************;


;=======================================================================================
;Description: Draw the loading screen and delay the game by 300ms
;Input: none
;Output: none
;=======================================================================================
proc Delay
	mov dx, offset LoadPic
	call DrawBg
	
	push cx
	mov cx, 10
	@@Lp:
		call _100MiliSecDelay
	loop @@Lp
	pop cx

	ret
endp Delay

proc DelayE
	PUSH_ALL
	
	mov cx, 02FFh
	@@Lp:
		PUSH_ALL
		POP_ALL
	loop @@Lp
	
	POP_ALL
	ret
endp DelayE

;=======================================================================================
;Description: Calculate the path a tear has to take from the enemy to the player and save the info
;Input: point1X, point1Y, point2X, point2Y, bx=offset
;Output: values needed to draw and move the tear
;=======================================================================================
proc CalcTearPath
	
	mov cx, [point1X]
	sub cx, [point2X]
	absolute cx
	mov dx, [point1Y]
	sub dx, [point2Y]
	absolute dx
	cmp cx, dx
	jnae @@TestY ; deltaX <= deltaY
	jmp @@TestX ;deltaX > deltaY

@@TestY:
	;Y
	mov [byte bx+12], 3 ;y+
	mov [word bx+10], 1 ;delta
	mov ax, [point1X]
	cmp ax, [point2X]
	jbe @@SkipY
	neg [word bx+10] ; turn delta to -1

@@SkipY:

	mov ax, [point1Y]
	cmp ax, [point2Y]
	jbe @@IncY

	mov [byte bx+12], 4 ;y-

@@IncY:
	mov ax, [point2Y]
	jmp @@Both

@@TestX:
	;X
	mov [byte bx+12], 1 ;x+
	mov [word bx+10], 1 ;delta
	mov ax, [point1Y]
	cmp ax, [point2Y]
	jbe @@SkipX
	mov [word bx+10], -1 ; turn delta to -1

@@SkipX:

	mov ax, [point1X]
	cmp ax, [point2X]
	jbe @@IncX

	mov [byte bx+12], 2 ;x-

@@IncX:
	mov ax, [point2X]

@@Both:
	shr ax, 1 ; div by 2
	mov [word bx+8], ax ;tempW
	mov dx, [point2X]
	sub dx, [point1X]
	absolute dx
	mov [word bx+6], dx ;delta x
	mov cx, [point2Y]
	sub cx, [point1Y]
	absolute cx
	mov [word bx+4], cx ;delta y
	
	ret 
endp CalcTearPath

;=======================================================================================
;Description: Calculate the path an enemy has to take to the player and save the info
;Input: point1X, point1Y, point2X, point2Y, bx=offset
;Output: values needed to draw and move the tear
;=======================================================================================
proc CalcEnemyPath
	
	mov cx, [point1X]
	sub cx, [point2X]
	absolute cx
	mov dx, [point1Y]
	sub dx, [point2Y]
	absolute dx
	cmp cx, dx
	jnae @@TestY ; deltaX <= deltaY
	jne @@TestX ;deltaX > deltaY

@@TestY:
	;Y
	mov [byte bx+20], 3 ;y+
	mov [word bx+18], 1 ;delta
	mov ax, [point1X]
	cmp ax, [point2X]
	jbe @@SkipY
	neg [word bx+18] ; turn delta to -1

@@SkipY:

	mov ax, [point1Y]
	cmp ax, [point2Y]
	jbe @@IncY

	mov [byte bx+20], 4 ;y-

@@IncY:
	mov ax, [point2Y]
	jmp @@Both

@@TestX:
	;X
	mov [byte bx+20], 1 ;x+
	mov [word bx+18], 1 ;delta
	mov ax, [point1Y]
	cmp ax, [point2Y]
	jbe @@SkipX
	mov [word bx+18], -1 ; turn delta to -1

@@SkipX:

	mov ax, [point1X]
	cmp ax, [point2X]
	jbe @@IncX

	mov [byte bx+20], 2 ;x-

@@IncX:
	mov ax, [point2X]

@@Both:
	shr ax, 1 ; div by 2
	mov [word bx+16], ax ;tempW
	mov dx, [point2X]
	sub dx, [point1X]
	absolute dx
	mov [word bx+14], dx ;delta x
	mov cx, [point2Y]
	sub cx, [point1Y]
	absolute cx
	mov [word bx+12], cx ;delta y
	
	ret 
endp CalcEnemyPath


proc ResetGame
	call Delay

	mov [PTop], 60
	mov [PLeft], 150
	
	mov [byte RPressed], 1
	
	call DeleteAllET
	call DeleteAllT
	
	call UndrawEnemies
	call StartRoom
	
	mov [byte RoomCnt], 10
	mov [byte PMHealth], 6
	mov [byte PCHealth], 6
	mov [byte DmgDec], 3
	mov [word MoneyHex], "00"
	mov [byte MoneyDec], 0
	mov [byte ItemCheck], 0
	mov [byte BossCheck], 0
	mov [byte ShopCheck], 0
	
	mov [byte Dir8], 0
	mov [byte Piercing], 0
	mov [byte splitting], 0
	mov [byte Fast], 0
	
	mov [byte FirstRoom], 0
	mov [byte CurrEnemies], 0
	
	mov [byte Phase2], 0
	
	ret
endp ResetGame

proc PauseScreen
	
	mov [byte EscPressed], 1

	mov dx, offset PausePic
	mov [BmpTop], 140
	mov [BmpLeft], 90
	mov [BmpWidth], 144
	mov [BmpHeight], 60
	call OpenShowBmp

	mov dx, offset ArrowPic
	mov [BmpTop], 172
	mov [BmpLeft], 97
	mov [BmpWidth], 20
	mov [BmpHeight], 11
	call OpenShowBmp
	
@@While:
	
	cmp [byte UpPressed], 0
	jne @@NoUp
	
	cmp [BmpTop], 172
	je @@NoUp
	
	sub [BmpTop], 15
	push [BmpTop]
	
	jmp @@Show
	
@@NoUp:

	cmp [byte DownPressed], 0
	jne @@Skip
	
	cmp [BmpTop], 187
	je @@Skip
	
	add [BmpTop], 15
	push [BmpTop]
	
@@Show:
	
	mov dx, offset PausePic
	mov [BmpTop], 140
	mov [BmpLeft], 90
	mov [BmpWidth], 144
	mov [BmpHeight], 60
	call OpenShowBmp
	
	mov dx, offset ArrowPic
	pop [BmpTop]
	mov [BmpLeft], 97
	mov [BmpWidth], 20
	mov [BmpHeight], 11
	call OpenShowBmp

@@Skip:
	cmp [byte SpacePressed], 0
	jne @@While
	
	cmp [BmpTop], 187
	jne @@Exit
	
	mov [EscPressed], 0
@@Exit:
	ret
endp PauseScreen

proc GameOver
	
	cmp [byte Win], 0
	je @@Won
	
	mov dx, offset GameOverPic
	jmp @@Show
	
	@@Won:
	mov dx, offset GameWonPic
	
@@Show:
	call DrawBg
	
	mov [byte Quit], 1
	mov [byte RPressed], 1
	mov [byte EscPressed], 1

	@@While:
		cmp [byte RPressed], 0
		je @@Exit
		
		cmp [byte EscPressed], 0
		jne @@while
		mov [byte Quit], 0
		
@@Exit:
	ret
endp GameOver

proc EmptyBar
	
	push cx
	push si
	push di
	
	mov cx, 69
	mov dx, 183
	mov al, 0
	mov si, 17
	mov di, 182
	call Rect
	
	pop di
	pop si
	pop cx
	
	call DeleteAllET
	call ShowStar
	mov [byte BossDie], 1
	
	ret
endp EmptyBar

proc ShowStar
	
	mov dx, offset StarPic
	mov [word BmpTop], 85
	mov [word BmpLeft], 145
	mov [word BmpWidth], 30
	mov [word BmpHeight], 30
	call OpenShowBmp

	ret
endp ShowStar

;***********************************************************************************************************************************************************;
;																Procs Given by Yossi
;***********************************************************************************************************************************************************;

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

proc ShowBMP  near
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

@@dont:
	cmp [byte si], 0FBh
	jne @@move
	inc si
	inc di
	jmp @@skip

@@move:
	movsb ; Copy line to the screen   mov cx times [es:di], [ds:si] di++ si++

@@skip:
	loop @@dont

	;mov ah,0
	;int 16h

	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up

	;push ax
	;mov ah,1
	;int 21h
	;pop ax

	pop cx
	loop @@NextLine

	pop cx
	ret
endp ShowBMP
;--------------------------------------------------------------;
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
;--------------------------------------------------------------;
;cx = col dx= row al = color si = height di = width
proc Rect
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

proc DrawVerticalLine near
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

proc DrawHorizontalLine	
	push si
	push cx
DrawLine:
	cmp si,0
	jz ExitDrawLine	
    mov ah,0ch	
	int 10h    ; put pixel  cx=x dx=y al = color
	
	inc cx
	dec si
	jmp DrawLine
	
	
ExitDrawLine:
	pop cx
    pop si
	ret
endp DrawHorizontalLine

; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	push bx
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the nask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:
	pop bx
	pop di
	pop si
	pop es
	ret
endp RandomByCs

; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask


label EndOfCsLbl
END start


