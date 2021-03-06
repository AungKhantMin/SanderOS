global irq_defaulte
irq_defaulte:
    pusha
    push ds
    push es
    push fs
    push gs
    push eax
    mov al,0x20
    out 0x20,al
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    iret
    
global irq_keyboard
extern keyboard_int
irq_keyboard:
    pusha
    push ds
    push es
    push fs
    push gs
    push eax
    mov al,0x20
    out 0x20,al
    call keyboard_int
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    iret
    
global irq_mouse
extern mouse_int
irq_mouse:
    pusha
    push ds
    push es
    push fs
    push gs
    push eax
    mov al,0x20
    out 0x20,al
    call mouse_int
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    iret
    
global irq_hdd
irq_hdd:
    pusha
    push ds
    push es
    push fs
    push gs
    push eax
    mov al,0x20
    out 0x20,al
    mov byte [0x1000],byte 'X'
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    iret
    
global getcs
getcs:
mov eax,cs
ret
