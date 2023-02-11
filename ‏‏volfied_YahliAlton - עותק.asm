IDEAL
MODEL small
STACK 100h
DATASEG
x dw 308
y dw 191
xs dw 10
ys dw 190
maxx dw 0
maxy dw 0
minx dw 9999
miny dw 9999
paintx dw 0
painty dw 0
color db 7
color2 db 4 ; צבע השובל
color3 db 2 ; for debug
color4 db 9 ; for debug
colors db 0eh  ;צבע המסך
index dw 0
i dw 0

my_zone db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h


CODESEG



proc my_character ; מציירת קוביה
  push [x]
  push [y]
  mov cx, 3
  mov [index], 0
  loopXP: ;מעלה את x
    ; שמירה
    push cx
    mov bh, 0h
    mov cx, [x]
    mov dx, [y]
    mov ah, 0dh
    int 10h

    ;שמירה במערך
    mov bx, offset my_zone
    add bx, index
    mov [bx], al
    add [index], 1

    ; ציור
    mov bh, 0h
    mov cx, [x]
    mov dx, [y]
    mov al,[color]
    mov ah,0ch
    int 10h
    pop cx
    add [x],1
    loop loopXP
  ; שינוי מיקום
  sub [y], 1
  sub [x], 1
  mov cx, 3
  loopXN: ;מוריד את x
    push cx
    
    mov bh, 0h
    mov cx, [x]
    mov dx, [y]
    mov ah, 0dh
    int 10h

    ;שמירה במערך
    mov bx, offset my_zone
    add bx, index
    mov [bx], al
    add [index], 1

    ; ציור
    mov bh,0h
    mov cx,[x]
    mov dx,[y]
    mov al,[color]
    mov ah,0ch
    int 10h
    pop cx
    add [x],-1
    loop loopXN
  sub [y], 1
  add [x], 1
  mov cx, 3
  loopXP2: ;מעלה את x
    push cx
        
    mov bh, 0h
    mov cx, [x]
    mov dx, [y]
    mov ah, 0dh
    int 10h

    ;שמירה במערך
    mov bx, offset my_zone
    add bx, index
    mov [bx], al
    add [index], 1

    ; ציור
    mov bh,0h
    mov cx,[x]
    mov dx,[y]
    mov al,[color]
    mov ah,0ch
    int 10h
    pop cx
    add [x],1
    loop loopXP2
  pop [y]
  pop [x]
  ret
endp my_character 

proc delete_char ; מוחק את הקוביה
  mov [color], 0
  call my_character
  mov [color], 7

  ; mov bh,0h
  ; mov cx,[x]
  ; add cx, 1
  ; mov dx,[y]
  ; mov al,[color2]
  ; mov ah,0ch
  ; int 10h

  ; mov bh,0h
  ; mov cx,[x]
  ; sub cx, 1
  ; mov dx,[y]
  ; mov al,[color2]
  ; mov ah,0ch
  ; int 10h

  ; mov bh,0h
  ; mov cx,[x]
  ; mov dx,[y]
  ; add dx, 1
  ; mov al,[color2]
  ; mov ah,0ch
  ; int 10h

  ; mov bh,0h
  ; mov cx,[x]
  ; mov dx,[y]
  ; sub dx, 1
  ; mov al,[color2]
  ; mov ah,0ch
  ; int 10h

  ret
endp delete_char

proc delete_char2
  push [x]
  push [y]
  mov cx, 3
  mov [index], 0
  loopDXP: ;מעלה את x ;D - delete, X - x, P - positive, N - negative
    ; שמירה
    push cx

    ; קליטה מהמערך
    mov bx, offset my_zone
    add bx, index
    mov al, [bx] ;save to al the color
    add [index], 1

    ; ציור
    mov bh, 0h
    mov cx, [x]
    mov dx, [y]
    ; al - the color from the array
    mov ah,0ch
    int 10h
    pop cx
    add [x],1
    loop loopDXP
  ; שינוי מיקום
  sub [y], 1
  sub [x], 1
  mov cx, 3
  loopDXN: ;מוריד את x
    push cx

    ; קליטה מהמערך
    mov bx, offset my_zone
    add bx, index
    mov al, [bx] ;save to al the color
    add [index], 1

    ; ציור
    mov bh,0h
    mov cx,[x]
    mov dx,[y]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [x],-1
    loop loopDXN
  sub [y], 1
  add [x], 1
  mov cx, 3
  loopDXP2: ;מעלה את x
    push cx
        

    ; קליטה מהמערך
    mov bx, offset my_zone
    add bx, index
    mov al, [bx]
    add [index], 1

    ; ציור
    mov bh,0h
    mov cx,[x]
    mov dx,[y]
    ; al - the color
    mov ah,0ch
    int 10h
    pop cx
    add [x],1
    loop loopDXP2
  pop [y]
  pop [x]
  ret
endp delete_char2

proc make_screen
    mov cx, 300
  loopSXP: ;מעלה את x ;s = screen x
    push cx
    mov bh,0h
    mov cx,[xs]
    mov dx,[ys]
    mov al,[colors]
    mov ah,0ch
    int 10h
    pop cx
    add [xs],1
    loop loopSXP
  mov cx, 180
  loopSYP:
    push cx
    mov bh,0h
    mov cx,[xs]
    mov dx,[ys]
    mov al,[colors]
    mov ah,0ch
    int 10h
    pop cx
    sub [ys],1
    loop loopSYP
  mov cx, 300
  loopSXN: ;מעלה את x
    push cx
    mov bh,0h
    mov cx,[xs]
    mov dx,[ys]
    mov al,[colors]
    mov ah,0ch
    int 10h
    pop cx
    sub [xs],1
    loop loopSXN
  mov cx, 180
  loopSYN:
    push cx
    mov bh,0h
    mov cx,[xs]
    mov dx,[ys]
    mov al,[colors]
    mov ah,0ch
    int 10h
    pop cx
    add [ys],1
    loop loopSYN
  ret
endp make_screen

proc print_array ;for debug
  push dx
  push ax
  push cx
  push bx
  mov cx, 9
  mov dh, 1
  mov [i], 0
  loopP:
    mov dl, 48
    add dl, dh
    mov ah, 02h
    int 21h

    mov bx, offset my_zone
    add bx, [i]
    sub bx, 1
    mov dl, 48
    add dl, [bx]
    mov ah, 02h
    int 21h

    mov dl, ' '
    int 21h

    add dh, 1
    add [i], 1
    loop loopP
  mov dl, '-'
  int 21h
  pop bx
  pop cx
  pop ax
  pop dx
  ret
endp print_array

proc paint_area_beta
start_paint:
  mov cx, 10 
  mov ax, maxx
  mov bx, maxy
  mov [paintx], ax
  mov [painty], bx


main_paint:
  ; שמירה
  push cx
  mov bh, 0h
  mov cx, paintx
  mov dx, painty
  mov ah, 0dh
  int 10h
  ; in al the color
  ; cmp al, 
  
    ; ציור
  mov bh, 0h
  mov cx, paintx
  mov dx, painty
  mov al,[color]
  mov ah,0ch
  int 10h
  pop cx
  
  loop main_paint

  ret
endp paint_area_beta

proc paint_area
  ret
endp paint_area



start:
  mov ax, @data
  mov ds, ax
  ; Graphic mode
  mov ax, 13h
  int 10h
  ; screen
  call make_screen
  mov ah, 00h
  int 16h


main:
  call my_character
  ; call print_array
  mov ah,00h
  int 16h
  cmp al, 'w'
  je movup
  cmp al, 's'
  je movdown
  cmp al, 'a'
  je movleft
  cmp al, 'd'
  je help ; help jump to movright
  cmp al, ' '
  je help2  ;jump to space
  call delete_char2
  jmp main

help:
  jmp movright

help2:
  jmp space

movup:
  call delete_char2
  mov bx, offset my_zone
  add bx, 7
  mov al, [bx] ;save to al the color
  cmp al, colors
  Je paintUP
  jmp main
  
paintUP:  ; just move
  sub [y], 1
  jmp main
  
movdown:
  call delete_char2
  mov bx, offset my_zone
  add bx, 1
  mov al, [bx] ;save to al the color
  cmp al, colors
  Je paintD
  jmp main

paintD:   ; just move (there is no sence to the name
  add [y], 1
  jmp main

movleft:
  call delete_char2
  mov bx, offset my_zone
  add bx, 5
  mov al, [bx] ;save to al the color
  cmp al, colors
  Je paintL
  jmp main

paintL:    ; just move
  sub [x], 1
  jmp main

movright:
  call delete_char2
  mov bx, offset my_zone
  add bx, 3
  mov al, [bx] ;save to al the color
  cmp al, colors
  Je paintR
  jmp main

paintR: ; just move
  add [x], 1
  jmp main


space: ; first space move
  call delete_char2
  
  mov bx, [x]
  mov maxx, bx
  mov minx, bx
  mov bx, [y]
  mov maxy, bx
  mov miny, bx
  ; cmp [x], 308
  
  call my_character
  mov ah,00h
  int 16h
  cmp al, 'w'
  je movup_first
  cmp al, 's'
  je movdown_first
  cmp al, 'd'
  je movright_first
  cmp al, 'a'
  je movleft_first ;jmp to movleft2
  
  call delete_char2
  jmp space
movup_first:
  cmp [y], 11 ;checks if gets outside the screen
  je space

  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 7
  mov dl, [bx]
  cmp dl, 0eh
  je space

  ; move
  call delete_char2
  sub [y], 1
  jmp space_main

movdown_first:
  cmp [y], 191 ;checks if gets outside the screen
  je space
  
  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 1
  mov dl, [bx]
  cmp dl, 0eh
  je space

  ; move
  call delete_char2
  add [y], 1
  jmp space_main

movleft_first:
  cmp [x], 9 ;checks if gets outside the screen
  je help5 ;jmp to space

  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 5
  mov dl, [bx]
  cmp dl, 0eh
  je help5

  ; move
  call delete_char2
  sub [x], 1
  jmp space_main

help5:
  jmp space

movright_first:
  cmp [x], 309 ;checks if gets outside the screen
  je help5 ;jmp to space

  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 3
  mov dl, [bx]
  cmp dl, 0eh
  je help5

  ; move
  call delete_char2
  add [x], 1
  jmp space_main


space_main:
  ; like main
  call my_character
  ; call make_screen
  ; call print_array
  
  ; checking minimum and maximum
  mov bx, [x]
  cmp bx, maxx
  jg maxx1
  cmp bx, minx
  jl minx1
  mov bx, [y]
  cmp bx, maxy
  jg maxy1
  cmp bx, miny
  jl miny1 
  jmp space_main_continue

maxx1:
  mov [maxx], bx
  jmp space_main_continue

minx1:
  mov [minx], bx
  jmp space_main_continue

maxy1:
  mov [maxy], bx
  jmp space_main_continue

miny1:
  mov [miny], bx
  jmp space_main_continue

space_main_continue:
  mov ah,00h
  int 16h
  cmp al, 'w'
  je movup2
  cmp al, 's'
  je movdown2
  cmp al, 'd'
  je help4 ;jmp to movright2
  cmp al, 'a'
  je help3 ;jmp to movleft2
  
  call delete_char2
  jmp space_main

help4:
  jmp movright2

help3:
  jmp movleft2


movup2:
  call delete_char2
  
  ; paint the red dot
  sub [y], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  ; sub dx, 1
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h

  mov bx, offset my_zone
  add bx, 7
  mov al, [bx] ;save to al the color
  cmp al, colors
  je help_main  ;jmp to main

  jmp space_main


movdown2:
  call delete_char2


  ; paint the shvil מצייר שובל
  add [y], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 2
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h

  mov bx, offset my_zone
  add bx, 1
  mov al, [bx] ;save to al the color
  cmp al, colors
  je help_main  ;jmp to main
  
  jmp space_main

movright2:
  call delete_char2

  ; paint
  add [x], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  ; sub cx, 2
  mov al,[color2]
  mov ah,0ch
  int 10h

  mov bx, offset my_zone
  add bx, 3
  mov al, [bx] ;save to al the color
  cmp al, colors
  je help_main  ;jmp to main

  jmp space_main

help_main:
  ; call make_screen
  sub [miny], 3
  add [maxx], 3
  add [maxy], 3

  ; ; debug - minimum point
  ; mov bh,0h
  ; mov cx, [minx]
  ; mov dx,[miny]
  ; sub dx, 3
  ; mov al,[color3]
  ; mov ah,0ch
  ; int 10h
  ; ; debug - maximum point
  ; mov bh,0h
  ; mov cx, [maxx]
  ; mov dx,[maxy]
  ; add dx, 3
  ; add cx, 3
  ; mov al,[color3]
  ; mov ah,0ch
  ; int 10h
  


  call paint_area

  jmp main

movleft2:
  call delete_char2

  ; paint the shvil מצייר שובל
  sub [x], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  add cx, 2
  mov al,[color2]
  mov ah,0ch
  int 10h

  mov bx, offset my_zone
  add bx, 5
  mov al, [bx] ;save to al the color
  cmp al, colors
  je help_main  ;jmp to main

  jmp space_main



mainloop:
  jmp mainloop
exit :
  mov ax, 4c00h
  int 21h
END start