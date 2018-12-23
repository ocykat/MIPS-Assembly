# Quick Sort - Ascending Order

.data
    msg0:
        .asciiz "Array: elems = [6, 5, 8, 1, 9, 2, 0, 4, 3, 7]\n"
    msg1:
        .asciiz "Result after QuickSort:\n"
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
        addi    $a1, $zero, 0
        add     $a2, $zero, $s1

        jal     QuickSort

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


# {{{ ----- Procedure:  QuickSort -----
    QuickSort:
        # > Params
        # @reg $a0: base address of the array
        # @reg $a1: begin index
        # @reg $a2: end index (exclusive)
        # > Temps
        # @reg $t0: pivot
        # @reg $t1: end - 1
        # @reg $t2: begin < end - 1

        addi    $t1, $a2,   -1

        slt     $t2, $a1,   $t1
        beq     $t2, $zero, QuickSortReturn

        addi    $sp, $sp,   -20       # spill
        sw      $ra, 0($sp)
        sw      $a1, 4($sp)
        sw      $a2, 8($sp)
        sw      $t1, 12($sp)
        sw      $t2, 16($sp)

        jal     Partition

        lw      $t2, 16($sp)           # fill
        lw      $t1, 12($sp)
        lw      $a2, 8($sp)
        lw      $a1, 4($sp)
        lw      $ra, 0($sp)
        addi    $sp, $sp,   20

        add     $t0, $zero, $v0

    QuickSortRecursiveCall_1:
        addi    $sp, $sp,   -12       # spill
        sw      $ra, 0($sp)
        sw      $a2, 4($sp)
        sw      $t0, 8($sp)

        addi    $a2, $t0,   0

        jal     QuickSort             # quickSort(a, begin, pivot)

        lw      $t0, 8($sp)           # fill
        lw      $a2, 4($sp)
        lw      $ra, 0($sp)
        addi    $sp, $sp,   12

    QuickSortRecursiveCall_2:
        addi    $sp, $sp,   -4
        sw      $ra, 0($sp)           # spill

        addi    $a1, $t0,   1

        jal     QuickSort             # quickSort(a, pivot + 1, end)

        lw      $ra, 0($sp)           # fill
        addi    $sp, $sp,   4

    QuickSortReturn:
        jr      $ra

# }}} ----- Procedure:  QuickSort -----


# {{{ ----- Procedure:  Partition -----
    # > Params
    # @reg $a0: base address of the array
    # @reg $a1: begin index
    # @reg $a2: end index (exclusive)
    # > Temps:
    # @reg $t0: end - 1
    # @reg $t1: pivotKey
    # @reg $t2: j
    # @reg $t3: i
    # @reg $t4: temp address of an element
    # @reg $t5: a[i]
    # @reg $t6: a[i] < pivotKey
    # > Return
    # @reg $v0: pivot

    Partition:
        addi    $t0, $a2,   -1
        sll     $t4, $t0,   2
        add     $t4, $t4,   $a0
        lw      $t1, 0($t4)

        add     $t2, $zero, $a1

        add     $t3, $zero, $a1

    PartitionLoop:
        sll     $t4, $t3,   2
        add     $t4, $t4,   $a0
        lw      $t5, 0($t4)

        slt     $t6, $t5,   $t1

        beq     $t6, $zero, PartitionBranchNoSwap

        addi    $sp, $sp,   -20       # spill
        sw      $ra, 0($sp)
        sw      $t0, 4($sp)
        sw      $t1, 8($sp)
        sw      $t2, 12($sp)
        sw      $t3, 16($sp)

        add     $a1, $zero, $t3
        add     $a2, $zero, $t2

        jal     Swap

        lw      $t3, 16($sp)          # fill
        lw      $t2, 12($sp)
        lw      $t1, 8($sp)
        lw      $t0, 4($sp)
        lw      $ra, 0($sp)
        addi    $sp, $sp,   20

        addi    $t2, $t2,   1

    PartitionBranchNoSwap:
        addi    $t3, $t3,   1
        beq     $t3, $t0,   PartitionLoopBreak
        j       PartitionLoop

    PartitionLoopBreak:
        addi    $sp, $sp,   -8         # spill
        sw      $ra, 0($sp)
        sw      $t2, 4($sp)

        add     $a1, $zero, $t2
        add     $a2, $zero, $t0

        jal     Swap

        lw      $t2, 4($sp)           # fill
        lw      $ra, 0($sp)
        addi    $sp, $sp,   8

        add     $v0, $zero, $t2
        jr      $ra

# }}} ----- Procedure:  Partition -----


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
    # @reg $t2: address of elems[i]

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