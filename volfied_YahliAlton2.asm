IDEAL
MODEL small
STACK 100h
DATASEG
x dw 308 ; the cords of the character
y dw 191
xs dw 10 ; the cords of the screen
ys dw 190
startx dw 0
starty dw 0 ;the cords when pressing space
paintx dw 0
painty dw 0
color db 7
color2 db 4 ; צבע השובל
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
proc paint_area2 ; algorithm flood_fill
    ; save to al the color
  mov bh, 0h
  mov cx, [paintx]
  push cx ;save cx (paintx)
  mov dx, [painty]
  push dx ;save dx (painty)
  mov ah, 0dh
  int 10h
  cmp al, 4
  je end_func 
  cmp al, 0eh
  je end_func
  
  ; paint
  mov bh,0h
  mov cx,[paintx]
  mov dx,[painty]
  mov al,[color2]
  mov ah,0ch
  int 10h
  
  ; go to all 4 directions
  add paintx, 1
  call paint_area2
  sub paintx, 2
  call paint_area2
  add paintx, 1 ;return paintx to default
  add painty, 1
  call paint_area2
  sub painty, 2
  call paint_area2

end_func:
  pop dx ;get painty
  pop cx ;get paintx
  mov [paintx], cx ;return to the back cords
  mov [painty], dx
  ret
endp paint_area2

proc start_paint ;where to start painting ;right now not ready
  mov ax, startx
  mov [paintx], ax
  ; add [paintx], 1
  mov ax, starty
  mov [painty], ax
  sub [painty], 2
  ret
endp start_paint
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
  cmp al, 0eh
  Je paintUP
  jmp main
  
paintUP:  ; paint the shvil מצייר שובל
  sub [y], 1
  jmp main
  
movdown:
  call delete_char2
  mov bx, offset my_zone
  add bx, 1
  mov al, [bx] ;save to al the color
  cmp al, 0eh
  Je paintD
  jmp main
paintD:   ; paint the shvil מצייר שובל
  add [y], 1
  jmp main
movleft:
  call delete_char2
  mov bx, offset my_zone
  add bx, 5
  mov al, [bx] ;save to al the color
  cmp al, 0eh
  Je paintL
  jmp main
paintL:    ; paint the shvil מצייר שובל
  sub [x], 1
  jmp main
movright:
  call delete_char2
  mov bx, offset my_zone
  add bx, 3
  mov al, [bx] ;save to al the color
  cmp al, 0eh
  Je paintR
  jmp main
paintR:
  add [x], 1
  jmp main
space:
  call delete_char2
  mov ax, [x]
  mov [startx], ax
  mov ax, [y]
  mov [starty], ax
  ; cmp [x], 308
space_main:
  ; like main
  call make_screen
  call my_character
  ; call print_array
  mov ah,00h
  int 16h
  cmp al, 'w'
  je movup2
  cmp al, 's'
  je movdown2
  cmp al, 'd'
  je movright2
  cmp al, 'a'
  je help3 ;jmp to movleft2
  call delete_char2
  jmp space_main
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
  cmp al, 0eh
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
  cmp al, 0eh
  je help_main  ;jmp to main
  
  jmp space_main

help_main:
  ; call make_screen
  call start_paint
  call paint_area2
  jmp main

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
  cmp al, 0eh
  je help_main  ;jmp to main
  jmp space_main
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
  cmp al, 0eh
  je help_main  ;jmp to main
  jmp space_main
mainloop:
  jmp mainloop
exit :
  mov ax, 4c00h
  int 21h
END start