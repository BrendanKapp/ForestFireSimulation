#
# @author Brendan Kapp (bek7883)
#
# All input is handled in this file
#
PRINT_STRING = 4
READ_INT = 5
PRINT_INT = 1
READ_CHAR = 12
READ_STRING = 8

	.data
	.align	2
input_data:
	.word	0, 0, 0				# size, generations, wind
input_grid_data:
	.space	32
input_direction:
	.space	32

	.text
	.align	2

	.globl	input
	.globl	main
	.globl	grid_set
#
# input
#	parameters: none	
#	returns: v0 (-1 for fail, address of data for success)
#
input:
	addi	$sp, $sp, -36
	sw	$ra, 32($sp)
	sw	$s7, 28($sp)
	sw	$s6, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	li	$t0, 2			
	la	$t1, input_data
						# empty input
	li	$t3, -1
	sw	$t3, 0($t1)
	sw	$t3, 4($t1)
	sw	$t3, 8($t1)

read_input_loop:
	li	$v0, READ_INT			# read input
	syscall
	sw	$v0, 0($t1)
	addi	$t1, $t1, 4			# update pointer
	addi	$t0, $t0, -1
	beq	$t0, $zero, read_input_text	# branch after 3
	j	read_input_loop
read_input_text:
	la	$t0, input_direction
	move	$a0, $t0
	li	$a1, 3
	li	$v0, READ_STRING
	syscall
	lb	$t3, 0($t0)
	sw	$t3, 8($t1)	
read_input_done:
						# validate data
	la	$t1, input_data			# data address
						# check size (4 <= 30)
	li	$v1, 1				# error code 1
	li	$t2, 4
	li	$t3, 30
	lw	$t4, 0($t1)
	slt	$t5, $t4, $t2
	bne	$t5, $zero, read_input_fail
	slt	$t5, $t3, $t4
	bne	$t5, $zero, read_input_fail
						# check generations (0 <= 20)
	li	$v1, 2				# error code 2
	li	$t2, 0
	li	$t3, 20
	lw	$t4, 4($t1)
	slt	$t5, $t4, $t2
	bne	$t5, $zero, read_input_fail
	slt	$t5, $t3, $t4
	bne	$t5, $zero, read_input_fail	
						# check wind (N, S, E, W)
						# (78, 83, 69, 87)
	li	$v1, 3				# error code 3
	li	$t2, 78
	lw	$t4, 16($t1)
	move	$v1, $t4
	beq	$t4, $t2, read_input_pass
	li	$t2, 83
	beq	$t4, $t2, read_input_pass
	li	$t2, 69
	beq	$t4, $t2, read_input_pass
	li	$t2, 87
	beq	$t4, $t2, read_input_pass
	j	read_input_fail
read_input_pass:
	#la	$v0, input_data			# return the data address
	j	read_grid_start
read_input_fail:
	la	$v0, -1				# return an error code
	j	read_input_finish
read_grid_start:
	la	$t1, input_data			# data address
	lw	$s1, 0($t1)			# size of grid
	li	$s2, 0				# counter
read_grid_loop:
	# read each line of input
	la	$a0, input_grid_data
	li	$a1, 32	
	li	$v0, READ_STRING
	syscall
	#la	$a0, input_grid_data
	#li	$v0, PRINT_STRING
	#syscall
	# verify each line (either continue or error)
	la	$s4, input_grid_data		# verify address
	li	$s3, 0				# verify counter
	li	$s5, -1				# error code
verify_loop:
	lb	$a0, 0($s4)
	jal	grid_text_to_int
	beq	$v0, $s5, verify_fail
	# save each piece
	move	$a0, $s3			# x location
	move	$a1, $s2			# y location
	move	$a2, $v0			# value
	jal	grid_set

	addi	$s3, $s3, 1
	addi	$s4, $s4, 1
	beq	$s3, $s1, verify_end
	j	verify_loop
verify_end:
	# go to next line		
	addi	$s2, $s2, 1
	beq	$s1, $s2, read_grid_finish
	j	read_grid_loop
verify_fail:
	li	$v0, -1
	move	$v1, $s3
	j	read_input_finish
read_grid_finish:
	la	$v0, input_data	
read_input_finish:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$s6, 24($sp)
	lw	$s7, 28($sp)
	lw	$ra, 32($sp)
	addi	$sp, $sp, 36
	jr	$ra

#
# takes in the grid input and returns the int to store
# parameters: a0 (grid input)
# returns: v0 (int to store, -1 for bad value)
#
grid_text_to_int:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
						# ascii values to check for
						# B (66), t (116), . (46)
	li	$t0, 66				# check for B
	li	$v0, 3				# set to burning
	beq	$a0, $t0, grid_text_end
	li	$t0, 116			# check for t
	li	$v0, 2				# set to tree
	beq	$a0, $t0, grid_text_end
	li	$t0, 46				# check for .
	li	$v0, 1				# set to grass
	beq	$a0, $t0, grid_text_end
	
	li	$v0, -1				# error
grid_text_end:
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
