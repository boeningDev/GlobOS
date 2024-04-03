ms_booting: DB 'BOOTING...', 0x0D, 0x0A, 0

ms_rd_fail: DB 'UNABLE TO READ DRIVE...', 0x0D, 0x0A, 0
ms_rd_suceed: DB 'SUCESSFULLY READ FROM DISK...', 0x0D, 0x0A, 0

ms_kernel_not_found: DB 'KERNEL NOT FOUND...'
kernel_name: DB 'KERNEL  BIN'
kernel_cluster: DW 0
kernal_load_segment: EQU 0x2000
kernel_load_offset: EQU 0
