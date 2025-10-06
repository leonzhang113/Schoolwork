#############################################################################

	 li   $v0, 42
      	 la   $a1, 9		     # 9 is the upper bound of the random int range.
      	 syscall			     # The randomly-generated number is stored in $a0.
      	 addi   $a0, $a0, 1
         jal initializeComputerIndex # set computer index to be 3 to begin


input_loop:
         jal  dumpTable        # call print routine. 

get_user_input_again:
         jal getInteger

         beq $v0, 0, input_quit 
         beq $v0, 9000, input_draw
         beq $v0, 101, dump_debug_scanWinner  #debug hook.. to do whatever
         beq $v0, 102, dump_debug_state
         beq $v0, 103, debug_UpdateStateForComputer # set state value for computer for given index
         beq $v0, 104, debug_UpdateStateForUser # set state value for computer for given index

         blt $v0, 1, input_error_note  # range check must be 1 -  9 unless debug command above
         bgt $v0, 9, input_error_note

         add $a0, $zero, $v0
         addi $a1, $zero, 0   # user is calling findIndex...
         jal findIndex

         #if findIndex return value is 0, it means error
         beq $v0, 0, user_index_error

         jal  dumpTable        # paint board to update after user input
         jal play_Sound

         # scan the board to see if user won
         addi $a0, $zero, 1
         jal scanWinner
         beq $v0, 1, user_won_exit

         # COMPUTER MOVES
         jal computerMove      # call function that generates computer move (i.e., computer input and processing)
         jal  dumpTable        # paint board to update after computer move
	 jal play_Computer_Sound
         # scan the board to see if computer won
         addi $a0, $zero, 2
         jal scanWinner
         beq $v0, 1, computer_won_exit

         j input_loop

user_index_error:
         add $a0, $zero, $v1
         jal printAlreadyUsed
         jal play_Error_Sound
         j get_user_input_again

input_error_note:
         jal printRangeError
         jal play_Error_Sound
         j get_user_input_again

dump_debug_scanWinner:
         addi $a0, $zero, 2
         jal debugScanWinner
         j input_loop

dump_debug_state:
         jal debug_output_state
         j input_loop

debug_UpdateStateForComputer: # set state value for computer for given label
         jal  getIntegerForComputerSim
         subi $a0, $v0, 1
         addi $a1, $zero, 2
         jal updateBoard
         j input_loop

debug_UpdateStateForUser: # set state value for computer for given label
         jal getInteger
         subi $a0, $v0, 1
         addi $a1, $zero, 1
         jal updateBoard
         j input_loop

input_quit:
         li       $v0, 10        # system service 10 is exit
         syscall                 

input_draw:
	jal printUserDraw
	jal play_Lose_Sound
	li $v0, 10
	syscall

user_won_exit:
         jal printUserWon
         jal play_Win_Sound
         li       $v0, 10        # system service 10 is exit
         syscall                 

computer_won_exit:
         jal printComputerWon
         jal play_Lose_Sound
         li       $v0, 10        # system service 10 is exit
         syscall                 
