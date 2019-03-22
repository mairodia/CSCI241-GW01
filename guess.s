section .data
    enter_prompt:       db      "Enter range, low to high: ", 0
    enter_input:        db      "%d %d", 0
    think_prompt:       db      "Think of an integer between %d and %d", 10, 0
    guess_prompt:       db      "Is your number less than, equal to, or greater than %d (l, e, g)? ", 0
    guess_input:        db      " %c", 0
    guess_correct:      db      "I guessed it!", 10, 0
    cheater:            db      "You must be cheating!", 10, 0

section .text
extern printf
extern scanf
global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 8*2

    mov rdi, enter_prompt ; "Enter range, low to high: "
    call printf

    mov rdi, enter_input
    lea rsi, [rbp]      ; low
    lea rdx, [rbp-8]    ; high
    call scanf          ; "%d %d"

    mov rsi, [rbp]      ; low
    mov rdx, [rbp-8]    ; high

    mov r13, rsi        ; r13 =  low
    mov r15, rdx        ; r15 = high
    mov r14, r15        ; r14 = high
    sub r14, r13        ; r14 = high - low
    shr r14, 1          ; r14 = r14/2 =  mid
    add r14, r13        ; mid = low + mid

    mov rdi, think_prompt   ; "Think of an integer between %d and %d"
    call printf

    binary_search:

    .while:

        cmp r13, r15    ; if low = high ...
        je .cheater     ; ... you cheated!

        mov rdi, guess_prompt   ; Is your number less than, equal to, or
                                ; greater than [mid]
        mov rsi, r14            ; rsi = mid
        call printf

        mov rdi, guess_input    ; l, e, or g
        lea rsi, [rbp]          ; rsi = char
        call scanf
        mov rsi, [rbp]

        cmp rsi, 'l'
        je .less_than

        cmp rsi, 'g'
        je .greater_than

        cmp rsi, 'e'
        je .found

        .less_than:
            mov r15, r14    ; high = mid
            sub r14, r13    ; mid = mid - low
            shr r14, 1      ; mid = mid/2
            add r14, r13    ; mid = mid + low
            jmp .while

        .greater_than:
            mov r13, r14    ; low = mid
            mov r14, r15    ; mid = high
            sub r14, r13    ; mid = mid - low
            shr r14, 1      ; mid = mid/2
            add r14, r13    ; mid = mid + low

        jmp .while

    .cheater:
        mov rdi, cheater
        call printf
        mov rax, 60
        mov rdi, 0
        pop rbp
        syscall

    .found:
        mov rdi, guess_correct
        call printf
        mov rax, 60
        mov rdi, 0
        pop rbp
        syscall

; end program :)
