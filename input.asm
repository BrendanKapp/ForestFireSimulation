#
# @author Brendan Kapp (bek7883)
#
# All input is handled in this file
#
PRINT_STRING = 4
READ_INT = 5
PRINT_INT = 1
READ_STRING = 12

	.data
input_data:
	.word	0, 0, 0

	.text
	.align 2

	.globl	input
	.globl	main
#
# input
#	paramets: none	
#	returns: v0 (-1 for fail, address of data for success)
#
input:
						# no stack allocations as it
						#  is not needed for this
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
	li	$v0, READ_STRING
	la	$t1, input_data
	syscall
	sw	$v0, 8($t1)
read_input_done:
						# validate data
	la	$t1, input_data			# data address
						# check size (4 <= 30)
	li	$t2, 4
	li	$t3, 30
	lw	$t4, 0($t1)
	slt	$t5, $t4, $t2
	bne	$t5, $zero, read_input_fail
	slt	$t5, $t3, $t4
	bne	$t5, $zero, read_input_fail
						# check generations (0 <= 20)
	li	$t2, 0
	li	$t3, 20
	lw	$t4, 4($t1)
	slt	$t5, $t4, $t2
	bne	$t5, $zero, read_input_fail
	slt	$t5, $t3, $t4
	bne	$t5, $zero, read_input_fail	
						# check wind (N, S, E, W)
						# (78, 83, 69, 87)
	li	$t2, 78
	lw	$t4, 8($t1)
	beq	$t4, $t2, read_input_pass
	li	$t2, 83
	beq	$t4, $t2, read_input_pass
	li	$t2, 69
	beq	$t4, $t2, read_input_pass
	li	$t2, 87
	beq	$t4, $t2, read_input_pass
	j	read_input_fail
read_input_pass:
	la	$v0, input_data			# return the data address
	jr	$ra
read_input_fail:
	la	$v0, -1				# return an error code
	jr	$ra
