IDEAL
MODEL small
STACK 100h
DATASEG
; cords:
x dw 309 ; the cords of the character
y dw 191
xs dw 10 ; the cords of the screen
ys dw 190
xs2 dw 10
ys2 dw 190
startx dw 0
starty dw 0 ;the cords when pressing space
paintx dw 0
painty dw 0
stopx dw 0 ;the last pixel we stop to paint
stopy dw 0

; colors:
color db 7
color2 db 4 ; צבע השובל
colors db 0eh  ;צבע המסך
colord db 2 ;for debug
colord2 db 5
colorg1 db 4 ;color
colorg2 db 0eh ;to color

; other:
index dw 0
i dw 0
number_of_runns dw 0
my_zone db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h
sum_pixels dw 53044


; booleans: 
;0 - non, 1 - up (w), 2 - down (s), 3 - right (d), 4 - left (a)
first_tav db 0

;0 - non, 1 - up (w), 2 - down (s), 3 - right (d), 4 - left (a)
final_tav db 0

is_complete_paint db 0



CODESEG


help12:
  jmp end_func

proc paint_area2 ; alagorithm flood_fill


    ; save to al the color
  mov bh, 0h
  mov cx, [paintx]
  push cx ;save cx (paintx)
  mov dx, [painty]
  push dx ;save dx (painty)
  mov ah, 0dh
  int 10h
  cmp al, 4
  je help12 ;jmp to end_func 
  cmp al, 0eh
  je help12 ; jmp to end_func
  cmp al, 8
  je help12 ; jmp to end_func
  ;32763
  cmp [number_of_runns], 20000
  jg help12 ; jmp to end_func
  cmp [number_of_runns], 19997
  je max_run
  cmp [number_of_runns], 19998
  je max_run
  cmp [number_of_runns], 19999
  je max_run
  cmp [number_of_runns], 20000
  je max_run

  
  ; cmp al, 7
  ; je end_func

  ; paint
  mov bh,0h
  mov cx,[paintx]
  mov dx,[painty]
  mov al,[colors]
  mov ah,0ch
  int 10h
  
  add [number_of_runns], 4
  ; go to all 4 directions
  add [paintx], 1
  call paint_area2
  sub [paintx], 2
  call paint_area2
  add [paintx], 1 ;return paintx to default
  add [painty], 1
  call paint_area2
  sub [painty], 2
  call paint_area2
  jmp end_func

  max_run:
    add [number_of_runns], 10
    mov ax, [paintx]
    mov [stopx], ax
    mov ax, [painty]
    mov [stopy], ax
    mov [is_complete_paint], 0

  end_func:  
    pop dx ;get paintyaaaa
    pop cx ;get paintx
    mov [paintx], cx ;return to the back cords
    mov [painty], dx
    ; cmp [painty], 100
    ; je countinu2
    ret

endp paint_area2

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
    ; sub bx, 1
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

proc color_to_color
  mov [xs2], 10
  mov [ys2], 190
  loopaint:
    mov bh, 0h
    mov cx, [xs2]
    mov dx, [ys2]
    mov ah, 0dh
    int 10h

    
    cmp al, [colorg1]
    je paint_red
    jmp loopend

  paint_red:
    mov bh,0h
    mov cx,[xs2]
    mov dx,[ys2]
    mov al,[colorg2]
    mov ah,0ch
    int 10h
  
  loopend:
    add [xs2], 1
    cmp [xs2], 311
    je upy
    jmp loopaint

  upy:
    mov [xs2], 10    
    sub [ys2], 1
    cmp [ys2], 9
    je endpaint
    jmp loopaint

  endpaint:
    ret
endp color_to_color


proc start_paint ;where to start painting ;right now not ready
  mov ax, startx
  mov [paintx], ax
  mov ax, starty
  mov [painty], ax



  mov al, [first_tav]
  mov ah, [final_tav]
  cmp al, 1
  je up_paint
  cmp al, 2
  je down_paint
  cmp al, 3
  je right_paint
  cmp al, 4
  je left_paint
  jmp exit

  up_paint:
    mov ax, [x]
    cmp ax, [startx]
    jge up_right
    jl up_left
    jmp exit

  up_right:
    sub [painty], 2
    add [paintx], 2
    ret

  up_left:
    sub [painty], 2
    ret

  down_paint:
    mov ax, [x]
    cmp ax, [startx]
    jge down_right
    jl down_left
    jmp exit

  down_right:
    add [paintx], 2
    ret
  down_left:
    ret

  right_paint:
    mov ax, [y]
    cmp ax, [starty]
    jge right_down
    jl right_up
    jmp exit

  right_down:
    add [paintx], 2
    ret

  right_up:
    add [paintx], 2
    sub [painty], 2
    ret

  left_paint:
    mov ax, [y]
    cmp ax, [starty]
    jge left_down
    jl left_up
    jmp exit

  left_down:
    ret

  left_up:
  sub [painty], 2
  ret

endp start_paint

proc start_paintN ;negative form of start_paint ;we change jg to jl and jl to jg
  mov ax, startx
  mov [paintx], ax
  mov ax, starty
  mov [painty], ax



  mov al, [first_tav]
  mov ah, [final_tav]
  cmp al, 1
  je up_paint2
  cmp al, 2
  je down_paint2
  cmp al, 3
  je right_paint2
  cmp al, 4
  je left_paint2
  jmp exit

  up_paint2:
    mov ax, [x]
    cmp ax, [startx]
    jl up_right2
    jge up_left2
    jmp exit

  up_right2:
    sub [painty], 2
    add [paintx], 2
    ret

  up_left2:
    sub [painty], 2
    ret

  down_paint2:
    mov ax, [x]
    cmp ax, [startx]
    jl down_right2
    jge down_left2
    jmp exit

  down_right2:
    add [paintx], 2
    ret
  down_left2:
    ret

  right_paint2:
    mov ax, [y]
    cmp ax, [starty]
    jl right_down2
    jge right_up2
    jmp exit

  right_down2:
    add [paintx], 2
    ret

  right_up2:
    add [paintx], 2
    sub [painty], 2
    ret

  left_paint2:
    mov ax, [y]
    cmp ax, [starty]
    jl left_down2
    jge left_up2
    jmp exit

  left_down2:
    ret

  left_up2:
  sub [painty], 2
  ret

endp start_paintN




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
  
  ; variables for the game
  mov x, 309 ; the cords of the character
  mov y, 191
  mov xs, 10 ; the cords of the screen
  mov ys, 190
  mov xs2, 10
  mov ys2, 190

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
  sub [y], 2
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
  add [y], 2
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
  sub [x], 2
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
  add [x], 2
  jmp main
space: ; first space move

  mov ax, [x]
  mov [startx], ax
  mov ax, [y]
  mov [starty], ax


  mov ah,00h
  int 16h
  cmp al, 'w'
  je movup_first
  cmp al, 's'
  je movdown_first
  cmp al, 'd'
  je help7 ; jmp to movright_first
  cmp al, 'a'
  je help8 ;jmp to movleft_first
  cmp al, ' '
  je help6
  
  call delete_char2
  jmp space

help8:
  jmp movleft_first

help7:
  jmp movright_first
help6:
  call delete_char2
  jmp main
movup_first:
  cmp [y], 11 ;checks if gets outside the screen
  je space

  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 7
  mov dl, [bx]
  cmp dl, 0eh
  je space ;jmp to space

  mov [first_tav], 1

  ; move
  call delete_char2
  sub [y], 2

  ; paint in red
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h
  sub dx, 1
  int 10h

  jmp space_main

movdown_first:
  cmp [y], 191 ;checks if gets outside the screen
  je help5 ;jmp to space
  
  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 1
  mov dl, [bx]
  cmp dl, 0eh
  je help5 ;jmp to space

  mov [first_tav], 2
  ; move
  call delete_char2
  add [y], 2
  ; paint
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 2
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h
  add dx, 1
  int 10h

  jmp space_main

help5:
  jmp space

movleft_first:
  cmp [x], 9 ;checks if gets outside the screen
  je help5 ;jmp to space

  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 5
  mov dl, [bx]
  cmp dl, 0eh
  je help5

  mov [first_tav], 4

  ; move
  call delete_char2
  sub [x], 2
  ; paint
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  add cx, 2
  mov al,[color2]
  mov ah,0ch
  int 10h
  sub cx, 1
  int 10h
  
  jmp space_main


movright_first:
  cmp [x], 309 ;checks if gets outside the screen
  je help5 ;jmp to space

  ; checks if we already go to yellow
  mov bx, offset my_zone
  add bx, 3
  mov dl, [bx]
  cmp dl, 0eh
  je help5

  mov [first_tav], 3

  ; move
  call delete_char2
  add [x], 2
  ; paint
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  ; sub cx, 2
  mov al,[color2]
  mov ah,0ch
  int 10h
  add cx, 1
  int 10h

  jmp space_main


space_main:
  call my_character
  call delete_char2
  
  ; call print_array
  mov bx, offset my_zone
  mov cx, 8
yellow_check_loop:
  ; mov ax, [bx]
  ; cmp [bx], 14
  ; je help_main
  
  mov dl, 48
  add dl, [bx] ;if it yellow [bx] = 14
  cmp dl, 62
  je help9 ; jump to help_main

  add bx, 1
  loop yellow_check_loop

  ; the countinu of space main:
  
  ; like main
  ; call make_screen
  ; call print_array
  call my_character
  mov ah,00h
  int 16h
  cmp al, 'w'
  je movup2
  cmp al, 's'
  je movdown2
  cmp al, 'd'
  je help10 ;jmp to movright
  cmp al, 'a'
  je help3 ;jmp to movleft2
  call delete_char2
  jmp space_main

help10:
  jmp movright2
help9:
  jmp help_main
help3:
  jmp movleft2
movup2:
  call delete_char2
  

  ; paint the red dot
  sub [y], 2
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  ; sub dx, 1
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h

  sub dx, 1

  ; check if red
  mov ah, 0dh
  int 10h
  cmp al, [color2]
  je help11 ;jmp to exit

  mov ah, 0ch
  mov al,[color2]
  int 10h

  ; call print_array



  ; mov bx, offset my_zone
  ; add bx, 7
  ; mov al, [bx] ;save to al the color
  ; cmp al, 0eh
  ; je help_main  ;jmp to main
  mov final_tav, 1
  jmp space_main

help11:
  jmp exit
movdown2:
  call delete_char2
  ; paint the shvil מצייר שובל
  add [y], 2
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 2
  add cx, 1
  mov al,[color2]
  mov ah,0ch
  int 10h
  
  

  add dx, 1
  
    ; check if red
  mov ah, 0dh
  int 10h
  cmp al, [color2]
  je help11 ;jmp to exit

  mov ah, 0ch
  mov al, [color2]
  int 10h
  ; mov bx, offset my_zone
  ; add bx, 1
  ; mov al, [bx] ;save to al the color
  ; cmp al, 0eh
  ; je help_main  ;jmp to main
  mov final_tav, 2
  jmp space_main

help_main: ;the painting area (does'nt change the name because I don't want to change the name in all the code)
  ; call make_screen
  ; mov al, [first_tav]
  ; mov ah, [final_tav]
  ; cmp al, ah
  jmp regular_paint
  mov [colorg1], 4
  mov [colorg2], 0eh
  call color_to_color
  jmp main

help13: 
  jmp countinu_regular_paint

regular_paint: ;first check if the area bigger than we can paint
  mov [number_of_runns], 0
  call start_paint
  mov [colors], 8
  call paint_area2

  ; grey to black
  mov [colorg1], 8
  mov [colorg2], 0
  call color_to_color

  cmp [number_of_runns], 20000
  jl help13 ;jmp to countinu_regular_paint 

  mov [number_of_runns], 0
  call start_paintN
  call paint_area2

  ; grey to black
  mov [colorg1], 8
  mov [colorg2], 0
  call color_to_color


  cmp [number_of_runns], 20000
  jl countinu_regular_paint

  mov [number_of_runns], 0
  mov [colors], 0eh
  
  ; ; red to black
  ; mov [colorg1], 4
  ; mov [colorg2], 0
  ; call color_to_color

  ; call make_screen
  call start_paint
  call paint_area2
endless_paint: ;paint again and again until we paint all the area
  mov [number_of_runns], 0
  mov [is_complete_paint], 1
  mov ax, [stopx]
  mov [paintx], ax
  mov ax, [stopy]
  mov [painty], ax
  ; painting
  call paint_area2

  cmp [is_complete_paint], 0
  je help14  ;jmp to endless_paint

    ; red to yellow
  mov [colorg1], 4
  mov [colorg2], 0eh
  call color_to_color

  jmp main
help14: 
jmp endless_paint

countinu_regular_paint:
  mov [colors], 0eh
  mov number_of_runns, 0
  call paint_area2
  ; jmp mainloop
  
  ; red to yellow
  mov [colorg1], 4
  mov [colorg2], 0eh
  call color_to_color

  jmp main

movright2:
  call delete_char2
  ; paint
  add [x], 2
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  ; sub cx, 2


  mov al,[color2]
  mov ah,0ch
  int 10h
  add cx, 1
  
    ; check if red
  mov ah, 0dh
  int 10h
  cmp al, [color2]
  je exit ;jmp to exit

  mov ah, 0ch
  mov al, [color2]
  int 10h
  ; mov bx, offset my_zone
  ; add bx, 3
  ; mov al, [bx] ;save to al the color
  ; cmp al, 0eh
  ; je help_main  ;jmp to main'
  mov final_tav, 3
  jmp space_main
movleft2:
  call delete_char2
  ; paint the shvil מצייר שובל
  sub [x], 2
  mov bh,0h
  mov cx,[x]
  mov dx,[y]
  sub dx, 1
  add cx, 2
  
  mov al,[color2]
  mov ah,0ch
  int 10h

  sub cx, 1

  ; check if red
  mov ah, 0dh
  int 10h
  cmp al, [color2]
  je exit ;jmp to exit

  mov al, [color2]
  mov ah, 0ch
  int 10h
  


  ; mov bx, offset my_zone
  ; add bx, 5
  ; mov al, [bx] ;save to al the color
  ; cmp al, 0eh
  ; je help_main  ;jmp to main
  mov final_tav, 4
  jmp space_main



mainloop:
  jmp mainloop
exit:
  jmp start
  mov ax, 4c00h
  int 21h
END start