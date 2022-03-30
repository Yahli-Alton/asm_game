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
xe dw 50 ; enemy x cord
ye dw 50 ; enemy y
xe2 dw 100
ye2 dw 100


; colors:
color db 7
color2 db 4 ; צבע השובל
colors db 0eh  ;צבע המסך
colord db 2 ;for debug
colord2 db 5
colorg1 db 4 ;color
colorg2 db 0eh ;to color
enemy_color db 5
enemy_color2 db 23

; for precents caculate:
precent_per_paint db 20
sum_pixels dw 530 ;the number of pixels is 53,044
count_paint db 0 ;count the number of paint use in paint_function
paint1_precent dw 0
paint2_precent dw 0
screen_paint_precent dw 0



; booleans: 
;0 - non, 1 - up (w), 2 - down (s), 3 - right (d), 4 - left (a)
first_tav db 0
final_tav db 0

is_complete_paint db 0
is_space db 0 ; 0 - regular, 1 - first_space, 2 - space

; arrays:
my_zone db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h ;my character
enemy1_character db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 10h, 11h, 12h, 13h
enemy2_character db 1h, 2h, 3h, 4h, 5h, 6h, 7h, 8h, 9h, 10h, 11h, 12h, 13h


; other:
index dw 0
i dw 0
i2 dw 0
number_of_runns dw 0
; max dw 65535 ; the maximum value we can put in dw
enemy_index dw 0
enemy_index2 dw 0

DELAY dw 10

speedx dw 1
speedy dw 1

speedx2 dw 1 ; for enemy2
speedy2 dw 1 ; for enemy2

message2 db 10, 13, 10, 13, 10, 13, 'You win! GG', 10, 13, '$'

message3 db "press 'e' to play again", 10, 13, '$'
message4 db "'q' to exit or 'r' for rules and speed$"

message5 db 10, 13, 10, 13, 10, 13, 'You lost! better luck next time', 10, 13, '$'

rules db 10,13,10,13,"Rules & Controls:", 10, 13, 10, 13, "You are the grey character", 10, 13, "You move with:",10, 13,"'w' - move up", 10, 13,"'s' - move down", 10, 13, "'d' - move left", 10, 13,"'a' - move right", 10, 13,10, 13, "If you touch any enemy (in blue/purple), you lose", 10, 13, "Stay at the yellow zone for being safe",10, 13, "But you can go out from the yellow zone with 'space'", 10, 13, "Then you can claim part of the level's area",10, 13, "But be careful, if you crossing your own line, you lose", 10, 13 ,"If you claim 75% of the level's area you win",10, 13, 10, 13, "Good luck!",10, 13, 10, 13, "Choose the speed for the game:", 10, 13, 10, 13,"1 - easy, 2 - normal, 3 - hard, 4 - crazy" , '$'
; rules db "rules & controls:", 10, 13, 10, 13, "you are the grey character", 10, 13, "you move with:",10, 13,"'w' - move up", 10, 13,"s - move down", 10, 13, "d - move left", 10, 13,"a - move right", 10, 13,10, 13,'$'


CODESEG

jmp start

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
  cmp al, 10h
  je help12 ; jmp to end_func
  ;32763
  cmp [number_of_runns], 10600
  jg help12 ; jmp to end_func
  cmp [number_of_runns], 10600
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
  
  add [number_of_runns], 1
  ; go to all 4 directions
  ; right
  add [paintx], 1
  call paint_area2
  sub [paintx], 1
  sub [painty], 1 ;up
  call paint_area2
  add [painty], 1
  sub [paintx], 1
  call paint_area2 ;left
  add [paintx], 1
  add [painty], 1
  call paint_area2 ;down
  jmp end_func

  max_run:
    add [number_of_runns], 1
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
proc print_array ;for debug ;for my_character
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

proc print_array2 ;for debug ;for enemey_character
  push dx
  push ax
  push cx
  push bx
  mov cx, 14
  mov dh, 1
  mov [i2], 0
  loopP2:
    mov dl, 48
    add dl, dh
    mov ah, 02h
    int 21h
    mov bx, offset enemy1_character
    add bx, [i2]
    ; sub bx, 1
    mov dl, 48
    add dl, [bx]
    
    mov ah, 02h
    int 21h
    mov dl, ' '
    int 21h
    add dh, 1
    add [i2], 1
    loop loopP2
  mov dl, '-'
  int 21h
  pop bx
  pop cx
  pop ax
  pop dx 
  ret
endp print_array2

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

proc start_paint1
  mov ax, startx
  mov [paintx], ax
  mov ax, starty
  mov [painty], ax

  mov al, [first_tav]
  mov ah, [final_tav]
  cmp al, 1
  je up_right3
  cmp al, 2
  je down_right3
  cmp al, 3
  je right_down3
  cmp al, 4
  je left_down3
  jmp exit


  up_right3:
    sub [painty], 2
    add [paintx], 2
    ret

  down_right3:
    add [paintx], 2
    ret

  right_down3:
    add [paintx], 2
    ret


  left_down3:
    ret


endp start_paint1

proc start_paint2
  mov ax, startx
  mov [paintx], ax
  mov ax, starty
  mov [painty], ax

  mov al, [first_tav]
  mov ah, [final_tav]
  cmp al, 1
  je up_left3
  cmp al, 2
  je down_left3
  cmp al, 3
  je right_up3
  cmp al, 4
  je left_up3
  jmp exit

  up_left3:
    sub [painty], 2
    ret

  down_left3:
    ret

  right_up3:
    add [paintx], 2
    sub [painty], 2
    ret


  left_up3:
  sub [painty], 2
  ret
endp start_paint2

proc print_precents
  mov ax, [screen_paint_precent]
  mov bl, 10
  div bl
  
  ; al = ax div 10 = a_ (first char)
  ; ah = ax mod 10 = _a (last char)
  mov bl, al
  mov bh, ah

  ; go to thee start of the line
  mov dl, 13
  mov ah, 2
  int 21h
  
  mov dl, 48
  add dl, bl
  int 21h
  
  mov dl, 48
  add dl, bh
  int 21h

  mov ax, [screen_paint_precent]
  cmp ax, 75
  jge player_win

  ret
endp print_precents

player_win:
  push seg message2
  
  mov dx, offset message2
  mov ah, 9h
  int 21h

  push seg message3
  mov dx, offset message3
  mov ah, 9h
  int 21h

  push seg message4
  mov dx, offset message4
  mov ah, 9h
  int 21h

check_start_or_exit:
  mov ah, 00h
  int 16h

  cmp al, 'e'
  je help16
  cmp al, 'q'
  je help17
  cmp al, 'r'
  je help21
  jmp check_start_or_exit

help16:
  jmp reset

help17:
  jmp exit

help21:
  jmp start

player_lose:
  push seg message5
  
  mov dx, offset message5
  mov ah, 9h
  int 21h

  push seg message3
  mov dx, offset message3
  mov ah, 9h
  int 21h

  push seg message4
  mov dx, offset message4
  mov ah, 9h
  int 21h
  
  jmp check_start_or_exit

proc enemy_character
  push [xe]
  push [ye]
  mov [enemy_index], 0
    ; שמירה
  mov bh, 0h
  mov cx, [xe]
  mov dx, [ye]
  mov ah, 0dh
  int 10h
    ;שמירה במערך
  mov bx, offset enemy1_character
  add bx, [enemy_index]
  mov [bx], al
  add [enemy_index], 1
  
    ; ציור
  mov bh, 0h
  mov cx, [xe]
  mov dx, [ye]
  mov al,[enemy_color]
  mov ah,0ch
  int 10h
  
  sub [xe], 1
  add [ye], 1

  mov cx, 3
  loopXP3: ;מעלה את x
    ; שמירה
    push cx
    mov bh, 0h
    mov cx, [xe]
    mov dx, [ye]
    mov ah, 0dh
    int 10h
    ;שמירה במערך
    mov bx, offset enemy1_character
    add bx, [enemy_index]
    mov [bx], al
    add [enemy_index], 1
    ; ציור
    mov bh, 0h
    mov cx, [xe]
    mov dx, [ye]
    mov al,[enemy_color]
    mov ah,0ch
    int 10h
    pop cx
    add [xe],1
    loop loopXP3
  ; שינוי מיקום
  add [ye], 1
  mov cx, 5
  loopXN2: ;מוריד את x
    push cx
    
    mov bh, 0h
    mov cx, [xe]
    mov dx, [ye]
    mov ah, 0dh
    int 10h
    ;שמירה במערך
    mov bx, offset enemy1_character
    add bx, [enemy_index]
    mov [bx], al
    add [enemy_index], 1
    ; ציור
    mov bh,0h
    mov cx,[xe]
    mov dx,[ye]
    mov al,[enemy_color]
    mov ah,0ch
    int 10h
    pop cx
    add [xe],-1
    loop loopXN2
  add [ye], 1
  add [xe], 2
  mov cx, 3
  loopXP4: ;מעלה את x
    ; שמירה
    push cx
    mov bh, 0h
    mov cx, [xe]
    mov dx, [ye]
    mov ah, 0dh
    int 10h
    ;שמירה במערך
    mov bx, offset enemy1_character
    add bx, [enemy_index]
    mov [bx], al
    add [enemy_index], 1
    ; ציור
    mov bh, 0h
    mov cx, [xe]
    mov dx, [ye]
    mov al,[enemy_color]
    mov ah,0ch
    int 10h
    pop cx
    add [xe],1
    loop loopXP4
  ; שינוי מיקום
  add [ye], 1
  sub [xe], 2  

    ; שמירה
  mov bh, 0h
  mov cx, [xe]
  mov dx, [ye]
  mov ah, 0dh
  int 10h
    ;שמירה במערך
  mov bx, offset enemy1_character
  add bx, [enemy_index]
  mov [bx], al
  ; add [enemy_index], 1

  
    ; ציור
  mov bh, 0h
  mov cx, [xe]
  mov dx, [ye]
  mov al,[enemy_color]
  mov ah,0ch
  int 10h


  pop [ye]
  pop [xe]
  ret
endp enemy_character


proc enemy_character2
  push [xe2]
  push [ye2]
  mov [enemy_index2], 0
    ; שמירה
  mov bh, 0h
  mov cx, [xe2]
  mov dx, [ye2]
  mov ah, 0dh
  int 10h
    ;שמירה במערך
  mov bx, offset enemy2_character
  add bx, [enemy_index2]
  mov [bx], al
  add [enemy_index2], 1
  
    ; ציור
  mov bh, 0h
  mov cx, [xe2]
  mov dx, [ye2]
  mov al,[enemy_color2]
  mov ah,0ch
  int 10h
  
  sub [xe2], 1
  add [ye2], 1

  mov cx, 3
  loopXP6: ;מעלה את x
    ; שמירה
    push cx
    mov bh, 0h
    mov cx, [xe2]
    mov dx, [ye2]
    mov ah, 0dh
    int 10h
    ;שמירה במערך
    mov bx, offset enemy2_character
    add bx, [enemy_index2]
    mov [bx], al
    add [enemy_index2], 1
    ; ציור
    mov bh, 0h
    mov cx, [xe2]
    mov dx, [ye2]
    mov al,[enemy_color2]
    mov ah,0ch
    int 10h
    pop cx
    add [xe2],1
    loop loopXP6
  ; שינוי מיקום
  add [ye2], 1
  mov cx, 5
  loopXN3: ;מוריד את x
    push cx
    
    mov bh, 0h
    mov cx, [xe2]
    mov dx, [ye2]
    mov ah, 0dh
    int 10h
    ;שמירה במערך
    mov bx, offset enemy2_character
    add bx, [enemy_index2]
    mov [bx], al
    add [enemy_index2], 1
    ; ציור
    mov bh,0h
    mov cx,[xe2]
    mov dx,[ye2]
    mov al,[enemy_color2]
    mov ah,0ch
    int 10h
    pop cx
    add [xe2],-1
    loop loopXN3
  add [ye2], 1
  add [xe2], 2
  mov cx, 3
  loopXP5: ;מעלה את x
    ; שמירה
    push cx
    mov bh, 0h
    mov cx, [xe2]
    mov dx, [ye2]
    mov ah, 0dh
    int 10h
    ;שמירה במערך
    mov bx, offset enemy2_character
    add bx, [enemy_index2]
    mov [bx], al
    add [enemy_index2], 1
    ; ציור
    mov bh, 0h
    mov cx, [xe2]
    mov dx, [ye2]
    mov al,[enemy_color2]
    mov ah,0ch
    int 10h
    pop cx
    add [xe2],1
    loop loopXP5
  ; שינוי מיקום
  add [ye2], 1
  sub [xe2], 2  

    ; שמירה
  mov bh, 0h
  mov cx, [xe2]
  mov dx, [ye2]
  mov ah, 0dh
  int 10h
    ;שמירה במערך
  mov bx, offset enemy2_character
  add bx, [enemy_index2]
  mov [bx], al
  ; add [enemy_index], 1

  
    ; ציור
  mov bh, 0h
  mov cx, [xe2]
  mov dx, [ye2]
  mov al,[enemy_color2]
  mov ah,0ch
  int 10h


  pop [ye2]
  pop [xe2]
  ret
endp enemy_character2



proc enemy_delete
  push [xe]
  push [ye]
  mov [enemy_index], 0
  ; קליטה מהמערך
  mov bx, offset enemy1_character
  add bx, [enemy_index]
  mov al, [bx] ;save to al the color
  add [enemy_index], 1
  cmp al, [enemy_color2]
  je black
  jmp a ;countinu
  black:
  mov al, 0
  a:
  ; ציור
  mov bh,0h
  mov cx,[xe]
  mov dx,[ye]
  ; the color is - al
  mov ah,0ch
  int 10h
  
  sub [xe], 1
  add [ye], 1

  mov cx, 3
  loopDXP3: ;מעלה את x
    ; שמירה
    push cx
    ; קליטה מהמערך
    mov bx, offset enemy1_character
    add bx, [enemy_index]
    mov al, [bx] ;save to al the color
    add [enemy_index], 1
    cmp al, [enemy_color2]
    je black2
    jmp b ;countinu
  black2:
    mov al, 0
  b:
    ; ציור
    mov bh,0h
    mov cx,[xe]
    mov dx,[ye]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [xe],1
    loop loopDXP3
  ; שינוי מיקום
  add [ye], 1
  mov cx, 5
  loopDXN2: ;מוריד את x
    push cx
    
    ; קליטה מהמערך
    mov bx, offset enemy1_character
    add bx, [enemy_index]
    mov al, [bx] ;save to al the color
    add [enemy_index], 1
    cmp al, [enemy_color2]
    je black3
    jmp c ;countinu
  black3:
    mov al, 0
  c:
    ; ציור
    mov bh,0h
    mov cx,[xe]
    mov dx,[ye]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [xe],-1
    loop loopDXN2
  add [ye], 1
  add [xe], 2
  mov cx, 3
  loopDXP4: ;מעלה את x
    ; שמירה
    push cx
    ; קליטה מהמערך
    mov bx, offset enemy1_character
    add bx, [enemy_index]
    mov al, [bx] ;save to al the color
    add [enemy_index], 1
    cmp al, [enemy_color2]
    je black4
    jmp d ;countinu
  black4:
    mov al, 0
  d:
    ; ציור
    mov bh,0h
    mov cx,[xe]
    mov dx,[ye]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [xe],1
    loop loopDXP4
  ; שינוי מיקום
  add [ye], 1
  sub [xe], 2  

  ; קליטה מהמערך
  mov bx, offset enemy1_character
  add bx, [enemy_index]
  mov al, [bx] ;save to al the color
  add [enemy_index], 1
  cmp al, [enemy_color2]
  je black5
  jmp e ;countinu
  black5:
  mov al, 0
  e:
  ; ציור
  mov bh,0h
  mov cx,[xe]
  mov dx,[ye]
  ; the color is - al
  mov ah,0ch
  int 10h


  pop [ye]
  pop [xe]
  ret
endp enemy_delete


proc enemy_delete2
  push [xe2]
  push [ye2]
  mov [enemy_index2], 0
  ; קליטה מהמערך
  mov bx, offset enemy2_character
  add bx, [enemy_index2]
  mov al, [bx] ;save to al the color
  add [enemy_index2], 1
  cmp al, [enemy_color]
  je black6
  jmp f ;countinu
  black6:
  mov al, 0
  f:
  ; ציור
  mov bh,0h
  mov cx,[xe2]
  mov dx,[ye2]
  ; the color is - al
  mov ah,0ch
  int 10h
  
  sub [xe2], 1
  add [ye2], 1

  mov cx, 3
  loopDXP5: ;מעלה את x
    ; שמירה
    push cx
    ; קליטה מהמערך
    mov bx, offset enemy2_character
    add bx, [enemy_index2]
    mov al, [bx] ;save to al the color
    add [enemy_index2], 1
    cmp al, [enemy_color]
    je black7
    jmp g ;countinu
  black7:
    mov al, 0
  g:
    ; ציור
    mov bh,0h
    mov cx,[xe2]
    mov dx,[ye2]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [xe2],1
    loop loopDXP5
  ; שינוי מיקום
  add [ye2], 1
  mov cx, 5
  loopDXN3: ;מוריד את x
    push cx
    
    ; קליטה מהמערך
    mov bx, offset enemy2_character
    add bx, [enemy_index2]
    mov al, [bx] ;save to al the color
    add [enemy_index2], 1
    cmp al, [enemy_color]
    je black8
    jmp h ;countinu
  black8:
    mov al, 0
  h:
    ; ציור
    mov bh,0h
    mov cx,[xe2]
    mov dx,[ye2]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [xe2],-1
    loop loopDXN3
  add [ye2], 1
  add [xe2], 2
  mov cx, 3
  loopDXP6: ;מעלה את x
    ; שמירה
    push cx
    ; קליטה מהמערך
    mov bx, offset enemy2_character
    add bx, [enemy_index2]
    mov al, [bx] ;save to al the color
    add [enemy_index2], 1
    cmp al, [enemy_color]
    je black9
    jmp i1 ;countinu
  black9:
    mov al, 0
  i1:
    ; ציור
    mov bh,0h
    mov cx,[xe2]
    mov dx,[ye2]
    ; the color is - al
    mov ah,0ch
    int 10h
    pop cx
    add [xe2],1
    loop loopDXP6
  ; שינוי מיקום
  add [ye2], 1
  sub [xe2], 2  

  ; קליטה מהמערך
  mov bx, offset enemy2_character
  add bx, [enemy_index2]
  mov al, [bx] ;save to al the color
  add [enemy_index2], 1
  cmp al, [enemy_color]
  je black10
  jmp j ;countinu
  black10:
  mov al, 0
  j:
  ; ציור
  mov bh,0h
  mov cx,[xe2]
  mov dx,[ye2]
  ; the color is - al
  mov ah,0ch
  int 10h


  pop [ye2]
  pop [xe2]
  ret
endp enemy_delete2


proc my_delay
    push cx
    mov cx, 63000
    None_loop:
        loop None_loop
    pop cx
    ret
endp my_delay

proc my_delay2
  push cx
  mov cx, [DELAY]
  None_loop2:
      call my_delay
      loop None_loop2
  pop cx
  ret
endp my_delay2



help15:
  jmp player_lose

run_screen:
  call enemy_delete
  ; moving enemy
  mov ax, [speedx]
  add [xe], ax
  mov ax, [speedy]
  add [ye], ax

  call enemy_character
  call my_delay2

  ; check if in red line:
  mov bx, offset enemy1_character
  mov cx, 14
red_check_loop:
  mov ax, [bx]
  cmp [bx], 4
  je help15
  add bx, 1
  loop red_check_loop

  ; change speed:
  mov bx, offset enemy1_character
  add bx, 6
  mov ax, [bx]
  cmp al, 0eh ; yellow
  je delete_enemy2

after_delete_enemy:

  mov bx, offset enemy1_character
  mov ax, [bx]
  cmp ax, 0eh ; yellow
  je changey1 ; or
  cmp ax, 7   ; grey
  je changey1
  cmp ax, 23   ; other enemy
  je changey1

after_changey1:
  
  add bx, 4
  mov ax, [bx]
  cmp ax, 0eh
  je changex1
  cmp ax, 7   ; grey
  je changex1
  cmp ax, 23   ; other enemy
  je changex1

after_changex1:

  add bx, 4
  mov ax, [bx]
  cmp ax, 0eh
  je changex2
  cmp ax, 7   ; grey
  je changex2
  cmp ax, 23   ; other enemy
  je changex2

after_changex2:
  
  mov bx, offset enemy1_character
  add bx, 12
  mov ax, [bx]
  cmp al, 0eh
  je changey2
  cmp ax, 7   ; grey
  je changey2
  cmp ax, 23   ; other enemy
  je changey2


after_changey2:
  jmp run_screen2
changey1:
  neg [speedy]


  jmp after_changey1

changey2:
  neg [speedy]

  jmp after_changey2

changex1:
  neg [speedx]

  jmp after_changex1

changex2:
  neg [speedx]
  

  jmp after_changex2

delete_enemy2:
  call enemy_delete
  ; paint the area the enemy was there in yellow:
  ; mov ax, [speedx]
  ; sub [xe], ax
  ; sub [xe], ax
  ; sub [xe], ax
  ; mov ax, [speedy]
  ; sub [ye], ax
  ; mov cx, 13
  ; mov bx, offset enemy1_character
  ; loop_paint_black_enemy:
  ;   mov [bx], 0
  ;   add bx, 1
  ;   loop loop_paint_black_enemy


  ; call enemy_delete
  mov [xe], 10
  mov [ye], 200
  mov [speedx], 0
  mov [speedy], 0
  ; mov [bx], 0



  call enemy_character
  jmp check_press


; the copy from here!!!!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
help20:
  jmp delete_enemy2_2
help19:
  jmp player_lose

run_screen2:
  call enemy_delete2
  ; moving enemy
  mov ax, [speedx2]
  add [xe2], ax
  mov ax, [speedy2]
  add [ye2], ax

  call enemy_character2
  call my_delay2

  ; check if in red line:
  mov bx, offset enemy2_character
  mov cx, 14
red_check_loop2:
  mov ax, [bx]
  cmp [bx], 4
  je help19
  add bx, 1
  loop red_check_loop2

  ; change speed:
  mov bx, offset enemy2_character
  add bx, 6
  mov ax, [bx]
  cmp al, 0eh ; yellow
  je help20 ; jmp delete_enemy2_2

after_delete_enemy2_2:

  ; mov is_after_paint2, 0

  mov bx, offset enemy2_character
  mov ax, [bx]
  cmp ax, 0eh ; yellow
  je changey1_2 ; or
  cmp ax, 7   ; grey
  je changey1_2
  cmp ax, 5   ; other enemy
  je changey1_2

after_changey1_2:
  
  add bx, 4
  mov ax, [bx]
  cmp ax, 0eh
  je changex1_2
  cmp ax, 7   ; grey
  je changex1_2
  cmp ax, 7   ; other enemy
  je changex1_2

after_changex1_2:

  add bx, 4
  mov ax, [bx]
  cmp ax, 0eh
  je changex2_2
  cmp ax, 7   ; grey
  je changex2_2
  cmp ax, 5   ; other enemy
  je changex2_2

after_changex2_2:
  
  mov bx, offset enemy2_character
  add bx, 12
  mov ax, [bx]
  cmp al, 0eh
  je changey2_2
  cmp ax, 7   ; grey
  je changey2_2
  cmp ax, 5   ; other enemy
  je changey2_2


after_changey2_2:

  cmp [is_space], 1
  je jmp_to_space

  cmp [is_space], 2
  je jmp_to_main_space
  jmp check_press

jmp_to_space:
  mov [is_space], 0
  jmp check_press2

jmp_to_main_space:
  mov [is_space], 0
  jmp check_press3

changey1_2:
  neg [speedy2]


  jmp after_changey1_2

changey2_2:
  neg [speedy2]

  jmp after_changey2_2

changex1_2:
  neg [speedx2]

  jmp after_changex1_2

changex2_2:
  neg [speedx2]
  

  jmp after_changex2_2

delete_enemy2_2:
  call enemy_delete2
  ; paint the area the enemy was there in yellow:
  ; mov ax, [speedx2]
  ; sub [xe2], ax
  ; sub [xe2], ax
  ; sub [xe2], ax
  ; mov ax, [speedy2]
  ; sub [ye2], ax
  ; mov cx, 13
  ; mov bx, offset enemy2_character
  ; loop_paint_yellow_enemy2:
  ;   mov [bx], 0eh
  ;   add bx, 1
  ;   loop loop_paint_yellow_enemy2

  call enemy_delete2
  mov [xe2], 10
  mov [ye2], 200
  mov [speedx2], 0
  mov [speedy2], 0
  ; mov [bx], 0



  call enemy_character2
  jmp check_press


start:
  mov ax, @data
  mov ds, ax
  
  ; 11, 8
  mov ax, 3h
  int 10h

  push seg rules
  
  mov dx, offset rules
  mov ah, 9h
  int 21h

speed:
  
  mov ah, 00h
  int 16h

  cmp al, '1'
  je easy
  cmp al, '2'
  je normal
  cmp al, '3'
  je hard
  cmp al, '4'
  je crazy
  jmp speed

easy:
  mov DELAY , 5
  jmp reset

normal:
  mov DELAY , 3
  jmp reset

hard:
  mov DELAY , 2
  jmp reset

crazy:
  mov DELAY , 1
  jmp reset

reset:
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
  mov startx, 0
  mov starty, 0 ;the cords when pressing space
  mov paintx, 0
  mov painty, 0
  mov stopx, 0 ;the last pixel we stop to paint
  mov stopy, 0
  mov xe , 50 ; enemy x cord
  mov ye , 50 ; enemy y
  mov xe2, 200
  mov ye2, 100


  ; colors:
  mov color , 7
  mov color2 , 4 ; צבע השובל
  mov colors , 0eh  ;צבע המסך
  mov colord , 2 ;for debug
  mov colord2 , 5
  mov colorg1 , 4 ;color
  mov colorg2 , 0eh ;to color
  mov enemy_color , 5
  mov enemy_color2, 56

  ; f or precents caculate:
  mov precent_per_paint , 20
  mov sum_pixels , 530 ;the number of pixels is 53,044
  mov count_paint , 0 ;count the number of paint use in paint_function
  mov paint1_precent , 0
  mov paint2_precent , 0
  mov screen_paint_precent , 0



  ; booleans: 
  ;0 - non, 1 - up (w), 2 - down (s), 3 - right (d), 4 - left (a)
  mov first_tav , 0
  mov final_tav , 0

  mov is_complete_paint , 0
  mov is_space , 0 ; 0 - regular, 1 - first_space, 2 - space


  ; other:
  mov index , 0
  mov i , 0
  mov i2 , 0
  mov number_of_runns , 0
  ; max dw 65535 ; the maximum value we can put in dw
  mov enemy_index , 0
  ; mov DELAY , 5

  mov speedx , 1
  mov speedy , 1
  
  mov speedx2, -2 ; for enemy2
  mov speedy2, -2

  
  call print_precents
  ; print % in the end
  mov dl, 37
  mov ah, 2
  int 21h
  
  call enemy_character2
  call enemy_character
  

main:
  call my_character
  ; call enemy_character2

check_press:

  mov ah, 01h
  int 16h
  jnz pressed
  jmp run_screen

pressed:

  ; call print_array2
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

check_press2:

  mov ah, 01h
  int 16h
  jnz space_pressed
  mov [is_space], 1
  jmp run_screen

space_pressed:
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
  ; call delete_char2
  ; call my_character

check_press3:
  mov ah, 01h
  int 16h
  jnz space_main_pressed
  mov [is_space], 2
  jmp run_screen

space_main_pressed:
  call delete_char2
  ; call print_array
  ; call delete_char2
  mov bx, offset my_zone
  mov cx, 9
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
  ; call my_character
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
  ; call my_character
  jmp space_main

help11:
  jmp player_lose
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

  ; check if we get to the same cords:
  mov ax, [x]
  cmp ax, [startx]
  je check2
  ; call make_screen
  ; mov al, [first_tav]
  ; mov ah, [final_tav]
  ; cmp al, ah
countinu_help_main:
;;; here
  call enemy_delete
  call enemy_delete2
  jmp regular_paint
  mov [colorg1], 4
  mov [colorg2], 0eh
  call color_to_color
  jmp main

check2:
  mov ax, [y]
  cmp ax, [starty]
  je help11
  jmp countinu_help_main

regular_paint: ;first check if the area bigger than we can paint
  mov [number_of_runns], 0
  mov [colors], 10h

  mov [is_complete_paint], 1
  call start_paint1
  call paint_area2
  mov [count_paint], 0
  cmp [is_complete_paint], 0
  je endless_paint1  ;jmp to endless_paint
  jmp continue_regular_paint1
endless_paint1: ;paint again and again until we paint all the area
  mov [number_of_runns], 0
  mov [is_complete_paint], 1
  add [count_paint], 1
  mov ax, [stopx]
  mov [paintx], ax
  mov ax, [stopy]
  mov [painty], ax
  ; painting
  call paint_area2

  cmp [is_complete_paint], 0
  je endless_paint1  ;jmp to endless_paint

continue_regular_paint1:
  ; grey to black
  mov [colorg1], 10h
  mov [colorg2], 0
  call color_to_color

  mov bl, [count_paint]
  mov al, [precent_per_paint]
  mul bl
  ; ax = al * bl
  mov [paint1_precent], ax
  
  mov dx, 0
  mov ax, [number_of_runns]
  mov bx, [sum_pixels]
  div bx
	; ax = ax dv bx
  add [paint1_precent], ax

;;;;;;;;

  mov [number_of_runns], 0
  mov [colors], 10h

  mov [is_complete_paint], 1
  call start_paint2
  call paint_area2
  mov [count_paint], 0
  cmp [is_complete_paint], 0
  je endless_paint2  ;jmp to endless_paint
  jmp continue_regular_paint2
endless_paint2: ;paint again and again until we paint all the area
  mov [number_of_runns], 0
  mov [is_complete_paint], 1
  add [count_paint], 1

  mov ax, [stopx]
  mov [paintx], ax
  mov ax, [stopy]
  mov [painty], ax
  ; painting
  call paint_area2

  cmp [is_complete_paint], 0
  je endless_paint2  ;jmp to endless_paint

continue_regular_paint2:
  ; grey to black
  mov [colorg1], 10h
  mov [colorg2], 0
  call color_to_color

  mov bl, [count_paint]
  mov al, [precent_per_paint]
  mul bl
  ; ax = al * bl
  mov [paint2_precent], ax

  mov dx, 0
  ; additing the rest precent (from the last paint)
  mov ax, [number_of_runns]
  mov bx, [sum_pixels]
	div bx
	; ax = ax dv bx
  
  add [paint2_precent], ax

  mov [number_of_runns], 0
  mov [colors], 0eh  


  mov ax, [paint2_precent]
  cmp ax, [paint1_precent]
  jl start_endless_paint2

start_endless_paint1:
  mov ax, [paint1_precent]
  add [screen_paint_precent], ax
  mov [is_complete_paint], 1
  call start_paint1
  call paint_area2
  mov [count_paint], 0
  cmp [is_complete_paint], 0
  je endless_paint  ;jmp to endless_paint
  jmp end_regular_paint

start_endless_paint2:
  mov ax, [paint2_precent]
  add [screen_paint_precent], ax
  mov [is_complete_paint], 1
  call start_paint2
  call paint_area2
  mov [count_paint], 0
  cmp [is_complete_paint], 0
  je endless_paint  ;jmp to endless_paint
  jmp end_regular_paint

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

end_regular_paint:

    ; red to yellow
  mov [colorg1], 4
  mov [colorg2], 0eh
  call color_to_color

  call print_precents
  ;;;;;;;;;;;; here
  call enemy_character
  call enemy_character2
  jmp main
help14: 
  jmp endless_paint


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
  je help18 ;jmp to player_lose

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
  je help18 ;jmp to player_lose

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

help18:
  jmp player_lose

mainloop:
  jmp mainloop
exit:
  ; jmp start
  mov ax, 4c00h
  int 21h
END start
© 2022 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Loading complete