    .data
input_addr:      .word  0x80
output_addr:     .word  0x84

OVERFLOW_CONST:  .word  0xCCCCCCCC

    .text
    .org     0x100
_start:
    lui      sp, 1

    lui      t0, %hi(input_addr)
    addi     t0, t0, %lo(input_addr)
    lw       t0, 0(t0)
    lw       a0, 0(t0)

    jal      ra, sum_odd_n

    lui      t0, %hi(output_addr)
    addi     t0, t0, %lo(output_addr)
    lw       t0, 0(t0)
    sw       a0, 0(t0)

    halt

sum_odd_n:
    ble      a0, zero, negative_banned

    addi     sp, sp, -4
    sw       ra, 0(sp)

    jal      ra, odd_count

    lw       ra, 0(sp)
    addi     sp, sp, 4

    lui      t0, 0xB
    addi     t0, t0, 1284
    bgt      a0, t0, overflow

    mul      a0, a0, a0
    jr       ra

negative_banned:
    addi     a0, zero, -1
    jr       ra

overflow:
    lui      t0, %hi(OVERFLOW_CONST)
    addi     t0, t0, %lo(OVERFLOW_CONST)
    lw       a0, 0(t0)
    jr       ra

odd_count:
    addi     a0, a0, 1
    addi     t0, zero, 2
    div      a0, a0, t0
    jr       ra
