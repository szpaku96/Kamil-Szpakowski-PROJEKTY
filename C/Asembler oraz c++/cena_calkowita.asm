; The divem Subroutine    (divide.asm)

; This subroutine links to Visual C++.

.386P
.model flat
public _cena_calkowita

.code
_cena_calkowita proc near
	push	ebp
    mov		ebp,esp
    mov		eax,[ebp+12]    ;second argument
	mov		ebx, 5
	imul	eax, ebx		;multiplication of second and third argument
	add		eax, [ebp+8]	;adding first argument
	add		eax, [ebp+16]   ;third argument

    pop		ebp
    ret  
_cena_calkowita endp

end

