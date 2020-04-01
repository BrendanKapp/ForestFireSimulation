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

main:
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
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

main_done:
	lw	$s1, 0($sp)
	lw	$s2, 4($sp)
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
