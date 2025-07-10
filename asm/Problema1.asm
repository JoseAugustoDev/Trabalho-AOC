org 100h

input:
    mov dx, offset msg
    mov ah, 09h
    int 21h     
    
    ; Lendo digito por digito pq na especificacao diz que nessa atividade 1 nao pode usar nem funcao ou loop 
    ; Foi a unica maneira que eu consegui fazer
              
    ; Ler Primeiro digito
    mov ah, 01h
    int 21h         
    sub al, '0'
    mov bl, al     

    ; Ler Segundo digito
    mov ah, 01h
    int 21h         
    sub al, '0'
    mov bh, al    

    ; idade = (dezena * 10) + unidade
    mov al, bl
    mov ah, 0
    mov cx, 10
    mul cl
    add al, bh

    mov [idade], al

    ; Se for menor que zero é invalido
    cmp al, 0
    jl invalido

validacao:
    mov al, [idade] ; al recebe o valor da idade
    
    ; compara com a primeira marca (12)
    mov bl, primeiraMarca
    cmp al, bl 
    
    jnge crianca

    ; compara com a segunda marca (18)
    mov bl, segundaMarca
    cmp al, bl
    jnge adolescente

    ; compara com a segunda marca (60)
    mov bl, terceiraMarca
    cmp al, bl
    jnge adulto

    ; Se nao for nenhuma das outras (else)
    jmp idoso

crianca:    
    mov dx, offset se_crianca
    jmp imprimir

adolescente:
    mov dx, offset se_adolescente
    jmp imprimir

adulto:
    mov dx, offset se_adulto
    jmp imprimir

idoso:
    mov dx, offset se_idoso
    jmp imprimir

invalido:
    mov dx, offset se_invalido

imprimir:  
    ; quebra de linha, dando enter (13) e nova linha (10)             
    mov ah, 0Eh
    mov al, 13
    int 10h

    mov al, 10
    int 10h

    ; Imprime o valor em dx (mensagem)
    mov ah, 09h
    int 21h

ret


idade           db ?
primeiraMarca   db 12
segundaMarca    db 18
terceiraMarca   db 60

msg             db "Digite sua idade (2 digitos): $"
se_crianca      db "Com essa idade eh: crianca $"
se_adolescente  db "Com essa idade eh: adolescente $"
se_adulto       db "Com essa idade eh: adulto $"
se_idoso        db "Com essa idade eh: idoso $"
se_invalido     db "Numero invalido $"