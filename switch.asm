org 100h

mov ax, 0B800h
mov ds, ax                 ; DS -> text video memory

mov bx, 0                  ; BX = offset of current cell (character byte)
                           ; will always point to a character byte (even index)

next_cell:
    ; stop when we reach last possible start (col 76, row 24)
    cmp bx, 4000-8         ; 4 chars * 2 bytes = 8
    jae done

    ; check for ".COM" at BX, BX+2, BX+4, BX+6
    mov al, [bx]           ; '.'
    cmp al, '.'
    jne skip_cell

    mov al, [bx+2]         ; 'C'
    cmp al, 'C'
    jne skip_cell

    mov al, [bx+4]         ; 'O'
    cmp al, 'O'
    jne skip_cell

    mov al, [bx+6]         ; 'M'
    cmp al, 'M'
    jne skip_cell

    ; match found: write "/HIS" in same places, keep attributes
    mov byte [bx],   '/'   ; replace '.'
    mov byte [bx+2], 'H'   ; replace 'C'
    mov byte [bx+4], 'I'   ; replace 'O'
    mov byte [bx+6], 'S'   ; replace 'M'

skip_cell:
    add bx, 2              ; go to next character position
    jmp next_cell

done:
mov ah, 4Ch
int 21h
