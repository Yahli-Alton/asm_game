IDEAL
MODEL small
STACK 100h
DATASEG
x dw 308
y dw 191
xs dw 10
ys dw 190
color db 7
color2 db 4 ; צבע השובל
colors db 4  ;צבע המסך
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
  call delete_char2
  jmp main

help:
  jmp movright

movup:
  call delete_char2
  mov bx, offset my_zone
  add bx, 7
  mov al, [bx] ;save to al the color
  cmp al, 4
  Je paintUP
  jmp main
  
paintUP:  ; paint the shvil מצייר שובל
  sub [y], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  ; sub dx, 1
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h

  jmp main
  
movdown:
  call delete_char2
  mov bx, offset my_zone
  add bx, 1
  mov al, [bx] ;save to al the color
  cmp al, 4
  Je paintD
  jmp main

paintD:   ; paint the shvil מצייר שובל
  add [y], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 2
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h
  
  jmp main

movleft:
  call delete_char2
  mov bx, offset my_zone
  add bx, 5
  mov al, [bx] ;save to al the color
  cmp al, 4
  Je paintL
  jmp main

paintL:    ; paint the shvil מצייר שובל
  sub [x], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  add cx, 2
  mov al,[color2]
  mov ah,0ch
  int 10h

  jmp main

movright:
  call delete_char2
  mov bx, offset my_zone
  add bx, 3
  mov al, [bx] ;save to al the color
  cmp al, 4
  Je paintR
  jmp main

paintR:
  add [x], 1
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  ; sub cx, 2
  mov al,[color2]
  mov ah,0ch
  int 10h

  jmp main


mainloop:
  jmp mainloop
exit :
  mov ax, 4c00h
  int 21h
END start