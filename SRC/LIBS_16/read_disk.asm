read_disk:
    PUSH ax
    PUSH bx
    PUSH cx
    PUSH dx
    PUSH di
    CALL rd_convert
    MOV ah, 0x02
    MOV di, 0x03
    MOV dl, [ebr_drive_number]  ;Drive Number
rd_retry:
    STC
    MOV ah, 0x02
    INT 13h
    JNC rd_done
    CALL rd_disk_reset

    DEC di
    CMP di, 0
    JNE rd_retry
rd_fail:
    MOV si, ms_rd_fail
    CALL print
    MOV [0x7F00], ah
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

    ;C = LBA / (Heads * SectorsPerTrack)
        ;C = (LBA / SectorsPerTrack) / Heads 
    ;H = (LBA / SectorsPerTrack) % Heads
    ;S = (LBA % SectorsPerTrack) + 1


    MOV al, cl                          ;Mov LBA_Sector to read into al
    XOR dx, dx                          ;Zero dx
    XOR ah, ah                          ;Zero ah
    DIV word [bdb_sectors_per_track]    ;Divide LBA by Sectors per track (18)
    INC dx                              ;Remaindor +=1
    MOV cx, dx                          ;Mov CHS_Sector into cx
    XOR dx,dx                           ;Zero dx
    DIV word [bdb_heads]                ;Divide (LBA / SectorsPerTrack) by Heads
    MOV dh, dl                          ;Mov
    MOV ch, al
    SHL ah, 6
    OR cl, ah


    POP ax
    RET
