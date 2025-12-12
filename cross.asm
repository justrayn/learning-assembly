mov ax, 0b800h
mov ds, ax

reset:
    ; ===== HORIZONTAL: Middle row (row 12) scrolls left =====
    mov bx, 1920            ; Row 12 offset (160 * 12)
    
    mov al, [ds:bx]         ; Save first character of row
    mov ah, [ds:bx + 1]     ; Save attribute
    
    mov di, bx              ; Start at beginning of row
    mov cx, 79              ; Shift 79 characters

shift_horizontal:
    mov dl, [ds:di + 2]     ; Get character from right
    mov dh, [ds:di + 3]     ; Get attribute from right
    mov [ds:di], dl         ; Move it left
    mov [ds:di + 1], dh
    add di, 2
    loop shift_horizontal
    
    mov [ds:di], al         ; Wrap first character to end
    mov [ds:di + 1], ah

    ; ===== VERTICAL: Middle column (column 40) scrolls up =====
    mov si, 80              ; Column 40 position (40 * 2)
    
    mov al, [ds:si]         ; Save top character (row 0, col 40)
    mov ah, [ds:si + 1]     ; Save attribute
    
    mov di, si              ; Start at top of column
    mov cx, 24              ; 24 rows to shift (rows 0-23)

shift_vertical:
    mov dl, [ds:di + 160]   ; Get character from row below
    mov dh, [ds:di + 161]   ; Get attribute from row below
    mov [ds:di], dl         ; Move it up
    mov [ds:di + 1], dh
    add di, 160             ; Move to next row
    loop shift_vertical
    
    mov [ds:di], al         ; Wrap top character to bottom
    mov [ds:di + 1], ah

    ; ============ DELAY SECTION - EDIT FOR SPEED ============
    mov cx, 0ffffh          ; INCREASE for slower, DECREASE for faster

delay_loop:
    loop delay_loop
    ; ========================================================

jmp reset                   ; Loop forever

int 20h
