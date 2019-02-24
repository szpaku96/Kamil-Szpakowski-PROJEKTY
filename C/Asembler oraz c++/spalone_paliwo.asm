; The divem Subroutine    (divide.asm)

; This subroutine links to Visual C++.

.386P
.model flat
public _spalone_paliwo

.code
_spalone_paliwo proc near
	push   ebp
    mov    ebp,esp
    mov    eax,[ebp+8]    ; first argument
    mov    ebx,[ebp+12]     ; second argument
	imul   eax, ebx
    pop    ebp
    ret  
_spalone_paliwo endp

end

