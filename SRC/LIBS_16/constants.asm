ms_new_line: DB 0x0D, 0x0A, 0

ms_booting: DB 'Bootloader Stage 1...', 0x0D, 0x0A, 0
ms_booting_2: DB 'Bootloader Stage 2...', 0x0D, 0x0A, 0
ms_booted:  DB 'OS has SUCESSFULLY reached the end of the 2nd stage bootloader', 0x0D, 0x0A, 0

ms_rd_fail: DB 'UNABLE TO READ DRIVE...', 0x0D, 0x0A, 0
ms_rd_fail_2: DB 'womp womp', 0x0D, 0x0A, 0
ms_rd_suceed: DB 'SUCESSFULLY READ FROM DISK...', 0x0D, 0x0A, 0


ms_kernel_not_found: DB 'KERNEL NOT FOUND...'
kernel_name: DB 'KERNEL  BIN'
kernel_cluster: DW 0
kernal_load_segment: EQU 0x2000
kernel_load_offset: EQU 0
