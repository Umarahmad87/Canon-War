.model large
.stack 100h
.data
temp1 word ?
temp2 word ?
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
gameover byte "Game Over","$"
msg1 db " hello, world! "

canon struc
  column byte ?
  life word 10
canon ends

canon1 canon<>
canon2 canon<>

.code
mov ax,@data
mov ds,ax

mov canon1.column,0
mov canon2.column,55


mov col2,0
mov ah,0
mov al,12h ; graphic mode col(640) x row(480) ; 80 x 30
int 10h



main proc ;//////////////////////////////////////////////////// Main


mov ax,0
mov bx,0
mov cx,0
mov dx,0

call interface
call scoreboard

;;;;;;;;;;;;;;;;;; Border
;mov row,0
;mov col,0
;mov width1,639
;mov height1,479
;mov color1,8
;call printrec
;;;;;;;;;;;;;;;;; Border



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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Print Life Times
	mov ah,02h
	mov dh,9  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,'|'
	mov bl,colortext  ; color
	mov cx,canon1.life ; prints alphabet 5 times
	mov ah,09h
	int 10h


	mov ah,02h
	mov dh,12  ; row max(30)
	mov dl,64 ; col
	int 10h
	mov al,'|'
	mov bl,colortext  ; color
	mov cx,canon2.life ; prints alphabet life times
	mov ah,09h
	int 10h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Print Ends



;;;;;;;;;;;;;;;;;;;;;;; Canon Draw
mov cl,canon1.column
mov col2,cl
call drawcanon
inc canon1.column

mov cl,canon2.column
mov col2,cl
call drawcanon

;;;;;;;;;;;;;;;;;;;;;; Canon Draw end

mov ax,0
mov cx,0000h
mov dx,4FFFh
mov ah,86h
int 15h

cmp canon1.column,56
je label1
jmp ss2
label1:
  mov canon1.column,0
  dec canon1.life
ss2:

cmp canon1.life,0
je exit


;mov ah,01h
;int 21h


call main



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


cls proc
	push ax
	mov AL,03
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


	;mov row,0
	;mov col,490
	;mov width1,149
	;mov height1,400
	;mov color1,15
	;call printrec

	;inc row
	;inc col
	;sub height1,2
	;sub width1,2
	;mov color1,15
	;call printrec
	
	;mov cx,9
	;loopi:
	; inc row
	; inc col
	; sub height1,2
	; sub width1,2
	; mov color1,0
	; call printrec
 	; loop loopi	
	
	;inc row
	;inc col
	;sub height1,2
	;sub width1,2
	;mov color1,15
	;call printrec

	;inc row
	;inc col
	;sub height1,2
	;sub width1,2
	;mov color1,15
	;call printrec

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
	MOV DH, 29 ; row end
	MOV DL, 79 ; col end
	MOV BH, 9 ; color (sky blue)
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
	MOV BH, 7 ; color 
	INT 10h

	MOV AH, 06h ; function number
	MOV AL, 0
	mov ch,27   ; start row
	MOV cl, 0 ; start col
	MOV DH, 29 ; row end
	MOV DL, 79 ; col end
	MOV BH, 8 ; color  1(blue)
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

