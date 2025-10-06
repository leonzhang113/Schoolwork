#############################################################################

.data

# multiply game board with label (i.e., 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 14 ....)
.globl table_label
table_label:    .word  1,  2,  3,  4,  5,  6, 
                       7,  8,  9, 10, 12, 14, 
                      15, 16, 18, 20, 21, 24, 
                      25, 27, 28, 30, 32, 35, 
                      36, 40, 42, 45, 48, 49, 
                      54, 56, 63, 64, 72, 81

# the game board cell's state (0 == free, 1 == player, 2 == computer)
.globl table_state
table_state:    .word  0, 0, 0, 0, 0, 0,  
                       0, 0, 0, 0, 0, 0,
                       0, 0, 0, 0, 0, 0,
                       0, 0, 0, 0, 0, 0,
                       0, 0, 0, 0, 0, 0,
                       0, 0, 0, 0, 0, 0

.globl size
size:    .word    36

user:    .word    0
compu:   .word    0

space:.asciiz         " "          
space8:.asciiz         "        "  
leftbracket:.asciiz   "["          
rightbracket:.asciiz  "]"          
leftparent:.asciiz    "("          
rightparent:.asciiz   ")"          
linefeed:.asciiz  "\n"             
linefeed2:.asciiz  "\n\n"          
linefeed3:.asciiz  "\n\n\n"          
userstr: .asciiz "user: "
compustr: .asciiz "    computer: "
border: .asciiz  "-------------------------\n"
winnerheader: .asciiz "\n\nINDEX  VALUE     LABEL    STATE\n"
findIndexStr: .asciiz "FINDINDEX "

###############################################################
# Subroutine that initializes the computer index value 
#
#   Argument:
#             a0   - value
#
.text
.globl initializeComputerIndex
initializeComputerIndex:
      sw $a0, compu         # set computer index value (compu)
      jr   $ra

###############################################################
# Subroutine that prints the table
#    It will use sub-routine to print out element value
#
#   Argument: 
#             a0   - index1
#             a1   - index2
#
#   Saved Register: ra  (because we call function)
#
.text
.globl dumpTable

dumpTable:
      addi $sp, $sp, -4     # decrement stack pointer to make space for $ra
      sw   $ra, 0($sp)      # save ra

      addi $sp, $sp, -4
      sw $s0, 0($sp)        # save s0

      addi $sp, $sp, -4
      sw $s1, 0($sp)        # save s1

      addi $sp, $sp, -4
      sw $s2, 0($sp)        # save s2

      addi $sp, $sp, -4
      sw $s3, 0($sp)        # save s3

      addi $sp, $sp, -4
      sw $s4, 0($sp)        # save s4

      la   $s0, table_label # table_label array
      lw   $s1, size        # array size
      la   $s4, table_state # table_label array
      add  $s2, $zero, 1    # initialize 'column' counter to  1

      la   $a0, border      # load address of the border string
      li   $v0, 4           # specify Print String service
      syscall               # print the heading string

out:  
      lw   $a0, 0($s4)     
      jal spacerL

      lw $a0, 0($s0)
      blt  $a0,10,singledigit
      j continue 
singledigit:
      la   $a0, space       # load address of spacer for syscall
      li   $v0, 4           # specify Print String service
      syscall               # print the spacer string

continue:
      lw   $a0, 0($s0)      # load the integer to be printed
      li   $v0, 1           # specify Print Integer service
      syscall        
      
      lw   $a0, 0($s4)      # store the value in matrix element
      jal spacerR

      addi $s2, $s2, 1      # increment 'column'

      add  $a0, $zero, $s2  # set argument a0 with counter
      jal  checkforlinefeed # WARNING: s2 being written by subroutine checkforlinefeed
      add  $s2, $zero, $v0  # the column counter could be modified by checkforlinefeed
    
      addi $s0, $s0, 4      # increment address of data to be printed
      addi $s4, $s4, 4      # increment address of data to be printed
      addi $s1, $s1, -1     # decrement loop counter
      addi $s3, $s3, 1      # increment counter
      bgtz $s1, out         # repeat while not finished
      
      la   $a0, border      # load address of the border string
      li   $v0, 4           # specify Print String
      syscall               # print the heading string

      la   $a0, userstr     # print 'user: '
      li   $v0, 4           # specify Print String
      syscall               # print the heading string
      lw   $a0, user        # print user index value
      li   $v0, 1           # specify Print Integer
      syscall               

      la   $a0, compustr    # print '   computer: '
      li   $v0, 4           # specify Print String
      syscall               # print the heading string
      lw   $a0, compu       # print computer index value
      li   $v0, 1           # specify Print Integer
      syscall               

      la   $a0, linefeed3    # next line
      li   $v0, 4           # specify Print String
      syscall               # print the heading string

      lw $s4, 0($sp)     # restore s4 *NOTE* do the reverse since its stack
      addi $sp, $sp, 4

      lw $s3, 0($sp)     # restore s3
      addi $sp, $sp, 4

      lw $s2, 0($sp)     # restore s2
      addi $sp, $sp, 4

      lw $s1, 0($sp)     # restore s1
      addi $sp, $sp, 4

      lw $s0, 0($sp)     # restore s0
      addi $sp, $sp, 4

      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # pop stack

      jr   $ra              # return from subroutine

###############################################################
# Subroutine that print line feed if needed.
#
#   Argument: a0: current counter value
#
      .text
checkforlinefeed:
      add  $t3, $zero, $a0  # counter value

      bgt  $t3, 6, newline # if column is 6, process

      add $v0, $zero, $a0
      jr $ra

newline:
      la   $a0, linefeed2   # next line
      li   $v0, 4           # specify Print String
      syscall               # print the heading string
      add $v0, $zero, 1
      jr $ra
 
###############################################################
# Subroutine that print 'spacer' depending the value passed a0
#
#   Argument: a0: state of the cell
#             if == 0,   print SPACE
#             if == 1,   print (
#             otherwise, print [ 
      .text
spacerL:
      beq $a0, 0, printl_space
      beq $a0, 1, printl_parenthesis

      la   $a0, leftbracket  # load address of spacer for syscall
      li   $v0, 4           # specify Print String
      syscall               # print the spacer string
      jr $ra

printl_space:
      la   $a0, space       # load address of spacer for syscall
      li   $v0, 4           # specify Print String
      syscall               # print the spacer string
      jr $ra

printl_parenthesis:
      la   $a0, leftparent  # load address of spacer for syscall
      li   $v0, 4           # specify Print String
      syscall               # print the spacer string
      jr $ra


###############################################################
# Subroutine that print 'spacer' depending the value passed a0
#
#   Argument: a0: state of the cell
#             if == 0,   print SPACE
#             if == 1,   print )
#             otherwise, print ] 
      .text
spacerR:
      beq $a0, 0, printr_space
      beq $a0, 1, printr_parenthesis

      la   $a0, rightbracket  # load address of spacer for syscall
      li   $v0, 4           # specify Print String
      syscall               # print the spacer string
      jr $ra

printr_space:
      la   $a0, space       # load address of spacer for syscall
      li   $v0, 4           # specify Print String
      syscall               # print the spacer string
      jr $ra

printr_parenthesis:
      la   $a0, rightparent  # load address of spacer for syscall
      li   $v0, 4           # specify Print String
      syscall               # print the spacer string
      jr $ra


################################################################
# Subroutine to set the gameboard box (area) for User.
# The area will be marked by ( )
#
#   if the value is not valid (i.e., does not exists)
#   notthing will happen
#  Subroutine that return index value for given 'label' value
#
#   Argument: 
#             a0: user (or computer) entered value (i.e,, 1, .... 42, 45, ...)
#             a1: 0 means user 1 means computer
#                 if 0, multiply by compu
#                 if 1, multiply by user
#      return: v0: 0 means fail.
#                  1 means success.
#              v1: the multiplied value
#
      .text

.globl findIndex
findIndex:
      la   $t0, table_label # table_label array
      lw   $t1, size        # array size

      beq $a1, $zero, use_user_index

      lw $s0, user          # it's not 0:multiply by user index value
      sw $a0, compu         # the index value is for compu
      addi $t4, $zero, 2
      j after_arg1_process

use_user_index:
      lw $s0, compu         # it's 0:multiply by computer index value
      sw $a0, user          # the index value is for user
      addi $t4, $zero, 1

after_arg1_process:
      mul  $t2, $s0, $a0
      add  $v1, $zero, $t2  # save return value the muliplied value at v1
      add  $t3, $zero, 1    # initialize 'column' counter to  1

repeat:  
      lw   $a0, 0($t0)      # load the integer 
      beq $a0, $t2, matched
      
      addi $t3, $t3, 1      # increment 'column'

      addi $t0, $t0, 4      # increment address of data to be printed
      addi $t1, $t1, -1     # decrement loop counter
      bgtz $t1, repeat      # repeat while not finished
      j find_index_return_error

matched:
      subi $t3, $t3, 1
      mul  $t6, $t3, 4

      lw   $t5, table_state($t6)   # check the table_state and if its already taken
      bne  $t5, 0, find_index_return_error # if so, return error

      sw   $t4, table_state($t6) # store the value in matrix element
      
      addi $v0, $zero, 1
      jr   $ra              # return from subroutine since match found

find_index_return_error:
      addi $v0, $zero, 0
      jr   $ra              # return from subroutine without match
 

################################################################
# Subroutine that uses supplied index as computer generated
# index.
#   Argument:
#             a0   - integer to be used as if generated by computer
#   Return:
#             v0   - 0  failed   1 successful
#
      .text
.globl computerMove
	
computerMove:
      addi $sp, $sp, -4     # decrement stack pointer to make space for $ra
      sw   $ra, 0($sp)      # save ra

      addi $sp, $sp, -4
      sw $s0, 0($sp)        # save s0

      addi $sp, $sp, -4
      sw $s1, 0($sp)        # save s1

computer_index_try_again:
      jal fakeComputer      # replace with random input generator
                            # fakeComputer asks user to input number
                            #
                            # replace with some smart function that computes a good value

      addi $a1, $zero, 2   # computer is calling findIndex...
      jal findIndex
      beq $v0, 0, computer_index_try_again  # if the resulting game board is already occupied,
                                            # simply call 'fakeComputer' to get new value.

      lw $s1, 0($sp)     # restore s5 *NOTE* do the reverse since its stack
      addi $sp, $sp, 4

      lw $s0, 0($sp)     # restore s4
      addi $sp, $sp, 4

      lw   $ra, 0($sp)      # restore saved $ra from the stack
      addi $sp, $sp, 4      # 

      jr   $ra              # return from subroutine without match


################################################################
# Subroutine this will fake computer input processing
#    by asking user for input (replace this later w/ random value)
#
#   Return:
#             v0  integer value entered
fakeComputer:
         addi $sp, $sp, -4    
         sw   $ra, 0($sp)      # save ra

         addi $sp, $sp, -4
         sw $s0, 0($sp)        # save s0

         addi $sp, $sp, -4
         sw $s1, 0($sp)        # save s1

getIntegerForComputerSimAgain:
         jal getIntegerForComputerSim
         add $a0, $zero, $v0

         blt $a0, 1, computer_input_error_note
         bgt $a0, 9, computer_input_error_note

         add $v0, $zero, $a0

         lw $s1, 0($sp)     # restore s5 *NOTE* do the reverse since its stack
         addi $sp, $sp, 4

         lw $s0, 0($sp)     # restore s4
         addi $sp, $sp, 4

         lw   $ra, 0($sp)      # restore saved $ra from the stack
         addi $sp, $sp, 4      # 

         jr   $ra              # return from subroutine since match found

computer_input_error_note:
         jal printRangeError
         j getIntegerForComputerSimAgain
        

################################################################
# Subroutine set board state value to given state. 
# 
# Argument:
#             a0: game index value (i.e, 0 - 35)
#             a1: 1 or 2 (for user or computer)
#
      .text
.globl updateBoard

updateBoard:
      bgt $a0, 35, ignore_error

      mul  $t6, $a0, 4
      sw   $a1, table_state($t6) # store the value in matrix element

ignore_error:
      jr   $ra              # return from subroutine without match

