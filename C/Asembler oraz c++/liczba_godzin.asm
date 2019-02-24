; The divem Subroutine    (divide.asm)

; This subroutine links to Visual C++.

.386P
.model flat
public _liczba_godzin

.code
_liczba_godzin proc near
    push   ebp
	mov	   edx, 0
    mov    ebp,esp
    mov    eax,[ebp+8]    ; first argument
    mov    ebx,[ebp+12]     ; second argument
	cmp    ebx, 0
	jz     divzero
	idiv   ebx
	cmp    edx, 0
	jnz    dodaj
	jmp    exit
dodaj:
	add    eax, 1 
exit:
    pop    ebp
    ret  
	    
divzero:
    mov    eax, 0
	mov    edx, -1
	jmp    exit 
	
    
_liczba_godzin endp


end

