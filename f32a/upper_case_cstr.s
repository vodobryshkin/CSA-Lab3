    .data
.org             0x00

buffer:          .byte  0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f,0x5f

    .data
.org             0x40

input_addr:      .word  0x80
output_addr:     .word  0x84
buffer_p:        .word  0x00

const_end_sym:   .word  0x0A
const_0:         .word  0x0
const_diff:      .word  0x20
const_neg:       .word  0x80000000
const_1:         .word  0x1
const_a:         .word  0x61
const_z:         .word  0x7a
const_limit:     .word  0x20
const_mask:      .word  0xFF
const_end_block: .word  0x5f5f5f00
const_overflow:  .word  0xCCCCCCCC

    .text
    .org 0x100

sub:
    inv
    @p const_1
    +
    +
    ;

is_lower:
    dup
    @p const_a
    sub
    -if next
    false ;
next:
    @p const_z
    over
    sub
    -if true
    false ;
true:
    @p const_1
    e_is_lower ;
false:
    @p const_neg
e_is_lower:
    ;

to_upper:
    is_lower
    -if create_upper
    e_to_upper ;
create_upper:
    @p const_diff
    sub
e_to_upper:
    ;

_start:
    @p input_addr
    @p buffer_p
    a!
    b!

while:
    @b
    dup
    @p const_end_sym
    sub
    if preparing

    to_upper
    !+

    a
    @p const_limit
    sub
    if overflow

    while ;

preparing:
    drop
    @p const_end_block
    !

    @p buffer_p
    a!
    @p output_addr
    b!

io_print:
    @+
    @p const_mask
    and
    dup
    if end
    !b
    io_print ;

overflow:
    @p const_overflow
    @p output_addr
    a!
    !
end:
    halt
