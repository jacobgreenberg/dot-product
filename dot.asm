; This is my code!
; Jacob Greenberg
; CS371 Assignment 3
; This file contains a program that computes the vector
; dot product of two arrays of unsigned integers


       include 371-prologue.inc


       .const
BUFFER_LENGTH equ 50
ARR_OFFSET    equ 4
ARR_SIZE      equ 3


        .data
prompt  byte  "Please enter an array of size ", 0
format  byte  "%lu", CR, LF, 0
prod    byte  "The vector dot product is ", 0


        .data?
buffer  byte  BUFFER_LENGTH dup(?)
temp    dword ARR_SIZE dup(?)
a       dword ARR_SIZE dup(?)
b       dword ARR_SIZE dup(?)
result  dword ?


        .code
; purpose:   print an integer
; input:     eax holds the integer
; output:    prints the integer
; destroys:  nothing
;
p_int   proc
        push eax
        push ebx
        push ecx
        push edx

        push eax
        push offset format
        push offset buffer
        call wsprintf
        add  esp, 12

        push offset buffer
        call StdOut

        pop  edx
        pop  ecx
        pop  ebx
        pop  eax
        ret
p_int   endp


; purpose:   read in array and store in temp
; input:     array of numbers from command line
; output:    nothing
; destroys:  nothing
;
r_arr   proc
        push eax
        push ebx
        push ecx
        push edx

        push offset prompt
        call StdOut
        mov  eax, ARR_SIZE
        call p_int

        mov  ebx, 0

forloop:
        cmp  ebx, ARR_SIZE
        jnl  endfor
        push BUFFER_LENGTH
        push offset buffer
        call StdIn
        push offset buffer
        call atodw
        mov  temp[ebx*ARR_OFFSET], eax
        inc  ebx
        jmp  forloop

endfor:
        pop  edx
        pop  ecx
        pop  ebx
        pop  eax
        ret
r_arr   endp


; purpose:   calculate dot product of two arrays
; input:     global arrays a and b
; output:    nothing
; destroys:  nothing
;
dot     proc
        push eax
        push ebx
        push ecx
        push edx

        mov  ebx, 0
        mov  edx, 0

forloop:
        cmp  ebx, ARR_SIZE
        jnl  endfor
        mov  eax, a[ebx*ARR_OFFSET]
        imul eax, b[ebx*ARR_OFFSET]
        add  edx, eax
        mov  eax, 0
        inc  ebx
        jmp  forloop

endfor:
        mov  eax, edx
        push eax
        push offset format
        call p_int

        pop  edx
        pop  ecx
        pop  ebx
        pop  eax
        ret
dot     endp


; purpose:   call procs, assign temp to a and b, and ouput result
; input:     nothing
; output:    the result of dot product calculations
; destroys:  nothing
;
main    proc
        push ebx
        mov  ebx, 0
        call r_arr

arr_one:
        cmp  ebx, ARR_SIZE
        jnl  end_one
        mov  eax, temp[ebx*ARR_OFFSET]
        mov  a[ebx*ARR_OFFSET], eax
        inc  ebx
        jmp  arr_one

end_one:
        mov  ebx, 0
        call r_arr

arr_two:
        cmp  ebx, ARR_SIZE
        jnl  end_two
        mov  eax, temp[ebx*ARR_OFFSET]
        mov  b[ebx*ARR_OFFSET], eax
        inc  ebx
        jmp  arr_two

end_two:
        push offset prod
        call StdOut

        call dot
        push eax
        call p_int                 
        pop  ebx

        push 0
        call ExitProcess
main    endp
        end  main
