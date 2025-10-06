
	.data

rangeerrorstr: .asciiz "Input value must be 1, 2, 3, 4, 5, 6, 7, 8, or 9. Try again\n"
computerwonstr: .asciiz "Computer Won!\n"
userwonstr: .asciiz "Congratulations, You Won!\n"
valuestr: .asciiz "Value:"
alreadystr: .asciiz " already used. Try again\n"
drawstr: .asciiz "A stalemate! Better luck next time.\n"
debugstatestr: .asciiz "STATES:\n"
computer_index_label_str: .asciiz "*DEBUG* COMPUTER INPUT    "
space:.asciiz         " "          # space to insert between numbers
linefeed:.asciiz  "\n"       # space to insert between numbers
winning_move_str:.asciiz "Winning Location:\n"

	.text

################################################################
# Subroutine to print "range error"
#
.globl printRangeError
printRangeError:
      la   $a0, rangeerrorstr
      li   $v0, 4
      syscall
      jr   $ra

################################################################
# Subroutine to print "Computer Won!"
#
.globl printComputerWon
printComputerWon:
      la   $a0, computerwonstr
      li   $v0, 4
      syscall
      jr   $ra

################################################################
# Subroutine to print "*DEBUG* COMPUTER INPUT    "
#
.globl debug_computer_index_label
debug_computer_index_label:
      la   $a0, computer_index_label_str
      li   $v0, 4
      syscall
      jr   $ra              # return from subroutine since match found

################################################################
# Subroutine to print "Congratulations, You Won!"
#
.globl printUserWon
printUserWon:
      addi $sp, $sp, -4    
      sw   $ra, 0($sp)      # save ra

      la   $a0, userwonstr
      li   $v0, 4
      syscall

      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # 

      jr   $ra              # return from subroutine since match found

.globl debug_output_state
debug_output_state:
      la   $a0, debugstatestr
      li   $v0, 4
      syscall

      la   $t0, table_state # table_label array
      lw   $t1, size        # array size
      add  $t2, $zero, 1    # initialize 'column' counter to  1
    
out_debug_output_state:
      lw   $a0, 0($t0)      # load the integer to be printed
      addi $t2, $t2, 1      # increment 'column'

      li   $v0, 1           # specify Print Integer service
      syscall               

      la   $a0, space
      li   $v0, 4
      syscall

      addi $t0, $t0, 4      # increment address of data to be printed
      addi $t1, $t1, -1     # decrement loop counter
      add  $t2, $zero, 1    # initialize 'column' counter to  1
      bgtz $t1, out_debug_output_state     # repeat while not finished

      la   $a0, linefeed
      li   $v0, 4
      syscall

      jr   $ra              # return from subroutine since match found

################################################################
# Subroutine to print "The value: xx already used. Try again"
#
#  argument a0 contains value to be printed
#
.globl printAlreadyUsed
printAlreadyUsed:
      add $s0, $zero, $a0   # save argument to s0 

      la   $a0, valuestr
      li   $v0, 4
      syscall

      add  $a0, $zero, $s0  # load the integer to be printed
      li   $v0, 1           # specify Print Integer service
      syscall               

      la   $a0, alreadystr
      li   $v0, 4
      syscall

      jr   $ra              # return from subroutine since match found
      
################################################################
# Subroutine to print message if game is drawn (stalemate has occurred)
#  Argument: a0  address of message (need to be globl)
#            a1  integer to be printed

.globl printUserDraw
printUserDraw:

	la $a0, drawstr
	li $v0, 4
	syscall
	
	jr $ra



################################################################
# Subroutine to print given label and an interger value
#
#  Argument: a0  address of message (need to be globl)
#            a1  integer to be printed
#
#   example
#      la $a0, testsomething
#      addi $a1, $zero, 42
#      jal printDebugInteger


.globl printDebugInteger
printDebugInteger:

      addi $sp, $sp, -4    
      sw   $ra, 0($sp)      # save ra

      addi $sp, $sp, -4
      sw $s4, 0($sp)        # save s4

      addi $sp, $sp, -4
      sw $s5, 0($sp)        # save s5

      add $s4, $zero, $a0 
      add $s5, $zero, $a1 

      la   $a0, ($s4)
      li   $v0, 4
      syscall

      la   $a0, space
      li   $v0, 4
      syscall

      add  $a0, $zero, $s5   
      li   $v0, 1            
      syscall                

      la   $a0, linefeed
      li   $v0, 4
      syscall

      lw $s5, 0($sp)     # restore s5 *NOTE* do the reverse since its stack
      addi $sp, $sp, 4

      lw $s4, 0($sp)     # restore s4
      addi $sp, $sp, 4

      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # 

      jr   $ra              # return from subroutine since match found

