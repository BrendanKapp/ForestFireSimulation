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
invalid_grid_size:
	.asciiz "ERROR: invalid grid size\n"
invalid_num_gen:
	.asciiz "ERROR: invalid number of generations\n"
invalid_wind_dir:
	.asciiz "ERROR: invalid wind direction\n"
invalid_char_grid:
	.asciiz "ERROR: invalid character in grid\n"
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
	.globl	rule_1
	.globl	rule_2
	.globl	rule_3

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

	jal	print_banner

	jal	input
	li	$t0, -1
	bne	$v0, $t0, input_success		# check if the return given
						#  is -1 (fail) or success 		
input_failed:
	li	$v0, PRINT_STRING
	li	$t1, 1
	beq	$v1, $t1, error_size
	li	$t1, 2
	beq	$v1, $t1, error_gen
	li	$t1, 3
	beq	$v1, $t1, error_wind
	li	$t1, 4
	beq	$v1, $t1, error_char
error_size:
	la	$a0, invalid_grid_size
	j	error_end
error_gen:
	la	$a0, invalid_num_gen
	j	error_end
error_wind:
	la	$a0, invalid_wind_dir
	j	error_end	
error_char:
	la	$a0, invalid_char_grid
	j	error_end
error_end:
	syscall
	j	main_done
input_success:
	move	$t1, $v0			# save grid address	
main_loop_start:
	jal	grid_create			# create the grid
	move	$s7, $v0			# grid address
	li	$s0, 0 				# generations counter
	lw	$s1, 0($t1)			# size
	lw	$s2, 4($t1)			# generations
	lw	$s3, 8($t1)			# wind
	jal	grid_cycle			# cycle the grid
main_loop:
#
# print
#
	move	$a0, $s7
	move	$a1, $s0
	move	$a2, $s1
	jal	print_grid
#	
# loop over all grid spaces
#
	li	$s4, 0				# x counter
	li	$s5, -1				# y counter
grid_loop_outer:
	addi	$s5, $s5, 1
	li	$s4, 0				# reset x counter
	beq	$s5, $s1, grid_loop_end
grid_loop_inner:
#	
# apple rule 1
#
	move	$a0, $s4
	move	$a1, $s5
	jal	rule_1
#
# apply rule 2
#
	move	$a0, $s4
	move	$a1, $s5
	move	$a2, $s1
	jal	rule_2
#
# apply rule 3
#
	move	$a0, $s4
	move	$a1, $s5
	move	$a2, $s1
	move	$a3, $s3
	jal	rule_3

	addi	$s4, $s4, 1
	beq	$s4, $s1, grid_loop_outer
	j	grid_loop_inner
grid_loop_end:
	jal	grid_cycle			# copy generation
	beq	$s0, $s2, main_done		# loop
	addi	$s0, $s0, 1			# increment
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
