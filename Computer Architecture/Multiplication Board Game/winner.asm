#############################################################################

.data

diagonal_4_1: .word  3, 10, 17, 24
diagonal_4_2: .word  4,  9, 14, 19
diagonal_4_3: .word 18, 23, 28, 33
diagonal_4_4: .word 13, 20, 27, 34

diagonal_5_1: .word  2,  9, 16, 23, 30
diagonal_5_2: .word  7, 14, 21, 28, 35
diagonal_5_3: .word  5, 10, 15, 20, 27
diagonal_5_4: .word 12, 17, 22, 27, 32

diagonal_6_1: .word  1,  8, 15, 22, 29, 36
diagonal_6_2: .word  6, 11, 16, 21, 26, 31

horizontal_1: .word  1,  2,  3,  4,  5,  6
horizontal_2: .word  7,  8,  9, 10, 11, 12
horizontal_3: .word 13, 14, 15, 16, 17, 18
horizontal_4: .word 19, 20, 21, 22, 23, 24
horizontal_5: .word 25, 26, 27, 28, 29, 30
horizontal_6: .word 31, 32, 33, 34, 35, 36

vertical_1: .word     1,  7, 13, 19, 25, 31
vertical_2: .word     2,  8, 14, 20, 26, 32
vertical_3: .word     3,  9, 15, 21, 27, 33
vertical_4: .word     4, 10, 16, 22, 28, 34
vertical_5: .word     5, 11, 17, 23, 29, 35
vertical_6: .word     6, 12, 18, 24, 30, 36

linefeed:.asciiz  "\n"       # space to insert between numbers
space8:.asciiz         "        "      # space to insert between numbers
space:.asciiz         " "      # space to insert between numbers
border: .asciiz  "-------------------------\n"
winnerheader: .asciiz "\n\nINDEX  VALUE     LABEL    STATE\n"
counter_str: .asciiz "Count: "
index_str: .asciiz "Index: "
conseqcount_str: .asciiz "   Consecutive Count: "
state_str: .asciiz "State: "
label_str: .asciiz "Lable: "
count_str: .asciiz "       seq count: "
candidate_str: .asciiz "  candidate: "

diagonal_4_1_str: .asciiz "DIAGONAL 3,  10, 17, 24\n"
diagonal_4_2_str: .asciiz "DIAGONAL 4,  9,  14, 19\n" 
diagonal_4_3_str: .asciiz "DIAGONAL 18, 23, 28, 33\n"
diagonal_4_4_str: .asciiz "DIAGONAL 13, 20, 27, 3\n"

diagonal_5_1_str: .asciiz "DIAGONAL 2,  9, 16, 23, 30\n"
diagonal_5_2_str: .asciiz "DIAGONAL 7, 14, 21, 28, 35\n"
diagonal_5_3_str: .asciiz "DIAGONAL 5, 10, 15, 20, 27\n"
diagonal_5_4_str: .asciiz "DIAGONAL 12, 17, 22, 27, 32\n"

diagonal_6_1_str: .asciiz "DIAGONAL 1, 8,  15, 22, 29, 36\n"
diagonal_6_2_str: .asciiz "DIAGONAL 6, 11, 16, 21, 26, 31\n"

horizontal_1_str: .asciiz "HORIZ  1,  2,  3,  4,  5,  6\n"
horizontal_2_str: .asciiz "HORIZ  7,  8,  9, 10, 11, 12\n"
horizontal_3_str: .asciiz "HORIZ 13, 14, 15, 16, 17, 18\n"
horizontal_4_str: .asciiz "HORIZ 19, 20, 21, 22, 23, 24\n"
horizontal_5_str: .asciiz "HORIZ 25, 26, 27, 28, 29, 30\n"
horizontal_6_str: .asciiz "HORIZ 31, 32, 33, 34, 35, 36\n"

vertical_1_str: .asciiz "VERT 1,  7, 13, 19, 25, 31\n"
vertical_2_str: .asciiz "VERT 2,  8, 14, 20, 26, 32\n"
vertical_3_str: .asciiz "VERT 3,  9, 15, 21, 27, 33\n"
vertical_4_str: .asciiz "VERT 4, 10, 16, 22, 28, 34\n"
vertical_5_str: .asciiz "VERT 5, 11, 17, 23, 29, 35\n"
vertical_6_str: .asciiz "VERT 6, 12, 18, 24, 30, 36\n"

.text

################################################################
# Subroutine to scan one path for winner
#
#   Argument: 
#             a0: array address
#             a1: size of array
#             a2: check for 1: user or 2:computer
#
#   Return:
#             v0: consecutive mached values
#             v1: a possible good candidate ( 0 if none )
#
scanSegment:
      addi $sp, $sp, -4     # decrement stack pointer to make space for $ra
      sw   $ra, 0($sp)      # save ra

      addi $sp, $sp, -4
      sw $s0, 0($sp)        # save s0

      addi $sp, $sp, -4
      sw $s1, 0($sp)        # save s1

      addi $sp, $sp, -4
      sw $s2, 0($sp)        # save s2

      add  $t0, $zero, $a0   # scan index array  
      add  $t1, $zero, $a1   # size of the array
      add  $t2, $zero, $a2   # check for user or computer
      addi $t3, $zero, 1     # index   
      #t4 used for look up table_state or table_label
      addi $t5, $zero, 0     # count of consecutive 'a2' value
      addi $t7, $zero, 0     # used to save v1 return value

repeat_scanSegment:

      add  $s0, $zero, $t3
      sll $t6, $t3, 2       # multiply index by 4

      lw   $s2, 0($t0)      # save the index in the array to look up state and label
      subi $s2, $s2, 1
      sll $s2, $s2, 2       # multiply index by 4

      la   $t4, table_state # table_label array
      add  $t4, $t4, $s2
      lw   $s1, 0($t4) 

      la   $t4, table_label # table_label array
      add  $t4, $t4, $s2
      lw   $t8, 0($t4)      # load the integer to be printed 

      # la $a0, counter_str       #DEBUG
      # add $a1, $zero, $t3
      # jal printDebugInteger
      # la $a0, state_str         #DEBUG
      # add $a1, $zero, $s1 
      # jal printDebugInteger
      # la $a0, label_str         #DEBUG
      # add $a1, $zero, $t8 
      # jal printDebugInteger
      # la $a0, conseqcount_str #DEBUG
      # add $a1, $zero, $t5
      # jal printDebugInteger

      beq  $s1, $t2, scan_matched
      addi $t5, $zero, 0    # count of consecutive 'a2' value

      beq  $s1, 0, scanSegment_candidate  # check if $a0 is 0 if so,  set it as good candidate $v1
      j scanSegment_continue
scanSegment_candidate:
      add $t7, $zero, $t8

      j scanSegment_continue

scan_matched:
      addi $t5, $t5, 1      #increment
      bge  $t5, 4, scanSegment_exit  # if consecutive count 4 (or greater) exit

scanSegment_continue:
      addi $t0, $t0, 4      # increment address of data to be printed
      addi $t1, $t1, -1     # decrement loop counter
      addi $t3, $t3, 1
      bgtz $t1, repeat_scanSegment 

scanSegment_exit:
      add $v0, $zero, $t5   # return count
      add $v1, $zero, $t7

      lw $s2, 0($sp)     # restore s2
      addi $sp, $sp, 4

      lw $s1, 0($sp)     # restore s1
      addi $sp, $sp, 4

      lw $s0, 0($sp)     # restore s0
      addi $sp, $sp, 4

      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # pop the stack

      jr   $ra              # return from subroutine since match found


################################################################
# Subroutine to scan all possible winning paths.
# the paths are pre-defined as array.
#
#   ARGUMENT: 
#            a1: scan for user ( 0 ) or for computer ( 1 )
#   RETURN:
#           v0: return 0 if no winner 1 if winner (4 consecutive)
#           v1: a candidate value (some value that could used by computer move
#   
.globl scanWinner
scanWinner:
      addi $sp, $sp, -4     # decrement stack pointer to make space for $ra
      sw   $ra, 0($sp)      # save ra

      add  $t9, $zero, $a0  # use T9 for scan user or computer

      # -------------------------
      la   $a0, diagonal_4_1
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_1
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_4_2
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_2
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_4_3
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_3
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_4_4
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_4
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_5_1
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_1
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_5_2
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_2
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_5_3
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_3
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_5_4
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_4
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_6_1
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_6_1
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, diagonal_6_2
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_6_2
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, horizontal_1
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_1
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, horizontal_2
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_2
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, horizontal_3
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_3
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, horizontal_4
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_4
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, horizontal_5
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_5
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, horizontal_6
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_6
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, vertical_1
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_1
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, vertical_2
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_2
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, vertical_3
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_3
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, vertical_4
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_4
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, vertical_5
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_5
      bge $v0, 4, winner_found
      # -------------------------

      # -------------------------
      la   $a0, vertical_6
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_6
      bge $v0, 4, winner_found
      # -------------------------

      add  $v0, $zero, 0
      j winner_continue
winner_found:
      add  $v0, $zero, 1
winner_continue:
      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # pop the stack

      jr   $ra              # return from subroutine since match found

################################################################
# Subroutine to dump out the label value and state value
#   using all the 'scanning' vector
#

dumpScanSegment:
      add  $t0, $zero, $a0  # starting address of array of data to be printed
      add  $t1, $zero, $a1  # initialize loop counter to array size
      addi $t2, $zero, 1    # initialize loop counter to array size

      addi $sp, $sp, -4     # decrement stack pointer to make space for $ra
      sw   $ra, 0($sp)      # save ra

repeat_dumpScanSegment:
      add  $a0, $zero, $t2  # load the integer to be printed 
      li   $v0, 1           # specify Print Integer service
      syscall               

      la   $a0, space8      # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      lw   $a0, 0($t0)      # load the integer to be printed
      li   $v0, 1           # specify Print Integer service
      syscall               

      subi $t3, $a0, 1
      sll $t3, $t3, 2       # multiply index by 4

      la   $a0, space8      # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $t4, table_label # table_label array
      add  $t4, $t4, $t3
      lw   $a0, 0($t4)      # load the integer to be printed 
      li   $v0, 1           # specify Print Integer service
      syscall               

      la   $a0, space8      # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $t4, table_state # table_label array
      add  $t4, $t4, $t3
      lw   $a0, 0($t4)      # load the integer to be printed
      li   $v0, 1           # specify Print Integer service
      syscall               

      la   $a0, linefeed    # next line
      li   $v0, 4           # specify Print String service
      syscall               # print the heading string

      addi $t0, $t0, 4      # increment address of data to be printed
      addi $t1, $t1, -1     # decrement loop counter
      addi $t2, $t2, 1
      bgtz $t1, repeat_dumpScanSegment 

      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # pop the stack

      jr   $ra              # return from subroutine since match found


dumpResultScanSegment:
      add  $s0, $zero, $a0
      add  $s1, $zero, $a1

      la   $a0, linefeed    # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, ($a2)
      li   $v0, 4
      syscall

      la   $a0, count_str   # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      add  $a0, $zero, $s0  # load the integer to be printed
      li   $v0, 1           # specify Print Integer service
      syscall               
      la   $a0, candidate_str       # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string
      add  $a0, $zero, $s1  # load the integer to be printed 
      li   $v0, 1           # specify Print Integer service
      syscall               

      la   $a0, linefeed    # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, linefeed    # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      jr   $ra              # return from subroutine since match found

.globl debugScanWinner
debugScanWinner:
      addi $sp, $sp, -4     # decrement stack pointer to make space for $ra
      sw   $ra, 0($sp)      # save ra

      add  $t9, $zero, $a0  # use T9 for scan user or computer

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_4_1
      addi $a1, $zero, 4
      jal dumpScanSegment

      la   $a0, diagonal_4_1
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_1
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_4_1_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_4_2
      addi $a1, $zero, 4
      jal dumpScanSegment

      la   $a0, diagonal_4_2
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_2
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_4_2_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_4_3
      addi $a1, $zero, 4
      jal dumpScanSegment

      la   $a0, diagonal_4_3
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_3
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_4_3_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_4_4
      addi $a1, $zero, 4
      jal dumpScanSegment

      la   $a0, diagonal_4_4
      addi $a1, $zero, 4
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_4_4
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_4_4_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_5_1
      addi $a1, $zero, 5
      jal dumpScanSegment

      la   $a0, diagonal_5_1
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_1
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_5_1_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_5_2
      addi $a1, $zero, 5
      jal dumpScanSegment

      la   $a0, diagonal_5_2
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_2
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_5_2_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_5_3
      addi $a1, $zero, 5
      jal dumpScanSegment

      la   $a0, diagonal_5_3
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_3
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_5_3_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_5_4
      addi $a1, $zero, 5
      jal dumpScanSegment

      la   $a0, diagonal_5_4
      addi $a1, $zero, 5
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_5_4
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_5_4_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_6_1
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, diagonal_6_1
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_6_1
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_6_1_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, diagonal_6_2
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, diagonal_6_2
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, diagonal_6_2
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, diagonal_6_2_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, horizontal_1
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, horizontal_1
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_1
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, horizontal_1_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, horizontal_2
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, horizontal_2
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_2
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, horizontal_2_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, horizontal_3
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, horizontal_3
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_3
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, horizontal_3_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, horizontal_4
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, horizontal_4
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_4
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, horizontal_4_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, horizontal_5
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, horizontal_5
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_5
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, horizontal_5_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, horizontal_6
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, horizontal_6
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, horizontal_6
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, horizontal_6_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, vertical_1
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, vertical_1
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_1
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, vertical_1_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, vertical_2
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, vertical_2
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_2
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, vertical_2_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, vertical_3
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, vertical_3
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_3
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, vertical_3_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, vertical_4
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, vertical_4
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_4
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, vertical_4_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, vertical_5
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, vertical_5
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_5
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, vertical_5_str
      jal dumpResultScanSegment
      # -------------------------

      # -------------------------
      la   $a0, winnerheader # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

      la   $a0, vertical_6
      addi $a1, $zero, 6
      jal dumpScanSegment

      la   $a0, vertical_6
      addi $a1, $zero, 6
      add  $a2, $zero, $t9 
      jal scanSegment

      la  $a0, vertical_6
      bge $v0, 4, winner_found_debug

      add  $a0, $zero, $v0  # add argument here before print using syslog
      add  $a1, $zero, $v1
      la   $a2, vertical_6_str
      jal dumpResultScanSegment
      # -------------------------

debug_continue:
      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # pop stack

      jr   $ra              # return from subroutine since match found

winner_found_debug:
      jal printUserWon
      j debug_continue      # exit immediately after printing winning

