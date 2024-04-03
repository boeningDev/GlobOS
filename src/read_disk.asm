read_disk:
    PUSH ax
    PUSH bx
    PUSH cx
    PUSH dx
    PUSH di
    CALL rd_convert
    MOV ah, 0x02
    MOV di, 3
rd_retry:
    STC
    INT 13h
    JNC rd_done
    CALL rd_disk_reset
    DEC di
    CMP di, di
    JNZ rd_retry
rd_fail:
    MOV si, ms_rd_fail
    CALL print
    HLT
    JMP HLT_LOOP
rd_disk_reset:
    PUSHA
    MOV ah, 0
    MOV dl, [ebr_drive_number]
    STC
    INT 13h
    JC rd_fail
    POPA
    RET
rd_done:
    POP di
    POP dx
    POP cx
    POP bx
    POP ax
    RET

rd_convert:
    PUSH ax
    PUSH dx

    XOR dx,dx
    DIV word [bdb_sectors_per_track]
    INC dx
    MOV cx, dx

    XOR dx,dx
    DIV word [bdb_heads]
    MOV dh, dl
    MOV ch, al
    SHL ah, 6
    OR cl, ah
    
    POP ax
    POP ax
    RET
