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
    MOV ax, 0                       ;Init Segment Registors to 0 
    MOV ds, ax
    MOV es, ax
    MOV ss, ax
    MOV sp, 0x7C00                  ;Stack at 0x7c00
    
    MOV si, ms_booting              ;Load Booting Message
    CALL print                      ;Call println Function

    MOV al, 0x1                     ;Number of Sectors to Read
    MOV cx, 0x21                    ;Starting Sector to read
    MOV bx, 0x7e00                  ;buffer
    CALL read_disk                  ;Read Disk


;    PUSH ax
;    PUSH bx
;    MOV ax, 0x0
;    MOV es, ax
;    MOV ax, [0x7e06]
;    MOV ah, 0x0e
;    XOR bx,bx
;    INT 10h
;    POP bx
;    POP ax


    ;reserved:              1 Sector    0
    ;fat:       9spf*2fat=  18 Sectors  1-18
    ;root dir:

ROOT_DIR_MATHS:
    MOV ax, [bdb_sectors_per_fat]       
    MUL word [bdb_fat_count]        ;MUL SectorsPerFat by FatCount
    ADD ax, [bdb_reserved_sectors]  ;ADD ReservedSectors; At This Point, ax = RootDir LBA

    ;Since each Root Dir Entry is 32 bytes, we can find out how
    ;many sectors we need to read by multiplying the number of
    ;entries, [bdb_dir_entries_count], by 32, then dividing by
    ;512, or the number of bytes per sector, [bdb_bytes_per_sector]

    PUSH ax
    MOV ax, [bdb_dir_entries_count]
    SHL ax, 5                       ;ax *= 32
    MOV dx, 0
    DIV word [bdb_bytes_per_sector]
    TEST dx, dx                     ;Test if there is a remainder
    JZ ROOT_DIR_MATHS_JZ            ;If there isn't, jump
    INC ax                          ;If there is, round up
ROOT_DIR_MATHS_JZ:
    POP cx                          ;POP the LBA into cx
    XOR ah,ah                       ;Zero ah
    MOV bx, 0x7e00                  ;Set the buffer to the lbl: buffer
    CALL read_disk

    MOV bx, 1
    MOV di, 0x7e00
SEARCH_FOR_KERNEL:
    MOV si, kernel_name
    MOV cx, 11                      ;Number of times to repeat
    PUSH di
    REPE CMPSB                      ;REPEat if Equal or until cx = 0: Compare [di] and [si], then increment
    POP di
    JE SEARCH_FOR_KERNEL_COMPLETE
    ADD di, 0x20                    ;Go to next root entry (+= 32)
    INC bx                          ;Increrment root dir index
    CMP bx, [bdb_dir_entries_count] ;Check if index == [bdb_dir_entries_count]
    JL SEARCH_FOR_KERNEL            ;If it isn't, try the next entry
    JMP SEARCH_FOR_KERNEL_FAILED    ;If it is, the search failed

SEARCH_FOR_KERNEL_FAILED:
    MOV si, ms_kernel_not_found
    CALL print
    CLI
    HLT
    JMP HLT_LOOP

SEARCH_FOR_KERNEL_COMPLETE:
    MOV ax, [di+26]                 ;Mov into ax, the starting cluster of the kernel
    MOV [kernel_cluster], ax        ;Mov into kernel_cluster, the starting kernel cluster
    MOV dl, [ebr_drive_number]
    MOV cx, [bdb_reserved_sectors]  
    MOV al, [bdb_sectors_per_fat]
    MOV bx, 0x7e00
    CALL read_disk                  ;Read the FAT to 0x7e00


    MOV bx, kernal_load_segment     
    MOV es, bx
    MOV bx, kernel_load_offset  
LOADIT_LOOP:
    MOV dl, [ebr_drive_number]
    MOV cx, [kernel_cluster]        ;Mov into diskRead starting LBA, the kernel cluster
    ADD cx, 31                      ;Plus 31 to get the actual LBA
    MOV al, 1                       ;Read one segment
    XOR ah,ah

    CALL read_disk
    ADD bx, [bdb_bytes_per_sector]

    ;To check if the next cluster is the last one, use the formula:
    MOV ax, [kernel_cluster]        ;kernel_cluster
    MOV cx, 3                       
    MUL cx                          ; *3
    MOV cx, 2
    DIV cx                          ; /2

    MOV si, 0x7e00
    ADD si, ax
    MOV ax, [si]

    OR dx, dx
    JZ EVEN

ODD:
    SHR ax, 4
    JMP CZECHIT
EVEN:
    AND ax, 0x0FFF

CZECHIT:
    CMP ax, 0xFF8
    JAE IZCZECHED

    MOV [kernel_cluster], ax
    JMP LOADIT_LOOP

IZCZECHED:
    ;Mov into es:bx, kernel_segment:kernel_ofset
    MOV dl, [ebr_drive_number]
    MOV ax, kernal_load_segment
    MOV ds, ax
    MOV es, ax
    JMP kernal_load_segment:kernel_load_offset



    CLI
    HLT

HLT_LOOP:
    JMP HLT_LOOP


%include 'SRC/LIBS_16/boot_constants.asm'
%include 'SRC/LIBS_16/print.asm'
%include 'SRC/LIBS_16/read_disk.asm'
buffer:
TIMES 510-($-$$) DB 0
DW 0AA55h