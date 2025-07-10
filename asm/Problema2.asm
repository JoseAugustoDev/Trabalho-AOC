org 100h
      
input:
    ; Mostra a mensagem na tela
    mov dx, offset ler_m
    mov ah, 09h
    int 21h     
    
    ; Chamando procedimento para ler o valor de a ( explicação do procedimento na declaração )
    ; Essa função armazena o valor digita em cx
    call scan_num  
    
    ; Joga o retorna da funcao dentro da variavel m
    mov [m], cx   

    ; Pula Linha:
    putc 0Dh
    putc 0Ah
    
    ; Mostra a mensagem na tela
    mov dx, offset ler_n
    mov ah, 09h
    int 21h     
    
    ; Chamando procedimento para ler o valor de a ( explicação do procedimento na declaração )
    ; Essa função armazena o valor digita em cx
    call scan_num    

    ; Joga o retorna da funcao dentro da variavel n        
    mov [n], cx   
    
    ; Pula Linha:
    putc 0Dh
    putc 0Ah 

validacao:
    ; M nao pode ser menor do que 3
    cmp [m], 3
    
    jl erro_input
    
    ; n tem que ser maior do que m
    cmp cx, [m]
    
    jl erro_input

    
iniciar_variaveis:

    mov al, 1
    mov anterior, al
    
    mov atual, al
    
    mov al, anterior
    add al, atual
    
    mov proximo, al
    
    mov contador, 0    
    
loop_fibo:

    mov al, proximo
    mov ah, 0
    
    ; proximo tem que ser menor que n
    cmp ax, n
    
    jge fim
    
    cmp ax, m

    ; se proximo menor que m 
    jl pular_impressao

    ; Chama o procedimento para imprimir o numero em ax
    call print_num
    
    putc 32 ; espaco ASCII
    
    mov al, contador
    
    ; incrementa o contador de elementos que foram exibidos
    inc al
    
    mov contador, al
    
; quando proximo é menor do que m
pular_impressao:

    mov al, atual
    mov anterior, al

    mov al, proximo
    mov atual, al

    mov al, anterior
    add al, atual
    mov proximo, al

    jmp loop_fibo
    
jmp fim
    
erro_input:  

    ; Pula Linha:
    putc 0Dh
    putc 0Ah      
    
    ; Mostra a mensagem de erro
    mov dx, offset erro_input_msg
    mov ah, 09h
    int 21h   
    
    ; Pula linha
    putc 0Dh
    putc 0Ah
    
    jmp input   
    
fim:     
    ; Pula linha
    putc 0Dh
    putc 0Ah 
    
    ; Imprime a quantidade de elementos que foram exibidos
    mov dx, offset quant_elementos
    mov ah, 09h
    int 21h 
    
    mov al, [contador]  
    mov ah, 0
    call print_num

    ret
     
m DW ? 
n DW ?   

anterior DB ?
atual DB ?
proximo DB ?
contador DB ?
     
ler_m DB "Digite o valor de M: $"
ler_n DB "Digite o valor de N: $" 

erro_input_msg DB "Condicoes invalidas! M deve ser >= 3 e N > M $"

quant_elementos DB "Total de termos exibidos: $"     


; Procedimento criado para calcular o mdc
MDC PROC  
    ; Desempilha os valores que foram empilhados antes da chamada da função, a fim de recupera-los para poder usar aqui dentro.
    pop bx
    pop ax

; Esse loop funciona para realizar o calculo do MDC de acordo com o algoritmo de Euclides    
loop_mdc:

    cmp bx, 0
    ; só faz as operações se o valor_b (contido em bx) for diferente de 0
    jz fim_mdc   
    
    ; Calculando o resto da divisao usando dx, pois é do tipo word
    mov dx, 0
    div bx
    
    ; valor a recebe o valor b
    mov ax, bx
    ; valor b recebe o resto da divisao de a, b
    mov bx, dx
    
    ; volta para o comeco do loop'
    jmp loop_mdc  
    
fim_mdc: 
 
    ; Pula linha
    putc 0Dh
    putc 0Ah   
    
    ; Mostra a mensagem na tela
    mov dx, offset quant_elementos
    mov ah, 09h
    int 21h  
    
    ; Recupera o valor do MDC, guardado em ax pelo procedimento
    pop ax

    ; Chama a função para imprimir o numero ( Explicação na declaração do procedimento )
    call print_num  

    ret
    
MDC ENDP

; Macro do arquivo emu8086.inc, utilizado para imprimir um caractere na tela
PUTC    MACRO   char
        PUSH    AX
        ; Empilha o registrador AX para nao ter problemas com o uso dele em outro lugar do sistema

        ; Printa o caractere usando interrupcao
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     

        ; Desempilha o registrador
        POP     AX
ENDM

; Procedimento do arquivo emu8086.inc, utilizado para ler um numero digitado pelo usuario (scanner)

SCAN_NUM        PROC    NEAR
        ; Empilha os registradores necessarios
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        MOV     CS:make_minus, 0

next_digit:               

        MOV     AH, 00h
        INT     16h      ; Le o caractere digitado guardado em AL
        
        MOV     AH, 0Eh
        INT     10h ; Imprime

        CMP     AL, '-'
        JE      set_minus ; Se for negativo pula para essa label, para tratar erro

        CMP     AL, 13 ; 13 é o enter, ou seja, o numero todo foi digitado
        JNE     not_cr ; Se nao for enter, verifica se foi um backspace (apagar caracter)
        JMP     stop_input ; Se foi enter, finaliza o input

not_cr:

        CMP     AL, 8 ; Compara com 8, pois é o indicador referente ao backspace na tabela ASCII   
        JNE     backspace_checked
        MOV     DX, 0                 
        MOV     AX, CX                 
        DIV     CS:ten         
        MOV     CX, AX
        ; Imprime um espaço em branco na tela, para "apagar" o digito errado
        PUTC    ' '                  
        PUTC    8                  
        JMP     next_digit ; Volta para ler o numero novamente

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

; Procedimento do arquivo emu8086.inc, utilizado para imprimir um numero na tela
PRINT_NUM       PROC    NEAR
        ; Empilha os registradores necessarios
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

; Procedimento do arquivo emu8086.inc, utilizado para imprimir um numero sem sinal na tela
PRINT_NUM_UNS   PROC    NEAR
        ; Empilha os registradores necessarios
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

        
        ADD     AL, 30h  ; Converte para ASCII
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