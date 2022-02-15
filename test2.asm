proc my_delay
    push cx
    mov cx, 63000
    None_loop:
        loop None_loop
    pop cx
    ret
endp my_delay
