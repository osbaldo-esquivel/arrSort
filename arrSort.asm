TITLE Array Sorting(arrSort.asm)

;// Author: Osbaldo Esquivel
;// Date: 17MAY2015
;// Description: The user will enter a value between 10 and 200. The program will
;// then generate that many random values and store them in an array. It will then
;// sort the array using bubble sort and display the sorted array. Finally, it will
;// calculate and display the median of the array.

Include Irvine32.inc

MIN = 10
MAX = 200
LO = 100
HI = 999

.data
intro	BYTE		"                         Array Sorting", 0
intro_1	BYTE		"                               by", 0
intro_2	BYTE		"                        Osbaldo Esquivel", 0
intro_3	BYTE		"================================================================", 0
instr_1	BYTE		"This program will ask you to enter a number between 10 and 200.", 0
instr_2	BYTE		"It will then generate that many random numbers between 100 and 999.", 0
askName	BYTE		"User, please enter your name and press <Enter>: ", 0
hiUser	BYTE		", I hope you are doing well. Let's have fun with arrays!", 0
prompt	BYTE		"Please enter a value from 10 to 200: ", 0
valMsg	BYTE		"Please enter a valid number from 10 to 200. ", 0
outro	BYTE		", I hope you had fun with this array demonstration. See ya!", 0
space	BYTE		"    ", 0
firstArray BYTE	"The array of random values is: ", 0
sortArray	BYTE		"The sorted array of random values is: ", 0
showMedian BYTE	"The median value of the array is: ", 0
userName	BYTE		21 DUP(0)
userVal	DWORD ?
anArray	DWORD	MAX DUP(? )
range	DWORD ?
sum		DWORD	0
mid		DWORD ?
mid1		DWORD ?
mid2		DWORD ?
ptrArray	DWORD	anArray

.code
main PROC

call Randomize

call SetColor

push OFFSET intro_3
push OFFSET intro_2
push	OFFSET intro_1
push	OFFSET intro
call Introduction

push OFFSET instr_2
push OFFSET instr_1
call UserInstr

push OFFSET hiUser
push OFFSET userName
push OFFSET askName
call GetUserName

push OFFSET valMsg
push OFFSET userVal
push	OFFSET prompt
call GetUserData

push OFFSET anArray
push	userVal
call FillArray

push	OFFSET space
push	OFFSET anArray
push OFFSET firstArray
push userVal
call DisplayList

push OFFSET anArray
push	userVal
call SortList

push OFFSET space
push OFFSET anArray
push	OFFSET sortArray
push userVal
call DisplayList

push	OFFSET showMedian
push OFFSET anArray
push userVal
call	DisplayMedian

push OFFSET userName
push OFFSET outro
call Farewell

exit
main ENDP

; ***********************************************************
SetColor PROC
;// Set color of text and background
;// Receives: nothing
;// Returns: nothing
; ***********************************************************
mov	eax, yellow + (green * 16)
call SetTextColor
call	Clrscr
ret
SetColor ENDP

; ************************************************************
Introduction PROC
;// Introduce program to user
;// Receives: nothing
;// Returns: EDX = various intro strings
; ************************************************************
push ebp
mov	ebp, esp
mov	edx, [ebp + 8]
call	WriteString
call Crlf

mov	edx, [ebp + 12]
call WriteString
call Crlf

mov	edx, [ebp + 16]
call WriteString
call Crlf

mov	edx, [ebp + 20]
call	WriteString
call Crlf
pop	ebp
ret	16
Introduction ENDP

; ************************************************************
UserInstr PROC
;// Show user instructions for program
;// Receives: nothing
;// Returns: EDX = various instruction strings
; ************************************************************
push	ebp
mov	ebp, esp
mov	edx, [ebp + 8]
call WriteString
call Crlf

mov edx, [ebp + 12]
call WriteString
call Crlf
pop	ebp
ret	8
UserInstr ENDP

; *************************************************************
GetUserName PROC
;// Get user name
;// Receives: offset to userName and prompt string
;// Returns: nothing
; *************************************************************
call Crlf
push ebp
mov	ebp, esp
mov	edx, [ebp + 8]
call WriteString
mov	edx, [ebp + 12]
mov	ecx, 21
call ReadString
call Crlf

call WriteString
mov	edx, [ebp + 16]
call WriteString
call Crlf
pop	ebp
ret	12
GetUserName ENDP

; *************************************************************
GetUserData PROC
;// Get user value for number of random values to generate
;// Receives: offset for va/valMsg strings and userVal
;// Returns: nothing
; *************************************************************
push	ebp
mov	ebp, esp
getVal :
call Crlf
mov	edx, [ebp + 8]
call WriteString
call ReadInt
call Crlf
mov	esi, [ebp + 12]
mov[esi], eax
cmp	eax, MIN
jl	validate
cmp	eax, MAX
jg	validate
pop	ebp
ret	12
validate:
mov	edx, [ebp + 16]
call WriteString
call Crlf
jmp	getVal
GetUserData ENDP

; *********************************************************
FillArray PROC
;// Fills an array with the amount of random values
;// specified by the user.
;// Receives: offset to an array and it's size
;// Returns: ESI = filled array
; *********************************************************
push ebp
mov	ebp, esp
mov	esi, [ebp + 12]
mov	ecx, [ebp + 8]
mov	eax, HI
sub	eax, LO
inc	eax
mov	range, eax
L1 :
mov	eax, range
call RandomRange
add	eax, LO
mov[esi], eax
add	esi, 4
loop L1
call Crlf
pop	ebp
ret 8
FillArray ENDP

; ************************************************************
SortList PROC
;// uses a pointer to an array to bubble sort the array
;// Receives: offset to an array
;// Returns: ESI = sorted array
; ************************************************************
push ebp
mov	ebp, esp
mov	ecx, [ebp + 8]
dec	ecx
L1 :
push	ecx
mov	esi, [ebp + 12]
L2 :
   mov	eax, [esi]
   cmp[esi + 4], eax
   jg	L3
   xchg	eax, [esi + 4]
   mov[esi], eax
L3 :
add	esi, 4
loop	L2
pop	ecx
loop L1
pop	ebp
ret	8
SortList ENDP

; **************************************************************
DisplayMedian PROC
;// computes median and displays to user. if the user value is
;// even, it takes the middle two values and finds the average.
;// if the user value is odd, it displays the middle value.
;// Receives: offset to an array, userMedian value, and userVal
;// Returns: EAX = median of array
; **************************************************************
push ebp
mov	ebp, esp
mov	edx, [ebp + 16]
call	WriteString
mov	eax, [ebp + 8]
inc	eax
cdq
mov	ebx, 2
div	ebx
mov	esi, [ebp + 12]
cmp	edx, 0
jz	ifOdd
ifeven :
dec	eax
mov	edx, eax
mov	ebx, [esi + edx * 4]
inc	eax
mov	edx, eax
mov	eax, [esi + edx * 4]
add	eax, ebx
cdq
mov	ebx, 2
div	ebx
call WriteDec
call Crlf
jmp	jmpOut
ifOdd :
dec	eax
mov	edx, eax
mov	eax, [esi + edx * 4]
call WriteDec
call Crlf
jmpOut :
pop ebp
ret 12
DisplayMedian ENDP

; ***************************************************************
DisplayList PROC
;
;// Displays integers stored in an array ten per line
;// Receives: offset to various strings, and array
;// Returns: ESI = an array
; ***************************************************************
push ebp
mov	ebp, esp
mov	edx, [ebp + 12]
call	WriteString
call Crlf
mov	ecx, [ebp + 8]
mov	esi, [ebp + 16]
mov	ebx, 0
L1:
mov	eax, [esi]
call	WriteDec
mov	edx, [ebp + 20]
call	WriteString
inc	ebx
cmp	ebx, 10
je	nextLine
add	esi, 4
loop L1
getOut :
call Crlf
call WaitMsg
call Crlf
call Crlf
pop ebp
ret 20
nextLine:
call Crlf
mov	ebx, 0
cmp	ecx, 1
je	getOut
dec	ecx
jmp	L1
DisplayList ENDP

; ***************************************************************
Farewell PROC
;// This procedure will say farwell to the user
;// Receives: offset to outro string
;// Returns: nothing
; ***************************************************************
call Crlf
push ebp
mov	ebp, esp
mov	edx, [ebp + 12]
call WriteString
mov	edx, [ebp + 8]
call WriteString
call Crlf
call Crlf
pop	ebp
ret	8
Farewell ENDP

END main
