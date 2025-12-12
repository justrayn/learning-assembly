mov ax, 0b800h
mov ds, ax

reset:
    ; ===== DIAGONAL: Upper-left to lower-right (scrolls along diagonal) =====
    
    mov al, [ds:0]          ; Save character at position (row 0, col 0)
    mov ah, [ds:1]          ; Save attribute
    
    mov bx, 0               ; Start at top-left (row 0)
    mov cx, 24              ; 24 positions to shift (rows 0-23)

shift_diagonal:
    mov si, bx              ; Current position
    add si, 160             ; Move to next row
    add si, 6               ; Move 3 columns right (3 * 2 bytes = 6)
                            ; This creates diagonal: 80 cols / 25 rows ≈ 3.2 cols per row
    
    mov dl, [ds:si]         ; Get character from diagonal position below-right
    mov dh, [ds:si + 1]     ; Get attribute
    mov [ds:bx], dl         ; Move it to current position
    mov [ds:bx + 1], dh
    
    mov bx, si              ; Move to next diagonal position
    loop shift_diagonal
    
    mov [ds:bx], al         ; Wrap first character to end of diagonal
    mov [ds:bx + 1], ah

    ; ============ DELAY SECTION - EDIT FOR SPEED ============
    mov cx, 0ffffh          ; INCREASE for slower, DECREASE for faster

delay_loop:
    loop delay_loop
    ; ========================================================

jmp reset                   ; Loop forever

int 20h
