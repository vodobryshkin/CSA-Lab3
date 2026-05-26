    .data

input_addr:      .word  0x80
output_addr:     .word  0x84

buf:             .word  0
temp:            .word  0
second_half:     .word  0

mask_and:        .word  0x0000000F
mul_arg:         .word  0x10000000
counter:         .word  0x04

const_one:       .word  0x1
const_four:      .word  0x4
const_mask_first_half: .word  0xFFFF0000

    .text
    .org         0x100

_start:
    load         input_addr
    load_acc
    store_addr   buf

while:
    load         buf
    and          mask_and
    mul          mul_arg

    store        temp
    load         second_half
    add          temp
    store        second_half

    load         mask_and
    shiftl       const_four
    store        mask_and

    load         mul_arg
    shiftr       const_four
    shiftr       const_four
    store        mul_arg

    load         counter
    sub          const_one
    store        counter
    bnez         while

after_while:
    load         buf
    and          const_mask_first_half
    sub          second_half
    bnez         not_palindrome
    load_imm     0x1
    jmp          end
not_palindrome:
    load_imm     0x0
end:
    store_ind    output_addr
    halt
