mov ax, 0b800h
mov ds, ax

reset:
    ; ===== DIAGONAL: Upper-left to lower-right (scrolls along diagonal) =====
    
mov al, [ds:3998]       ; Start at bottom-right (row 24, col 79)
mov ah, [ds:3999]

mov bx, 3998            ; Bottom-right position
mov cx, 24

shift_diagonal_reverse:
    mov si, bx
    sub si, 160         ; Move to previous row
    sub si, 6           ; Move left
    
    mov dl, [ds:si]
    mov dh, [ds:si + 1]
    mov [ds:bx], dl
    mov [ds:bx + 1], dh
    
    mov bx, si
    loop shift_diagonal_reverse
    
mov [ds:bx], al
mov [ds:bx + 1], ah


    ; ============ DELAY SECTION - EDIT FOR SPEED ============
    mov cx, 0ffffh          ; INCREASE for slower, DECREASE for faster

delay_loop:
    loop delay_loop
    ; ========================================================

jmp reset                   ; Loop forever

int 20h
