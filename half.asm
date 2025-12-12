mov ax, 0b800h
mov ds, ax

reset:
    mov bx, 1920            ; Middle row only (row 12: 160 * 12 = 1920)

    ; ===== LEFT HALF: Scroll from middle (col 39) towards left (col 0) =====
    mov si, bx              ; Start of row
    mov al, [ds:si]         ; Save leftmost character (column 0)
    mov ah, [ds:si + 1]     ; Save attribute

    mov di, bx              ; Start at column 0
    mov cx, 39              ; Shift 39 characters (columns 0-38)

shift_left_half:
    mov dl, [ds:di + 2]     ; Get character from right
    mov dh, [ds:di + 3]     ; Get attribute from right
    mov [ds:di], dl         ; Move it left
    mov [ds:di + 1], dh
    add di, 2
    loop shift_left_half

    ; Place saved character at column 39 (middle left)
    mov [ds:di], al
    mov [ds:di + 1], ah

    ; ===== EXPLICITLY RESET BX (FIX FOR LAPTOP) =====
    mov bx, 1920            ; Reload BX to ensure it's correct

    ; ===== RIGHT HALF: Scroll from middle (col 40) towards right (col 79) =====
    mov si, bx              ; Reload from BX
    add si, 158             ; Column 79 (rightmost)
    mov al, [ds:si]         ; Save rightmost character
    mov ah, [ds:si + 1]     ; Save attribute

    mov di, bx              ; Reload from BX
    add di, 158             ; Start at column 79
    mov cx, 39              ; Shift 39 characters (columns 41-79)

shift_right_half:
    mov dl, [ds:di - 2]     ; Get character from left
    mov dh, [ds:di - 1]     ; Get attribute from left
    mov [ds:di], dl         ; Move it right
    mov [ds:di + 1], dh
    sub di, 2
    loop shift_right_half

    ; Place saved character at column 40 (middle right)
    mov [ds:di], al
    mov [ds:di + 1], ah

    ; ============ DELAY SECTION ============
    mov cx, 0ffffh          

delay_loop:
    loop delay_loop
    ; =======================================

jmp reset                   

int 20h
