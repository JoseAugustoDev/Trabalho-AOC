; Calculo de MDC

org 100h
                       
input: 
    mov dx, offset ler_a
    mov ah, 09h
    int 21h     
    
    call scan_num  
    
    mov [valor_a], cx
    
    cmp [valor_a], 0
    
    jl erro_input   
    
    ; Pula Linha:
    putc 0Dh
    putc 0Ah         
    
    mov dx, offset ler_b
    mov ah, 09h
    int 21h     
    
    call scan_num    
                   
    mov [valor_b], cx   
    
    cmp cx, [valor_a]
    
    jl erro_input
    
    ; Pula Linha:
    putc 0Dh
    putc 0Ah     
    
    ; jmp main   
    
main:
    mov ax, [valor_a]
    push ax
    
    mov ax, [valor_b]
    push ax
    
    call mdc 
    
    jmp fim

    
erro_input:     

    ; Pula Linha:
    putc 0Dh
    putc 0Ah      
    
    mov dx, offset erro_input_msg
    mov ah, 09h
    int 21h   
    
    putc 0Dh
    putc 0Ah
    
    jmp input   
    
fim:
    mov ah, 4Ch
    int 21h

valor_a DW ?
valor_b DW ?  

ler_a DB "Digite o valor de a: $"  
ler_b DB "Digite o valor de b: $"                  

erro_input_msg DB "Numeros invalidos. Devem ser positivos. $" 
resultado DB "MDC: $"  


MDC PROC NEAR  
    pop bx
    pop ax
    
loop_mdc:

    cmp bx, 0
    
    jz fim_mdc   
    
    mov dx, 0
    div bx
    
    mov ax, bx
    mov bx, dx
    
    jmp loop_mdc  
    
fim_mdc: 
       
    putc 0Dh
    putc 0Ah   
    
    mov dx, offset resultado
    mov ah, 09h
    int 21h  
    
    pop ax
    call print_num  
      
    ret
    
MDC ENDP


PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM

SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        MOV     CS:make_minus, 0

next_digit:               

        MOV     AH, 00h
        INT     16h      
        
        MOV     AH, 0Eh
        INT     10h

        CMP     AL, '-'
        JE      set_minus

        CMP     AL, 13
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8               
        JNE     backspace_checked
        MOV     DX, 0                 
        MOV     AX, CX                 
        DIV     CS:ten         
        MOV     CX, AX
        PUTC    ' '                  
        PUTC    8                  
        JMP     next_digit
backspace_checked:


        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       
        PUTC    ' ' 
        PUTC    8         
        JMP     next_digit      
ok_digit:

        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten              
        MOV     CX, AX
        POP     AX

        CMP     DX, 0
        JNE     too_big

        SUB     AL, 30h

        MOV     AH, 0
        MOV     DX, CX   
        ADD     CX, AX
        JC      too_big2   

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX     
        MOV     DX, 0    
too_big:
        MOV     AX, CX
        DIV     CS:ten 
        MOV     CX, AX
        PUTC    8   
        PUTC    ' '
        PUTC    8     
        JMP     next_digit
        
        
stop_input:             

        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?      
ten             DW      10    
SCAN_NUM        ENDP  

PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:           

        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP

PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX
                                                         

        MOV     CX, 1
                                                              

        MOV     BX, 10000   
                                       

        CMP     AX, 0
        JZ      print_zero

begin_print:
                                                   
                                                   
        CMP     BX,0
        JZ      end_print
                                              

        CMP     CX, 0
        JE      calc                                

        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0  

        MOV     DX, 0
        DIV     BX    

        
        ADD     AL, 30h  
        PUTC    AL


        MOV     AX, DX 

skip:             

        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET                                        
              
PRINT_NUM_UNS   ENDP


