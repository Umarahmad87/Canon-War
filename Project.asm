;i150087 Umar Ahmad Siddiqi
;Sec:A
;
;i150068 Ahsan Ahmad
;Sec:F
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.model large
.stack 100h
.data
temp1 word ?
temp2 word ?
temp3 byte 0,0,0,0,0,0,0,0
varf byte 0,0,0
f2 byte 0,0,0,0

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
Pause1 byte "Pause","$"
scorestring byte "Score","$"
score byte 0
scores byte "000","$"
stringspeed byte "Speed ","$"
gameover byte "Game Over","$"
gamebegin byte "Game Begins in",10,"$"
robotwins byte "Robot Wins","$"
gamecount byte '3$'
msg1 db " hello, world! "
bool1 byte 0
bool2 byte 0
bool3 byte 0,0,0,0
rightborder byte 55
canoncount byte 1
rowstart byte 2,2,2,16,16,16
bool4 byte 0
boolr byte 0
boolrf byte 0,0,0
bulletspeed byte 1,1
count word 0
health byte 'H'
hrow byte 0
hcol byte 40
boolh byte 0

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




StartScreen:



mov ah,0
mov al,13h
int 10h

;call interface

mov ah,02h
mov dh,10  ; row max(30)
mov dl,12 ; col
mov bl,10
int 10h
mov dx,offset gamebegin
;mov al,byte ptr gamebegin
mov cx,1;lengthof gamebegin
mov ah,09h
int 21h


mov ah,02h
mov dh,12  ; row max(30)
mov dl,18 ; col
mov bl,10
int 10h
mov dx,offset gamecount
;mov al,byte ptr gamebegin
mov cx,1;lengthof gamebegin
mov ah,09h
int 21h


;mov dx,offset gamecount
;mov al,gamecount
;mov ah,09h
;int 21h

;mov ah,02h
;mov dh,6  ; row max(30)
;mov dl,64 ; col
;int 10h
;mov al,'|'
;mov bl,3  ; color	
;mov ah,09h
;int 10h






dec gamecount[0]

mov ax,0
mov cx,000Fh			  ; 0000h           
mov dx,4240h                      ; TIMER 0FFFh ; 0Fh 4240h for 1 second delay
mov ah,86h
int 15h


cmp gamecount,'0'
je screenexit




jmp StartScreen

screenexit:










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
push word ptr colortext
mov dh,5  ; row max(30)
mov dl,64 ; col max(80)
mov colortext,152
call drawstring
;pop word ptr colortext


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
pop word ptr colortext


push word ptr colortext
mov dh,18  ; row max(30)
mov dl,64 ; col max(80)
mov si,offset scorestring
mov stringsize,5-1
mov colortext,137
call drawstring

push word ptr colortext
mov dh,18  ; row max(30)
mov dl,70 ; col max(80)
mov si,offset scores
mov stringsize,1
mov colortext,137
call drawstring

pop word ptr colortext

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
mov cx,1 
mov ah,09h
int 10h


cmp hrow,26
je reseth
cmp count,300
je ch1
cmp score,17
je ch2
cmp score,25
je ch3

cmp boolh,1
jne nh

mov ah,02h
mov dh,hrow  ; row max(30)
mov dl,hcol ; col
int 10h
mov al,health ;'|'
push word ptr colortext
mov colortext,148
mov bl,colortext  ; color
mov cx,1
mov ah,09h
int 10h


inc hrow
jmp nh

reseth:
 mov boolh,0
 mov hrow,0
 jmp nh 
ch1:
mov boolh,1
jmp nh
ch2:
mov boolh,1
mov hcol,24
jmp nh

ch3:
mov hcol,8
mov boolh,1
jmp nh


nh:



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Print Life Times
	
	mov ah,02h
	mov dh,6  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,223 ;'|'
	push word ptr colortext
	mov colortext,148
	mov bl,colortext  ; color
	cmp coalrobot.life,0
	jle cm0
	mov cx,coalrobot.life ; prints alphabet life times
	mov ah,09h
	int 10h
	cm0:
        pop word ptr colortext

        push word ptr colortext
	mov colortext,141
	

	mov ah,02h
	mov dh,9  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,223;'|'
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
	mov al,223;'|'
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
	mov al,223;'|'
	mov bl,colortext  ; color
	cmp canon3.life,0
	jle cm3	
	mov cx,canon3.life ; prints alphabet life times
	mov ah,09h
	int 10h
	cm3:

pop word ptr colortext




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Print Ends

call numTostring

;;;;;;;;;;;;;;;;;;;;;;; Canon Draw

cmp canon1.life,0
jle draw2

mov cl,canon1.column
cmp cl,1
jle dnc
mov col2,cl
call drawcanon
jmp godnc
dnc:
mov col2,1
call drawcanon
godnc:


cmp bool1,0
je incrementcanon
cmp bool1,1
je decrementcanon

jmp ignore1
incrementcanon:
 	mov bl,bulletspeed
	add canon1.column,bl
jmp ignore1
decrementcanon:
        mov bl,bulletspeed
	sub canon1.column,bl
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
  mov bl,bulletspeed
  add canon2.column,bl
jmp ignore2
deccan2:
  mov bl,bulletspeed
  sub canon2.column,bl
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
  mov bl,bulletspeed
  add canon3.column,bl
jmp ignore3
deccan3:
  mov bl,bulletspeed
  sub canon3.column,bl
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
mov dh,rowrobot ; row max(30)
mov dl,coalrobot.column ; col max(80)
push word ptr colortext
mov colortext,130;137
call drawstring
pop word ptr colortext
add temp2,8
inc rowrobot

loop drawrobot


mov ah,1
int 16h

mov cl,0
mov ch,0

mov cl,al 
mov ch,ah ; ah 48h ;up  down 50h left 4Bh Right 4Dh

cmp ah,4Bh ; Left key
jne checkr
dec coalrobot.column
jmp jumpout

checkr:
cmp ah,4Dh ; Right key
jne jumpout
inc coalrobot.column


jumpout:

cmp coalrobot.column,51 ; 51
jb normalrun1 
mov coalrobot.column,51

normalrun1:

cmp coalrobot.column,1 ;1
jg normalrun2
mov coalrobot.column,1


normalrun2:


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

mov f2[0],0
mov f2[1],0
mov f2[2],0
mov f2[3],0

mov si,3
mov di,0
mov cx,3

sfs:
push cx


mov ah,1
int 16h

mov cl,0
mov ch,0

mov cl,al 
mov ch,ah ; ah 48h ;up  down 50h left 4Bh Right 4Dh

cmp cl,'P'
je pause
cmp cl,'p'
je pause                                               ;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Pause
jmp resume1

pause:

mov ah,0ch
int 21h

mov ah,0
int 16h

mov cl,0
mov ch,0

mov cl,al 
mov ch,ah ; ah 48h ;up  down 50h left 4Bh Right 4Dh

cmp cl,'P'
je resume1
cmp cl,'p'
je resume1

mov ax,0
mov cx,0000h			  ; 0000h           
mov dx,9FFFh                      ; TIMER 0FFFh ; 0Fh 4240h for 1 second delay
mov ah,86h
int 15h

;mov ah,0ch
;int 21h

jmp pause

resume1:

mov ax,01h
int 33h

mov ax,3
int 33h



;cmp boolrf,0
;je firrl
cmp boolrf[di],0
jne chkbt
cmp cl,32 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Checking keyboard interrupt
je firrl
cmp bx,1
je firrl


chkbt:
jmp firr

firrl:
  mov bl,coalrobot.column
  mov temp3[si],bl
  mov rowstart[si],16
  mov boolrf[di],1
  mov f2[di],1
  mov f2[di+1],1
firr:
        cmp boolrf[di],0
        je fieq0
	mov ah,02h
	mov dh,rowstart[si]  ; row max(30)
	mov dl,temp3[si] ; col
	int 10h
	mov al, 178;'|'                         ; Robot fire
	mov bl,130 ;137  ; color
	mov cx,1 
	mov ah,09h
	int 10h
	dec rowstart[si]

cmp rowstart[si],0 
jne fieq
fieq0:
mov rowstart[si],39
mov temp3[si],54
mov boolrf[di],0

fieq:
cmp f2[di],1
jne fieq2  ; fieq2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Special Fire Starts
inc si
inc di
pop cx
dec cx
push cx
jmp sfe

fieq2:
inc si
inc di

pop cx
dec cx

cmp cx,0
jle sfe



jmp sfs
sfe:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Mouse Movement

mov ax,0
mov bx,0
mov cx,0
mov dx,0

mov ax,01h
int 33h

mov ax,3
int 33h

mov ax,cx
mov bl,8
div bl

cmp al,55
jge crc

mov coalrobot.column,al


crc:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Mosue Movement ends



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
	mov al,173  ;'*'
	mov bl,137  ; color
	mov cx,1 
	mov ah,09h
	int 10h
	mov bl,bulletspeed
	add rowstart[si],bl


out2s:
 cmp rowstart[si],24
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

;;;;;;;;;;;;;;;;;;;;;;;;;; Fire Detection for Robot


mov si,0
mov ch,0
mov cl,canoncount
loopdetection:

mov bl,rowstart[si] ; row 
mov bh,temp3[si] ; column

cmp bl,16
jle outofrange
cmp bh,coalrobot.column
jb outofrange
mov dl,coalrobot.column
add dl,7
cmp bh,dl
ja outofrange
dec coalrobot.life
mov bool3[si],0


outofrange:

inc si

loop loopdetection

cmp coalrobot.life,0
je exit

;;;;;;;;;;;;;;;;;;;;;;;;;; Fire Detection Ends
;;;;;;;;;;;;;;;;;;;;;;;;;; Health Increment

mov bl,hrow ; row 
mov bh,hcol ; column

cmp bl,16
jle outofrange2
cmp bh,coalrobot.column
jb outofrange2
mov dl,coalrobot.column
add dl,7
cmp bh,dl
ja outofrange2
add coalrobot.life,2
mov boolh,0
mov hrow,0

outofrange2:


;;;;;;;;;;;;;;;;;;;;;;;;;; Health Increment ends
;;;;;;;;;;;;;;;;;;;;;;;;;; Fire Detection 2 for canons

mov si,3
mov di,0
mov cx,3

firedet:
push cx

mov bl,rowstart[si] ; row 
mov bh,temp3[si] ; column

cmp canon1.life,0
jle c2


cmp bl,2
jg outofrange22
cmp bh,canon1.column 
jb outofrange22
mov dl,canon1.column
add dl,4
cmp bh,dl
jg outofrange22
dec canon1.life
inc score
mov boolrf[di],0
outofrange22:

c2:

cmp canoncount,2
jb nr2 

cmp canon2.life,0
jle c3

cmp bl,2
jg outofrange32
cmp bh,canon2.column 
jb outofrange32
mov dl,canon2.column
add dl,4
cmp bh,dl
jg outofrange32
dec canon2.life
inc score
mov boolrf[di],0

outofrange32:

c3:


cmp canoncount,3
jb nr2

cmp canon3.life,0
jle c4

cmp bl,2
jg outofrange42
cmp bh,canon3.column 
jb outofrange42
mov dl,canon3.column
add dl,4
cmp bh,dl
jg outofrange42
dec canon3.life
inc score
mov boolrf[di],0


outofrange42:
c4:


nr2:
inc si
inc di
pop cx
dec cx
cmp cx,0
je firedetr

jmp firedet

firedetr:
;;;;;;;;;;;;;;;;;;;;;;;;;; Fire Detection 2 for canons ends



mov ax,0
mov cx,0000h			  ; 0000h           
mov dx,9FFFh                      ; TIMER 0FFFh ; 0Fh 4240h for 1 second delay
mov ah,86h
int 15h


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
  jmp ss2
label2:
  mov bool1,0
  ;dec canon1.life
  ;inc coalrobot.column
  ;inc canoncount
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
  jmp ss4
label6:
  mov bool4,0
ss4:


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Boundary Checks Ends

;;;;;;;;;;;;;;;;;;;; GAME OVER Condition
cmp canon1.life,0
jg repeat1
cmp canon2.life,0
jg repeat1
cmp canon3.life,0
jle Robotwin
;;;;;;;;;;;;;;;;;;;; GAME OVER



repeat1:


inc count


cmp count,180
je inccanon
cmp count,320
je inccanon

cmp count,300
jne call0
cmp bulletspeed,3
jge call1
add bulletspeed,1
jmp call1
inccanon:
 inc canoncount;


call0:


call1:

mov ah,0ch
int 21h

jmp main1


Robotwin:

mov ah,0
mov al,13h ; graphic mode col(640) x row(480) ; 80 x 30
int 10h

mov ah,02h
mov dh,10  ; row max(30)
mov dl,12 ; col
mov bl,10
int 10h
mov dx,offset robotwins
mov cx,1
mov ah,09h
int 21h
jmp exitgame




exit:

mov ah,0
mov al,13h ; graphic mode col(640) x row(480) ; 80 x 30
int 10h

mov ah,02h
mov dh,10  ; row max(30)
mov dl,12 ; col
mov bl,10
int 10h
mov dx,offset gameover
mov cx,1
mov ah,09h
int 21h

;mov dx,offset gameover
;mov ah,09h
;int 21h


exitgame:

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


numTostring proc

  push ax
  push bx
  push cx
  push dx
  mov ah,0
  mov al,score
  mov bl,10
  div bl
  mov scores[0],al
  add scores[0],30h
  mov scores[1],ah
  add scores[1],30h
  pop dx
  pop cx
  pop bx
  pop ax
ret
numTostring endp


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

	mov al,219 ;'*' ;223 
	mov bl,1; 4 colortext  ; color
	mov cx,5 ; prints alphabet 5 times
	mov ah,09h
	int 10h

	


	mov ah,02h
	inc dh
	inc dl
	int 10h
	mov al,219;'*'
	mov bl,3 ; 6 colortext  ; color
	mov cx,3 ; prints alphabet 3 times
	mov ah,09h
	int 10h

	mov ah,02h
	inc dh
	inc dl
	int 10h
	mov al,178;219;'*'
	mov bl,15;colortext  ; color
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
	MOV BH, 4 ; color 
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
	MOV BH, 4 ; color 
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
	MOV BH, 4 ; color 
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
	MOV BH, 4 ; color 
	INT 10h


	mov ax,0
	mov bx,0
	mov cx,0
	mov dx,0

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,1   ; start row
	MOV cl, 61 ; start col
	MOV DH, 23 ; row end
	MOV DL, 78 ; col end
	MOV BH, 6 ; 6 orange color 14 yellow 2 GREEN
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
	MOV BH, 0 ; color (sky blue 9)
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



end

