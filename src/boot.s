ORG 0x7C00
BITS 16

MAIN:
    MOV ax, 0
    MOV ds, ax
    MOV es, ax
    MOV ss, ax
    MOV sp, 0x7C00
    MOV si, message
    CALL print
    HLT

HLT_LOOP:
    JMP HLT_LOOP

message: DB 'Hello World!', 0x0D, 0x0A, 0

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

TIMES 510-($-$$) DB 0
DW 0AA55h