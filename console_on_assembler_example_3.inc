.686P
.model flat,stdcall
;------------------
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\masm32.lib

extern ExitProcess@4:near
extern GetStdHandle@4:near
extern CloseHandle@4:near
extern WriteConsoleA@20:near
extern ReadConsoleA@20:near
extern wsprintfA:near
extern StdOut@4:near
extern StdIn@8:near
extern StripLF@4:near
extern SetConsoleMode@8:near
extern SetConsoleTitleA@4:near
extern SetConsoleTextAttribute@8:near
;----------------------------------



.const

FOREGROUND_BLUE                      equ 1h
FOREGROUND_GREEN                     equ 2h
FOREGROUND_RED                       equ 4h
FOREGROUND_INTENSITY                 equ 8h
BACKGROUND_BLUE                      equ 10h
BACKGROUND_GREEN                     equ 20h
BACKGROUND_RED                       equ 40h
BACKGROUND_INTENSITY                 equ 80h

COLOR                   equ   FOREGROUND_GREEN or FOREGROUND_INTENSITY

MAX_SIZE          equ     255
STD_INPUT_HANDLE  equ     -10
STD_OUTPUT_HANDLE equ     -11
;----------------------------------

.data?




.data
szBuffer           db MAX_SIZE dup(0)
szExit             db "Press any key. . .",0
szTitle            db "Input/Output console demo.",0
szLine1            db "Enter a line:",13,10,0
szFrm              db "String length = %d",13,10,0




