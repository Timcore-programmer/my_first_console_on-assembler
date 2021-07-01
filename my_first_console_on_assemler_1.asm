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

MAX_SIZE        equ     255


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

_do:
    push offset szIntro
    call cout
    ;------------------
_while_:
    push offset szBuffer
    call cin
    ;------------------
    mov al,byte ptr[szBuffer]
    ;------------------
    cmp al,71h                     ;q
    je _do_end
    ;------------------
    cmp al,'a'
    je _snall
    ;------------------
    push offset szError
    call cout
    ;------------------
    jmp _while_
_snall:
     call snall
     jmp _while_  
_do_end:

     ret
main endp

;********************************
;ebp+8 = pStr
cout proc 
     push ebp
     mov ebp,esp
     add esp,-8
     ;---------
     push ebx
     push esi
     push edi
     ;---------
     push -11
     call GetStdhandle@4
     mov dword ptr[ebp-4],eax
     ;---------
     mov esi,dword ptr[ebp+8]
     ;---------
     push esi
     call lens
     ;---------
     push 0
     mov ebx,ebp
     sub ebx,8
     ;---------
     push ebx
     push eax
     push esi
     push dword ptr[ebp-4]
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
cin proc
    push ebp
    mov ebp,esp
    add esp,-4
    ;---------
    push ebx
    push esi
    push edi
    ;---------
    mov edi,dword ptr[ebp+8]
    ;---------
    push -10
    call GetStdHandle@4
    ;---------
    mov esi,ebp
    sub esi,4
    ;---------
    push 0
    push esi
    push 255
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
    sub ecx,ecx
    ;---------
_while:
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