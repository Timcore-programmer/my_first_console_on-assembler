.586P
.model flat,stdcall
;------------------
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib

extern ExitProcess@4:near
extern GetStdHandle@4:near
extern CloseHandle@4:near
extern lstrlenA@4:near
extern WriteConsoleA@20:near
extern ReadConsoleA@20:near
extern wsprintfA:near
;----------------------------------



_DATA SEGMENT
    ExitCode   dd 0
    hIn        dd 0
    hOut       dd 0
    szExit     db 13,10,"Press any key. . .",0
    szBuffer   db 255 dup(0)
    szFrm      db "(2ac - b/x - 12) / (cx + a) = %d",13,10,0
    szBuffer2  db 32 dup(0)
    dwCnt      dd 0
    


_DATA ENDS


_TEXT SEGMENT

START:

      push -10
      call GetStdHandle@4
      mov hIn,eax
      ;--------------------------
      push -11
      call GetStdHandle@4
      mov hOut,eax
      ;--------------------------
      push 4
      push -5
      push 16
      push 3

      call snall
      ;--------------------------
      push eax
      lea eax,szFrm
      push eax
      lea eax,szBuffer2
      push eax
      call wsprintfA
      ;--------------------------
      add esp,12
      ;--------------------------
      push offset szBuffer2
      call lstrlenA@4
      ;--------------------------
      push 0
      push offset dwCnt
      push eax
      push offset szBuffer2
      push hOut
      call WriteConsoleA@20
      ;--------------------------
      lea eax,szExit
      push eax
      call lstrlenA@4
      ;--------------------------
      push 0
      lea ebx,dwCnt
      push ebx
      push eax
      push offset szExit
      push [hOut]
      call WriteConsoleA@20
      ;--------------------------
      push 0
      lea ebx,dwCnt
      push ebx
      push 255
      lea eax,szBuffer
      push eax
      push [hIn]
      call ReadConsoleA@20
      ;--------------------------      
      push hIn
      call CloseHandle@4
      ;--------------------------
      push hOut
      call CloseHandle@4
      ;--------------------------
      push [ExitCode]
      call ExitProcess@4
      ;--------------------------
snall proc 
      enter 0,0
      ;--------------------------
      push ebx
      push esi
      push edi
      ;--------------------------
      mov eax,dword ptr[ebp+8]
      add eax,eax
      ;--------------------------     ;2a
      imul dword ptr[ebp+16]
      ;--------------------------     ;2ac
      mov ecx,eax
      ;--------------------------
      mov eax,dword ptr[ebp+12]
      cdq
      idiv dword ptr[ebp+20]          ;b/x
      ;--------------------------
      sub ecx,eax
      sub ecx,12
      ;--------------------------
      mov eax,dword ptr[ebp+16]
      imul dword ptr[ebp+20]           ;c*x
      ;--------------------------
      mov ebx,eax 
      ;--------------------------
      mov eax,dword ptr[ebp+8]
      add ebx,eax                      ;cx+a
      ;--------------------------
      mov eax,ecx
      cdq
      idiv ebx
      ;-------------------------- 
            
;--------------------------------
      pop edi
      pop esi
      pop ebx
      leave
      ret 16

snall endp
;--------------------------------



_TEXT ENDS
END START