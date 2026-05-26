    .data
.org             0x40

input_addr:      .word  0x80
output_res_addr: .word  0x84
output_data_addr: .word  0x400
input_pointer:   .word  0x400
output_pointer:  .word  0

BUF_SIZE:        .byte  64
B_64_SIZE:       .byte  45
ENDL:            .byte  '\n'
OVERFLOW_WORD:   .word  0xCCCCCCCC

    .text
    .org     0x100

base64_encoding:
    link     A6, 0

    move.l   8(A6), D4
    move.l   12(A6), D5
    move.l   16(A6), D6

    move.l   D4, D7
    lsr.l    2, D7
    and.l    0x3F, D7
    jsr      base64_sym
    move.l   D7, D0

    move.l   D4, D7
    and.l    0x03, D7
    lsl.l    4, D7
    move.l   D5, D3
    lsr.l    4, D3
    or.l     D3, D7
    and.l    0x3F, D7
    jsr      base64_sym
    move.l   D7, D1

    move.l   D5, D7
    and.l    0x0F, D7
    lsl.l    2, D7
    move.l   D6, D3
    lsr.l    6, D3
    or.l     D3, D7
    and.l    0x3F, D7
    jsr      base64_sym
    move.l   D7, D2

    move.l   D6, D7
    and.l    0x3F, D7
    jsr      base64_sym
    move.l   D7, D3

    unlk     A6
    rts

base64_sym:
    cmp.l    26, D7
    blt      base64_upper

    cmp.l    52, D7
    blt      base64_lower

    cmp.l    62, D7
    blt      base64_digit

    cmp.l    62, D7
    beq      base64_plus

    move.l   0x2F, D7
    rts

base64_upper:
    add.l    0x41, D7
    rts

base64_lower:
    sub.l    26, D7
    add.l    0x61, D7
    rts

base64_digit:
    sub.l    52, D7
    add.l    0x30, D7
    rts

base64_plus:
    move.l   0x2B, D7
    rts

_start:
    movea.l  0x500, A7

    movea.l  output_pointer, A0
    movea.l  (A0), A0

    movea.l  output_res_addr, A1
    movea.l  (A1), A1

    movea.l  input_addr, A2
    movea.l  (A2), A2

    movea.l  output_data_addr, A3
    movea.l  (A3), A3

    movea.l  input_pointer, A4
    movea.l  (A4), A4

    move.l   0, D1

input_loop:
    move.b   (A2), D0

    movea.l  ENDL, A5
    cmp.b    (A5), D0
    beq      base64_legit_check

    move.b   D0, (A3)+
    add.b    1, D1

    movea.l  BUF_SIZE, A5
    cmp.b    (A5), D1
    bpl      overflow

    jmp      input_loop

base64_legit_check:
    movea.l  B_64_SIZE, A5
    cmp.b    (A5), D1
    bgt      overflow

    move.l   D1, D2

encoding_loop:
    cmp.b    3, D2
    blt      handle_remainder

    move.l   0, D4
    move.b   (A4)+, D4

    move.l   0, D5
    move.b   (A4)+, D5

    move.l   0, D6
    move.b   (A4)+, D6

    move.l   D2, -(A7)

    move.l   D6, -(A7)
    move.l   D5, -(A7)
    move.l   D4, -(A7)

    jsr      base64_encoding

    move.b   D0, (A0)+
    move.b   D0, (A1)

    move.b   D1, (A0)+
    move.b   D1, (A1)

    move.b   D2, (A0)+
    move.b   D2, (A1)

    move.b   D3, (A0)+
    move.b   D3, (A1)

    move.l   (A7)+, D7
    move.l   (A7)+, D7
    move.l   (A7)+, D7

    move.l   (A7)+, D2
    sub.b    3, D2

    jmp      encoding_loop

handle_remainder:
    cmp.b    0, D2
    beq      finish_encoding

    cmp.b    1, D2
    beq      handle_one_byte

    jmp      handle_two_bytes

handle_one_byte:
    move.l   0, D4
    move.b   (A4)+, D4

    move.l   0, D5
    move.l   0, D6

    move.l   D6, -(A7)
    move.l   D5, -(A7)
    move.l   D4, -(A7)

    jsr      base64_encoding

    move.b   D0, (A0)+
    move.b   D0, (A1)

    move.b   D1, (A0)+
    move.b   D1, (A1)

    move.b   0x3D, (A0)+
    move.b   0x3D, (A1)

    move.b   0x3D, (A0)+
    move.b   0x3D, (A1)

    move.l   (A7)+, D7
    move.l   (A7)+, D7
    move.l   (A7)+, D7

    jmp      finish_encoding

handle_two_bytes:
    move.l   0, D4
    move.b   (A4)+, D4

    move.l   0, D5
    move.b   (A4)+, D5

    move.l   0, D6

    move.l   D6, -(A7)
    move.l   D5, -(A7)
    move.l   D4, -(A7)

    jsr      base64_encoding

    move.b   D0, (A0)+
    move.b   D0, (A1)

    move.b   D1, (A0)+
    move.b   D1, (A1)

    move.b   D2, (A0)+
    move.b   D2, (A1)

    move.b   0x3D, (A0)+
    move.b   0x3D, (A1)

    move.l   (A7)+, D7
    move.l   (A7)+, D7
    move.l   (A7)+, D7

    jmp      finish_encoding

finish_encoding:
    move.b   0, (A0)
    jmp      end

overflow:
    movea.l  output_pointer, A0
    movea.l  (A0), A0

    movea.l  OVERFLOW_WORD, A5
    move.l   (A5), (A0)
    move.l   (A5), (A1)

end:
    halt