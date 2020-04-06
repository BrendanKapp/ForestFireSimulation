#
# @author: Brendan Kapp (bek7883)
#
# This is forestfire main program and is responsible for the main loop
# of the project, it involves calling all the nessicary functions that
# manage the main state of the simulation.

#
# CONSTANTS
#

PRINT_STRING = 4
READ_INT = 5
PRINT_INT = 1

#
# DATA
#

	.data
input_failed_text:
	.asciiz	"Input failed\n"
input_success_text:
	.asciiz "Input passed\n"
newline:
	.asciiz "\n"

#
# CODE
#
	.text
	.align	2

	.globl	main
	.globl	input
	.globl	output
	.globl	grid_create
	.globl	grid_cycle
	.globl	print_banner
	.globl	print_grid

main:
	addi	$sp, $sp, -32
	sw	$ra, 28($sp)
	sw	$s7, 24($sp)
	sw	$s6, 20($sp)
	sw	$s5, 16($sp)
	sw	$s4, 12($sp)
	sw	$s3, 8($sp)
	sw	$s2, 4($sp)
	sw	$s1, 0($sp)

	jal	input
	li	$t0, -1
	bne	$v0, $t0, input_success		# check if the return given
						#  is -1 (fail) or success 		
input_failed:
	li	$v0, PRINT_STRING
	la	$a0, input_failed_text
	syscall

	li	$v0, PRINT_INT
	move	$a0, $v1
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall
	j	main_done
input_success:
	move	$t1, $v0			# print success message
	li	$v0, PRINT_STRING
	la	$a0, input_success_text
	syscall

	li	$v0, PRINT_INT			# print address
	move	$a0, $t1
	syscall
	
	li	$v0, PRINT_STRING
	la	$a0, newline
	syscall
main_loop_start:
	jal	grid_create			# create the grid
	move	$s7, $v0			# grid address
	li	$s0, 0 				# generations counter
	lw	$s1, 0($t1)			# size
	lw	$s2, 4($t1)			# generations
	lw	$s3, 8($t1)			# wind
	jal	print_banner
main_loop:
	# print
	move	$a0, $s7
	move	$a1, $s0
	move	$a2, $s1
	jal	print_grid
	# increment
	addi	$s0, $s0, 1
	# apple rule 1
	# apply rule 2
	# apply rule 3
	# copy generation
	jal	grid_cycle	
	# loop
	beq	$s0, $s2, main_done
	j	main_loop
	
main_done:
	lw	$s1, 0($sp)
	lw	$s2, 4($sp)
	lw	$s3, 8($sp)
	lw	$s4, 12($sp)
	lw	$s5, 16($sp)
	lw	$s6, 20($sp)
	lw	$s7, 24($sp)
	lw	$ra, 28($sp)
	addi	$sp, $sp, 32
	jr	$ra
