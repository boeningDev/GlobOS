ORG 0x0
BITS 16

    MOV si, ms_booting_2
    CALL print
    JMP LBL1970
HAT:  
    CLI
    HLT
HLT_LOOP_2:
    JMP HLT_LOOP_2

INCLUDE:
%include 'SRC/LIBS_16/constants.asm'
%include 'SRC/LIBS_16/print.asm'
TIMES (1024-(END_LBL-LBL1970))-($-$$) DB 0
LBL1970:
    MOV si, ms_new_line
    CALL print
    MOV si, ms_booted
    CALL print
    JMP HAT
END_LBL:
