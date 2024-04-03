print:
    PUSH si
    PUSH ax
    PUSH bx
p_loop:
    LODSB
    OR al,al
    JZ p_ret
    MOV ah, 0x0E
    MOV bh, 0
    INT 0x10
    JMP p_loop
p_ret:
    POP bx
    POP ax
    POP si
    RET