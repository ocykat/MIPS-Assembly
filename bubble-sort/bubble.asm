# Bubble Sort - Descending Order

.data
    msg0:
        .asciiz "Array: elems = [6, 5, 8, 1, 9, 2, 0, 4, 3, 7]\n"
    msg1:
        .asciiz "Result after BubbleSortDesc:\n"
    nums:
        .word 10
    elems:
        .word 6, 5, 8, 1, 9, 2, 0, 4, 3, 7


.text
# {{{ ----- Main Program -----
    Init:
        # @reg $s0: base address of elems
        # @reg $s1: nums (number of elements in elems)

        la      $s0, elems
        la      $t0, nums
        lw      $s1, 0($t0)
        add     $a0, $zero, $s0
        add     $a1, $zero, $s1
        jal     BubbleSortDesc

    Output:
        # print messages
        la      $a0, msg0
        li      $v0, 4          # print string
        syscall

        la      $a0, msg1
        li      $v0, 4          # print string
        syscall

        add     $a0, $zero, $s0
        add     $a1, $zero, $s1
        jal     PrintArray

    Exit:
        j       GlobalExitLabel

# }}} ----- Main Program -----


# {{{ ----- Procedure:  BubbleSortDesc -----
    BubbleSortDesc:
        # > Params
        # @reg $a0: base address of the array
        # @reg $a1: size of the array
        # > Temps
        # @reg $t0: sorted flag
        # @reg $t1: i
        # @reg $t2: address of a[i]
        # @reg $t3: a[i]
        # @reg $t4: a[i + 1]
        # @reg $t5: a[i] < a[i + 1]

        addi    $t0, $zero, 1        # sorted = 1
        addi    $t1, $zero, 0        # i = 0

    BubbleSortDescLoop:
        sll     $t2, $t1,   2
        add     $t2, $t2,   $a0

        lw      $t3, 0($t2)
        lw      $t4, 4($t2)
        slt     $t5, $t3,   $t4
        beq     $t5, $zero, BubbleSortDescBranchNoSwap

    BubbleSortDescBranchSwap:
        addi    $sp, $sp    -12      # spill
        sw      $ra, 0($sp)
        sw      $a1, 4($sp)
        sw      $t1, 8($sp)

        addi    $a1, $t1,   0
        addi    $a2, $t1,   1

        jal     Swap

        lw      $t1, 8($sp)          # fill
        lw      $a1, 4($sp)
        lw      $ra, 0($sp)
        addi    $sp, $sp,   12

        addi    $t0, $zero, 0

    BubbleSortDescBranchNoSwap:
        addi    $t1, $t1,   1
        beq     $t1, $a1,   BubbleSortDescLoopBreak
        j       BubbleSortDescLoop

    BubbleSortDescLoopBreak:
        beq     $t0, $zero, BubbleSortDescRecursiveCall
        jr      $ra

    BubbleSortDescRecursiveCall:
        addi    $sp, $sp,   -4       # spill
        sw      $ra, 0($sp)

        addi    $a1, $a1,   -1
        jal     BubbleSortDesc       # recursive call

        lw      $ra, 0($sp)          # fill
        addi    $sp, $sp,   4

        jr      $ra

# }}} ----- Procedure:  BubbleSortDesc -----


# {{{ ----- Procedure:  Swap -----
    # > Params
    # @reg $a0: base address of the array
    # @reg $a1: index of the first element to swap
    # @reg $a2: index of the second element to swap
    # > Temps
    # @reg $t0: address of the first element to swap
    # @reg $t1: address of the second element to swap
    # @reg $t2: value of the first element to swap
    # @reg $t3: value of the second element to swap

    Swap:
        sll     $t0, $a1,   2
        add     $t0, $t0,   $a0
        sll     $t1, $a2,   2
        add     $t1, $t1,   $a0

        lw      $t2, 0($t0)
        lw      $t3, 0($t1)
        sw      $t2, 0($t1)
        sw      $t3, 0($t0)

        jr      $ra

# }}} ----- Procedure:  Swap -----


# {{{ ----- Procedure:  PrintArray -----
    # > Params
    # @reg $a0: base address of the array
    # @reg $a1: size of the array
    # > Temps
    # @reg $t0: base address of the array (get from $a0)
    # @reg $t1: i
    # @reg $t2: address of a[i]

    PrintArray:
        add     $t0, $zero, $a0
        addi    $t1, $zero, 0        # i = 0

    PrintArrayLoop:
        sll     $t2, $t1,   2        # i * 4
        add     $t2, $t2,   $t0

        lw      $a0, 0($t2)
        li      $v0, 1
        syscall

        addi    $a0, $zero, ' '
        li      $v0, 11
        syscall

        addi    $t1, $t1,   1
        beq     $t1, $a1,   PrintArrayLoopBreak
        j       PrintArrayLoop

    PrintArrayLoopBreak:
        jr      $ra

# }}} ----- Procedure:  PrintArray -----

    GlobalExitLabel: