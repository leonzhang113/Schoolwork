###############################################################
# Subroutine to read a number from the User.
.data

#prompt_integer: .asciiz "Enter a number\n        0:quit \n        1-9:index \n        DEBUG\n            101:debug winner scan \n            102:dump state values \n            103: set board index to be computer \n            104: set board index to be user\n"

prompt_integer: .asciiz "Enter a index value (1-9, quit: 0, draw the game: 9000)\n"

prompt_computer_sim: .asciiz "Awaiting computer response...\n" # Enter a index (1-9) pretending to be the computer
.text
.globl getInteger

getInteger:
      la   $a0, prompt_integer      # load address of prompt for syscall
      li   $v0, 4                   # specify Print String
      syscall                       # print the prompt string
      li   $v0, 5                   # specify Read Integer
      syscall                       # Read the number. After this instruction, the number read is in $v0.

      jr   $ra                      # return from subroutine

.globl getIntegerForComputerSim

getIntegerForComputerSim:
      la   $a0, prompt_computer_sim # load address of prompt for syscall
      li   $v0, 4                   # specify Print String
      syscall                       # print the prompt string
      li   $v0, 42
      la   $a1, 9		     # 9 is the upper bound of the random int range.
      syscall			     # The randomly-generated number is stored in $a0.
      addi   $a0, $a0, 1
      move   $v0, $a0

      jr   $ra                      # return from subroutine
 
