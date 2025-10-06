.data      
successSoundEffect:	.word 70
computerSoundEffect:	.word 75
sseLength:		.word 1
sseDurr:		.word 500
errorSoundEffect:	.word 35, 35
errorDuration:		.word 300, 300
winSoundEffect:		.word 40, 42, 45, 47, 50, 52, 55, 57, 60, 62,
      			65, 67, 70, 72, 75, 77, 80, 82, 85, 87,
     			60, 62, 65, 67, 70, 72, 75, 77, 80, 82,
      			85, 87, 60, 62, 65, 67, 70, 72, 75, 77,
      			80, 82, 85, 87, 60, 62, 65, 67, 70, 72
winSoundLength:		.word 50
winSoundDuration: 	.word 400, 200, 300, 200, 300, 200, 300, 200, 300, 500,
      			400, 200, 300, 200, 300, 200, 300, 200, 300, 400,
      			400, 200, 300, 200, 300, 200, 300, 200, 300, 400,
      			400, 200, 300, 200, 300, 200, 300, 200, 300, 500,
      			400, 200, 300, 200, 300, 200, 300, 200, 300, 400
loseSoundEffect:	.word 40, 39, 38
loseSoundDuration:	.word 400, 600, 900
loseSoundLength:	.word 3
returncall:		.asciiz "return"
.text

.globl play_Sound
play_Sound:
	la	$s0, successSoundEffect      # loads the array of notes 
  	la 	$s1, sseDurr	# loads the array of durations
  
  	li	$t1, 0 				# iterator
	lw	$t2, sseLength	# load the length value

	lw   	$a0, 0($s0)     	# sets a0 to the first element in the notes array  
  	lw 	$a1, 0($s1)
  
  	addi 	$t1, $t1, 1 
  	addi 	$s0, $s0, 4
  	addi 	$s1, $s1, 4
  	li   $a2, 113		# sets instrument
  	li   $a3, 64      		# sets volume
  	li   $v0, 33	
  	syscall
  	
 	jr $ra
 
.globl play_Computer_Sound	
play_Computer_Sound:
	la	$s0, computerSoundEffect      # loads the array of notes 
  	la 	$s1, sseDurr	# loads the array of durations
  
  	li	$t1, 0 				# iterator
	lw	$t2, sseLength	# load the length value

	lw   	$a0, 0($s0)     	# sets a0 to the first element in the notes array  
  	lw 	$a1, 0($s1)
  
  	addi 	$t1, $t1, 1 
  	addi 	$s0, $s0, 4
  	addi 	$s1, $s1, 4
  	li   $a2, 113		# sets instrument
  	li   $a3, 64      		# sets volume
  	li   $v0, 31		
  	syscall
  	
 	jr $ra
 	
.globl play_Error_Sound
play_Error_Sound:
	la	$s0, errorSoundEffect      # loads the array of notes 
  	la 	$s1, errorDuration	# loads the array of durations
  
  	li	$t1, 0 				# iterator
	li	$t2, 2	# load the length value
	
error_Sound:
	beq	$t1, $t2, return	# stops once the song is over
	lw   	$a0, 0($s0)     	# sets a0 to the first element in the notes array  
  	lw 	$a1, 0($s1)
  
  	addi 	$t1, $t1, 1 
  	addi 	$s0, $s0, 4
  	addi 	$s1, $s1, 4
  	li   $a2, 124		# sets instrument
  	li   $a3, 64      		# sets volume
  	li   $v0, 33		
  	syscall
  	
  	j error_Sound

.globl play_Win_Sound
play_Win_Sound:
	la	$s0, winSoundEffect      # loads the array of notes 
  	la 	$s1, winSoundDuration	# loads the array of durations
  
  	li	$t1, 0 				# iterator
	lw	$t2, winSoundLength	# load the length value
	
win_Sound:
	beq	$t1, $t2, return
	lw   	$a0, 0($s0)     	# sets a0 to the first element in the notes array  
  	lw 	$a1, 0($s1)
  
  	addi 	$t1, $t1, 1 
  	addi 	$s0, $s0, 4
  	addi 	$s1, $s1, 4
  	li   $a2, 0	# sets instrument
  	li   $a3, 64      		# sets volume
  	li   $v0, 33		
  	syscall
  	
  	j win_Sound
  	
.globl play_Lose_Sound
play_Lose_Sound:
	la	$s0, loseSoundEffect      # loads the array of notes 
  	la 	$s1, loseSoundDuration	# loads the array of durations
  
  	li	$t1, 0 				# iterator
	lw	$t2, loseSoundLength	# load the length value
	j	lose_Sound
	
lose_Sound:
	beq	$t1, $t2, return
	lw   	$a0, 0($s0)     	# sets a0 to the first element in the notes array  
  	lw 	$a1, 0($s1)
  
  	addi 	$t1, $t1, 1 
  	addi 	$s0, $s0, 4
  	addi 	$s1, $s1, 4
  	li   $a2, 44		# sets instrument
  	li   $a3, 64      		# sets volume
  	li   $v0, 33		
  	syscall
  	
  	j lose_Sound

return:
	jr $ra
