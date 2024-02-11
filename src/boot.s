ORG 0x7C00
BITS 16

JMP SHORT MAIN
NOP

bdb_oem:                 DB 'MSWIN4.1'
bdb_bytes_per_sector:    DW 512
bdb_sectors_per_cluster: DB 1
bdb_reserved_sectors:    DW 1
bdb_fat_count:           DB 2
bdb_dir_entries_count:   DW 0E0h
bdb_total_sectors:       DW 2880
bdb_media_descriptor_type: DB 0F0h
bdb_sectors_per_fat:     DW 9
bdb_sectors_per_track:   DW 18
bdb_heads:               DW 2
bdb_hidden_sectors:      DD 0
bdb_large_sector_count:  DD 0

ebr_drive_number:        DB 0
                         DB 0
ebr_signature:           DB 29h
ebr_volume_id:           DB 12h,34h,56h,78h
ebr_volume_label:        DB 'GLOBOS     '
ebr_system_id:           DB 'FAT12   '

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