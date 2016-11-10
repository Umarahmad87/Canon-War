.model large
.stack 100h
.data
temp1 word ?
temp2 word ?
temp3 byte 0,0,0,0,0
varf byte 0,0,0

row word ?
col word ?
col2 byte ?
width1 word ?
height1 word ?
stringsize word ?
color1 byte ?
colortext byte 150 ; > 128 with no backround color ; 150->white  137->black 
string1 byte "Coal Man","$"
string2 byte "Canon A","$"
string3 byte "Canon B","$"
string4 byte "Canon C","$"
stringspeed byte "Speed ","$"
gameover byte "Game Over","$"
msg1 db " hello, world! "
bool1 byte 0
bool2 byte 0
bool3 byte 0,0,0,0
rightborder byte 55
canoncount byte 1
rowstart byte 2,2,2,16
bool4 byte 0
boolr byte 0
boolrf byte 0
bulletspeed byte 1
count word 0

myrobot db "__  ^-^ "
db 	   "|| (o o)"
db         "||  |-| "
db         "| \+===+"
db         " \_|   |"
db         "   |   |"
db         "   +---+"
db         "   =   ="
db         "   =   ="
db         "   _   _"

rowrobot db 16



canon struc
  column byte ?
  life word 10
  columnstart byte 0
  columnend byte ?
  firepoint byte ?
canon ends

robot struc
  life word 10
  score word 0
  column byte 30
  row byte 16
robot ends

canon1 canon<>
canon2 canon<>
canon3 canon<>
canon4 canon<>
coalrobot robot<>

.code
mov ax,@data
mov ds,ax

mov canon1.column,0
mov canon1.columnend,55
mov canon2.column,27
mov canon2.columnstart,29
mov canon2.columnend,55
mov canon3.column,38
mov canon3.columnstart,39
mov canon3.columnend,55


mov col2,0
mov ah,0
mov al,12h ; graphic mode col(640) x row(480) ; 80 x 30
int 10h

call interface
call scoreboard


main proc ;//////////////////////////////////////////////////// Main
main1:

;mov ah,0
;mov al,12h ; graphic mode col(640) x row(480) ; 80 x 30
;int 10h


mov ax,0
mov bx,0
mov cx,0
mov dx,0




cmp canoncount,3
jg setcanons
jmp continue1

setcanons:
 mov canoncount,3
continue1:


cmp canoncount,2
je increasecanon
cmp canoncount,3
je increasecanon2
jmp ign2
increasecanon:            ; if canon count is 2
	mov al,rightborder
	mov bl,2
	div bl
	sub al,3
	mov canon1.columnend,al
	jmp ign2

increasecanon2:            ; If canon count is 3
	mov al,rightborder
	mov bl,3
	div bl
	sub al,3
	mov canon1.columnend,al
        mov bl,al
	add al,4
	mov canon2.columnstart,al
	mov al,bl
	add al,al
	add al,3
	mov canon2.columnend,al
	
	jmp ign2
ign2:

;call cls
call interface
call scoreboard
call CalculateFirepoint


mov si,offset string1
mov stringsize,7
mov dh,5  ; row max(30)
mov dl,64 ; col max(80)
call drawstring



mov si,offset string2
mov stringsize,6
mov dh,8  ; row max(30)
mov dl,64 ; col max(80)
call drawstring

mov si,offset string3
mov stringsize,6
mov dh,11  ; row max(30)
mov dl,64 ; col max(80)
call drawstring


mov dh,14  ; row max(30)
mov dl,64 ; col max(80)
mov si,offset string4
mov stringsize,6
call drawstring

mov dh,2  ; row max(30)
mov dl,64 ; col max(80)
mov si,offset stringspeed 
mov stringsize,4
call drawstring


mov ah,02h
mov dh,2  ; row max(30)
mov dl,64+6 ; col
int 10h
mov al,bulletspeed
add al,30h
mov bl,colortext  ; color
mov cx,1 ; prints alphabet life times
mov ah,09h
int 10h


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Print Life Times
	
	mov ah,02h
	mov dh,6  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,'|'
	mov bl,130  ; color
	cmp coalrobot.life,0
	jle cm0
	mov cx,coalrobot.life ; prints alphabet life times
	mov ah,09h
	int 10h
	cm0:


	mov ah,02h
	mov dh,9  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,'|'
	mov bl,colortext  ; color
	cmp canon1.life,0
	jle cm1
	mov cx,canon1.life ; prints alphabet life times
	mov ah,09h
	int 10h

	cm1:
	mov ah,02h
	mov dh,12  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,'|'
	mov bl,colortext  ; color
	cmp canon2.life,0
	jle cm2	
	mov cx,canon2.life ; prints alphabet life times
	mov ah,09h
	int 10h
	cm2:

        mov ah,02h
	mov dh,15  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,'|'
	mov bl,colortext  ; color
	cmp canon3.life,0
	jle cm3	
	mov cx,canon3.life ; prints alphabet life times
	mov ah,09h
	int 10h
	cm3:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Print Ends



;;;;;;;;;;;;;;;;;;;;;;; Canon Draw

cmp canon1.life,0
jle draw2

mov cl,canon1.column
mov col2,cl
call drawcanon

cmp bool1,0
je incrementcanon
cmp bool1,1
je decrementcanon

jmp ignore1
incrementcanon:
 	mov al,bulletspeed
	add canon1.column,al
jmp ignore1
decrementcanon:
        mov al,bulletspeed
	sub canon1.column,al
ignore1:

cmp canoncount,1
jg draw2
jmp ndraw2
draw2:                     ;;;;  Drawing of Canon 2 after certain time
cmp canon2.life,0
jle ndraw2
mov cl,canon2.column
mov col2,cl
call drawcanon

cmp bool2,0
je inccan2
cmp bool2,1
je deccan2
jmp ignore2

inccan2:
  mov al,bulletspeed
  add canon2.column,al
jmp ignore2
deccan2:
  mov al,bulletspeed
  sub canon2.column,al
ignore2:

ndraw2:

cmp canoncount,2
jg draw3
jmp ndraw3
draw3:                     ;;;;  Drawing of Canon 3 after certain time
cmp canon3.life,0
jle ndraw3
mov cl,canon3.column
mov col2,cl
call drawcanon

cmp bool4,0
je inccan3
cmp bool4,1
je deccan3
jmp ignore3

inccan3:
  mov al,bulletspeed
  add canon3.column,al
jmp ignore3
deccan3:
  mov al,bulletspeed
  sub canon3.column,al
ignore3:

ndraw3:

;;;;;;;;;;;;;;;;;;;;;; Canon Draw end

;;;;;;;;;;;;;;;;;;;;;;;;; Robot Drawing

mov temp2,0
mov rowrobot,16
mov cx,10

drawrobot:

mov si,offset myrobot
mov bx,temp2
add si,bx
mov stringsize,8-1
mov dh,rowrobot  ; row max(30)
mov dl,coalrobot.column ; col max(80)
push word ptr colortext
mov colortext,137
call drawstring
pop word ptr colortext
add temp2,8
inc rowrobot

loop drawrobot




cmp boolr,0
je incrobot
cmp boolr,1
je decrobot
  
jmp jumpout

incrobot:
  inc coalrobot.column
jmp jumpout

decrobot:
    dec coalrobot.column


jumpout:



cmp coalrobot.column,50 ; 55-8
je sss1
cmp coalrobot.column,0
je sss2
jmp ssso

sss1:
 mov boolr,1 ; left
 jmp ssso
sss2:
 mov boolr,0 ;right

ssso:


cmp boolrf,0
je firrl
jmp firr

firrl:
  mov bl,coalrobot.column
  mov temp3[3],bl
  mov rowstart[3],16
  mov boolrf,1

firr:
    
	mov ah,02h
	mov dh,rowstart[3]  ; row max(30)
	mov dl,temp3[3] ; col
	int 10h
	mov al,'|'
	mov bl,137  ; color
	mov cx,1 
	mov ah,09h
	int 10h
	dec rowstart[3]

cmp rowstart[3],0 
jne fieq
mov boolrf,0

fieq:


;;;;;;;;;;;;;;;;;;;;;;;;; Robot Drawing Ends

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FIRE

mov si,0
mov di,offset canon1
mov varf,0

fireloop:

cmp bool3[si],0 ; bool3 used for firing from canon1
je setfires
jmp out1s
setfires:
   ;mov cl,canon2.firepoint ; +5	
   mov cl,[di+5]
   mov temp3[si],cl
   mov bool3[si],1
   mov rowstart[si],2

out1s:
cmp bool3[si],1
je fire1s                  ;25
jmp out2s
fire1s:
push cx
mov cx,[di+1]
cmp cx,0
jle setfire2s
pop cx
;cmp canoncount,2
;jb setfire2s

	mov ah,02h
	mov dh,rowstart[si]  ; row max(30)
	mov dl,temp3[si] ; col
	int 10h
	mov al,'*'
	mov bl,137  ; color
	mov cx,1 
	mov ah,09h
	int 10h
	mov bl,bulletspeed
	add rowstart[si],bl


out2s:
 cmp rowstart[si],25
 jle setfire2s
 mov bool3[si],0
 mov rowstart[si],2

setfire2s:
pop cx
inc varf
mov dl,canoncount
cmp dl,varf
je fireloope

inc si
add di,6


jmp fireloop
fireloope:



;;;;;;;;;;;;;;;;;;;;;;;;;; Fire End

;;;;;;;;;;;;;;;;;; Border
;mov row,0
;mov col,0
;mov width1,639
;mov height1,479
;mov color1,8
;call printrec
;;;;;;;;;;;;;;;;; Border









mov ax,0
mov cx,0000h			  ; 0000h           
mov dx,9FFFh                      ; TIMER 0FFFh ; 0Fh 4240h for 1 second delay
mov ah,86h
int 15h

;call interface

;MOV AH, 06h ; function number
;MOV AL, 0
;mov ch,0   ; start row
;MOV cl, 0 ; start col
;MOV DH, 29 ; row end
;MOV DL, 79 ; col end
;MOV BH, 0 ; color (sky blue)
;INT 10h



;mov ax, 1003h
;mov bx, 0
;int 10h 

;///////////////////////////////////////////// Boundary checks for canons

mov cl,canon1.columnend
cmp canon1.column,cl
jge label1
mov cl,canon1.columnstart
cmp canon1.column,cl
jle label2
jmp ss2
label1:
  mov bool1,1
  ;mov canon1.column,0
  ;dec canon1.life
  ;inc coalrobot.column
  jmp ss2
label2:
  mov bool1,0
  ;dec canon1.life
  ;inc coalrobot.column
  inc canoncount
ss2:

cmp canoncount,1
jle ss3

;                   For Canon2                        
mov cl,canon2.columnend
cmp canon2.column,cl
jge label3
mov cl,canon2.columnstart
cmp canon2.column,cl
jle label4
jmp ss3
label3:
  mov bool2,1
  ;dec canon2.life
 ; inc coalrobot.column
  jmp ss3
label4:
  mov bool2,0
  ;dec canon2.life
  ;inc coalrobot.column
ss3:
;                Canon2 Ends

mov cl,canon3.columnend
cmp canon3.column,cl
jge label5
mov cl,canon3.columnstart
cmp canon3.column,cl
jle label6
jmp ss4
label5:
  mov bool4,1
  ;dec canon3.life
  ;inc coalrobot.column
  jmp ss4
label6:
  mov bool4,0
  ;dec canon3.life
  ;inc coalrobot.column
ss4:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Boundary Checks Ends

;;;;;;;;;;;;;;;;;;;; GAME OVER Condition
cmp canon1.life,0
jg repeat1
cmp canon2.life,0
jle exit
;;;;;;;;;;;;;;;;;;;; GAME OVER


repeat1:


inc count

cmp count,120
jne call1
inc bulletspeed

call1:
jmp main1



exit:

mov ah,0
mov al,12h ; graphic mode col(640) x row(480) ; 80 x 30
int 10h

mov dx,offset gameover
mov ah,09h
int 21h

mov ah,4ch
int 21h



main endp   ;/////////////////////////////////////////////// Main Ends


CalculateFirepoint proc

push dx

mov dl,canon1.column ; row is 2 always
add dl,2
mov canon1.firepoint,dl

mov dl,canon2.column ; row is 2 always
add dl,2
mov canon2.firepoint,dl

mov dl,canon3.column ; row is 2 always
add dl,2
mov canon3.firepoint,dl



pop dx
ret

CalculateFirepoint endp


cls proc
	push ax
	mov AL,12h
	mov AH,0
	int 10H
	pop ax
	ret
cls endp


drawstring proc
	push ax
	push bx
	push cx
	push dx


	mov ah,02h
	int 10h
	
	mov al,[si]
	mov bl,colortext  ; color
	mov cx,1 ; prints alphabet 5 times
	mov ah,09h
	int 10h

	mov cx,stringsize
	loopstring2:
	 mov ah,02h
	 add dl,1
	 int 10h
	 inc si
	 mov al,[si]
	 mov bl,colortext  ; color
	 push cx
	 mov cx,1 ; prints alphabet 5 times
	 mov ah,09h
	 int 10h
	 pop cx
	loop loopstring2

	pop dx
	pop cx
	pop bx
	pop ax


ret

drawstring endp

drawcanon proc

	push ax
	push bx
	push cx
	push dx


	mov ah,02h
	mov dh,0  ; row max(30)
	mov dl,col2
	;mov dl,56  ; col max(80) // max 56 for game
	int 10h

	mov al,'*'
	mov bl,colortext  ; color
	mov cx,5 ; prints alphabet 5 times
	mov ah,09h
	int 10h



	mov ah,02h
	inc dh
	inc dl
	int 10h
	mov al,'*'
	mov bl,colortext  ; color
	mov cx,3 ; prints alphabet 3 times
	mov ah,09h
	int 10h

	mov ah,02h
	inc dh
	inc dl
	int 10h
	mov al,'*'
	mov bl,colortext  ; color
	mov cx,1 ; prints alphabet 1 times
	mov ah,09h
	int 10h

	pop dx
	pop cx
	pop bx
	pop ax


ret
drawcanon endp

scoreboard proc  ;////////////////////  Scoreboard starts
 	
	push ax
	push bx
	push cx
	push dx


	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0


	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,0   ; start row
	MOV cl, 60 ; start col
	MOV DH, 24 ; row end
	MOV DL, 60 ; col end
	MOV BH, 0 ; color 
	INT 10h

	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,0   ; start row
	MOV cl, 79 ; start col
	MOV DH, 24 ; row end
	MOV DL, 79 ; col end
	MOV BH, 0 ; color 
	INT 10h

	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,0   ; start row
	MOV cl, 60 ; start col
	MOV DH, 0 ; row end
	MOV DL, 79 ; col end
	MOV BH, 0 ; color 
	INT 10h

	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,24   ; start row
	MOV cl, 60 ; start col
	MOV DH, 24 ; row end
	MOV DL, 79 ; col end
	MOV BH, 0 ; color 
	INT 10h

	pop dx
	pop cx
	pop bx
	pop ax

ret
scoreboard endp ;/////////////////////// Scoreboard ends


interface proc ;/////////////////////// Background Starts
	
	push ax
	push bx
	push cx
	push dx

	

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,0   ; start row
	MOV cl, 0 ; start col
	MOV DH, 24 ; row end
	MOV DL, 79 ; col end
	MOV BH, 9 ; color (sky blue 9)
	INT 10h

	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0


	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,25   ; start row
	MOV cl, 0 ; start col
	MOV DH, 26 ; row end
	MOV DL, 79 ; col end
	MOV BH, 7 ; color 7
	INT 10h

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,27   ; start row
	MOV cl, 0 ; start col
	MOV DH, 29 ; row end
	MOV DL, 79 ; col end
	MOV BH, 8 ; color  1(blue) 8
	INT 10h 
	
	pop dx
	pop cx
	pop bx
	pop ax

	ret

interface endp ;//////////////////////    Background ends

printrec proc ;///////////////////////    Print Rectangle
push ax
push bx
push cx
push dx
push row
push col

mov temp1,0

;;;;;;;;;;;;;;;;;; upper line 
mov cx,col ; col
mov dx,row ; row
mov ax,width1
loop1::
cmp temp1,ax
je loop1e
push ax
mov ah,0ch
mov al,color1 ; color
int 10h
pop ax   
add cx,1  ; inc col
inc temp1
jmp loop1

loop1e:
;;;;;;;;;;;;;;;;; upper line ends

;;;;;;;;;;;;;;;;; lower line
mov temp1,0
mov cx,col ; col
mov ax,height1
add row,ax
mov dx,row ; row
sub row,ax

loop2:
mov ax,width1
cmp temp1,ax
je loop2e
push ax
mov ah,0ch
mov al,color1 ; color
int 10h
pop ax   
add cx,1 ; inc col
inc temp1
jmp loop2

loop2e:
;;;;;;;;;;;;;;;; lower line ends


;;;;;;;;;;;;;;; left row

mov temp1,0
mov cx,col ; col
mov dx,row ; row
loop3:
mov ax,height1
cmp temp1,ax
je loop3e
push ax
mov ah,0ch
mov al,color1 ; color
int 10h
pop ax   
add dx,1 ; row inc
inc temp1
jmp loop3

loop3e:
;;;;;;;;;;;;;; left row ends


;;;;;;;;;;;;;; right row
mov ax,width1
add col,ax

mov dx,row
mov temp1,-1
mov cx,col ; col
loop4:
mov ax,height1
cmp temp1,ax
je loop4e
push ax
mov ah,0ch
mov al,color1 ; color
mov cx,col ; col
int 10h
pop ax   
add dx,1 ; inc row

inc temp1
jmp loop4

loop4e:

;;;;;;;;;;;;; right row ends

pop col
pop row
pop dx
pop cx
pop bx
pop ax

ret

printrec endp  ;///////////////// Print Rectangle ends

end

