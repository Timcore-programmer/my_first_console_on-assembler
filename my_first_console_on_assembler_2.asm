.686P
.model flat,stdcall
;------------------
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

extern ExitProcess@4:near
extern GetStdHandle@4:near
extern CloseHandle@4:near
extern WriteConsoleA@20:near
extern ReadConsoleA@20:near
extern wsprintfA:near
;----------------------------------

MAX_SIZE          equ     255
STD_INPUT_HANDLE  equ     -10
STD_OUTPUT_HANDLE equ     -11


_DATA SEGMENT
    ExitCode   dd 0
    szIntro    db 13,10,"Press <q> to quit, or <a> to execute Snall.",13,10,0
    szError    db "Input error! Please try again.",13,10,0
    szSnall    db 07,"Hello! Here I am, Smailly :)",13,10,0
    szBuffer   db MAX_SIZE dup(0)  


_DATA ENDS


_TEXT SEGMENT

START:

      call main 

      ;--------------------------
      push [ExitCode]
      call ExitProcess@4

;********************************

main proc

    push offset szIntro
    call cout
    ;------------------
_while_:

    push offset szBuffer
    call cin
    ;------------------
    mov al,byte ptr[szBuffer]
    ;------------------
    .if al=='q'

        jmp _do_end
        
    .elseif al =='a'
        call snall
        
    .else
        push offset szError
        call cout

     .endif
     ;------------------
     jmp _while_
     ;------------------
_do_end:
     ret
main endp

;********************************
;ebp+8 = pStr

dwHout equ [ebp-4]
dwCnt  equ [ebp-8]
pStr   equ [ebp+8]
;---------------==------

cout proc 
     push ebp
     mov ebp,esp
     add esp,-8
     ;---------
     push ebx
     push esi
     push edi
     ;---------
     push STD_OUTPUT_HANDLE
     call GetStdhandle@4
     ;---------
     mov dword ptr[dwHout],eax
     ;---------
     mov esi,dword ptr[pStr]
     ;---------
     push esi
     call str_len
     ;---------
     push 0
     ;---------
     lea ebx,dwCnt
     ;---------
     push ebx
     push eax
     push esi
     push dword ptr[dwHout]
     call WriteConsoleA@20




     ;---------
     pop edi
     pop esi
     pop ebx
     mov esp,ebp
     pop ebp
     ret 4
cout endp

;********************************

dwHun  equ [ebp-4]
pBuff  equ [ebp+8]
;-------------

cin proc
    push ebp
    mov ebp,esp
    add esp,-4
    ;---------
    push ebx
    push esi
    push edi
    ;---------
    mov edi,dword ptr pBuff
    ;---------
    push STD_INPUT_HANDLE
    call GetStdHandle@4
    ;---------
    lea esi,dwHun
    ;---------
    push 0
    push esi
    push MAX_SIZE
    push edi
    push eax
    call ReadConsoleA@20
    ;---------
    sub dword ptr[esi],2
    mov esi,dword ptr[esi]
    ;---------
    mov byte ptr[edi+esi],0
    
    ;---------
    pop edi
    pop esi
    pop ebx
    mov esp,ebp
    pop ebp


    ret 4 
cin endp
;********************************
lens proc
    push ebp
    mov ebp,esp
    push ebx
    push esi
    push edi
    ;---------
    mov esi,dword ptr[ebp+8]
    ;---------
    xor ecx,ecx
    ;---------
_while:
     cmp byte ptr[esi],0
     ;--------
     mov al,byte ptr[esi]
     cmp al,0
     je _end_while
     ;--------
     inc ecx
     inc esi
     jmp _while



    ;--------
_end_while:
    mov eax,ecx
    ;---------
    pop edi
    pop esi
    pop ebx
    mov esp,ebp
    pop ebp

     ret 4
lens endp
;********************************
strLens proc
    push ebp
    mov ebp,esp
    push ebx
    push esi
    push edi
    ;---------
    mov esi,dword ptr[ebp+8]
    ;---------
    xor ecx,ecx
    ;---------
    jmp _for
_in:

   inc ecx

_for:
    cmp byte ptr[esi+ecx],0
    jnz _in
    ;---------

    xor ecx,eax
    xor eax,ecx

    ;---------
    pop edi
    pop esi
    pop ebx
    mov esp,ebp
    pop ebp

     ret 4




strLens endp
;********************************
str_len proc
    push ebp
    mov ebp,esp
    ;---------
    add esp,-4
    ;---------
    push ebx
    push esi
    push edi
    ;---------
    mov esi,dword ptr[ebp+8]
    ;---------
    mov dword ptr[ebp-4],0
    ;---------
    jmp _for_
_in_:

    mov eax,dword ptr[ebp-4]
    lea edx,[eax+1]
    ;-----------------------
    mov dword ptr[ebp-4],edx
    


_for_:
    mov eax,dword ptr[ebp-4]
    ;---------
    mov al,byte ptr[esi+eax]
    or al,al
    jne _in_

    mov eax,dword ptr[ebp-4]
    
    ;---------
    pop edi
    pop esi
    pop ebx
    mov esp,ebp
    pop ebp

     ret 4

str_len endp
;********************************

snall proc 
      enter 0,0
      ;--------------------------
      push ebx
      push esi
      push edi
      ;--------------------------
      push offset szSnall
      call cout
      ;--------------------------
      pop edi
      pop esi
      pop ebx
      leave
      ret

snall endp
;--------------------------------



_TEXT ENDS
END START