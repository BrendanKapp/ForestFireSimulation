#
# @author Brendan Kapp (bek7883)
#
# All output is handled in this file
#

PRINT_STRING = 4
PRINT_INT = 1

#
# DATA
#
	.data
banner_text:
	.ascii	"+-------------+\n"
	.ascii	"| FOREST FIRE |\n"
	.asciiz	"+-------------+\n"
gen_banner1_text:
	.asciiz	"==== #"
gen_banner2_text:
	.asciiz	" ====\n"
blank_line_text:
	.asciiz	"\n"
bar_text:
	.asciiz	"|"
plus_text:
	.asciiz	"+"
minus_text:
	.asciiz	"-"
error_text:
	.asciiz	"E"
grass_text:
	.asciiz	"."
tree_text:
	.asciiz	"t"
burning_text:
	.asciiz	"B"
#
# CODE
#
	.text
	.align	2
	.globl	grid_get
	.globl	print_banner
	.globl	print_grid
#
# print the initial banner
# parameters: none
# returns: none
#
print_banner:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	li	$v0, PRINT_STRING
	la	$a0, banner_text
	syscall
	jal	print_blank_line
	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra

#
# prints the initial gridx
# parameters: a0 (grid address), a1 (generation number), a2 (grid size)
# returns: none
#
print_grid:
	addi	$sp, $sp, -28
	sw	$ra, 24($sp)
	sw	$s5, 20($sp)
	sw	$s4, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
					# print generation number banner
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	li	$v0, PRINT_STRING
	la	$a0, gen_banner1_text
	syscall

	li	$v0, PRINT_INT
	move	$a0, $s1	
	syscall

	li	$v0, PRINT_STRING
	la	$a0, gen_banner2_text
	syscall
					# print grid	
			
	li	$s4, 0			# x counter
	li	$s5, 0			# y counter
	
	move	$a0, $s2
	jal	print_board_edge	
y_loop:
	li	$s4, 0			# reset x counter
	addi	$s5, $s5, 1
	beq	$s5, $s2, finish

	li	$v0, PRINT_STRING
	la	$a0, bar_text
	syscall
x_loop:
	move	$a0, $s4
	move	$a1, $s5
	jal	print_value	

	addi	$s4, $s4, 1
	beq	$s4, $s2, y_loop_next
	j	x_loop
y_loop_next:
	li	$v0, PRINT_STRING
	la	$a0, bar_text
	syscall

	li	$v0, PRINT_STRING
	la	$a0, blank_line_text
	syscall
	j	y_loop
finish:
					# print blank line and finish
	move	$a0, $s2
	jal	print_board_edge
	jal	print_blank_line
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$s4, 16($sp)
	lw	$s5, 20($sp)
	lw	$ra, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra
#
# prints the edge of the board, specifically the upper and lower edges
# formate: +------+ (with the number of minuses = grid size)
# parameters: a0 (how wide is the board)
# returns: none
#
print_board_edge:
	addi	$sp, $sp, -12
	sw	$ra, 8($sp)
	sw	$a0, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a0
	li	$v0, PRINT_STRING
	la	$a0, plus_text
	syscall
edge_loop:
	li	$v0, PRINT_STRING
	la	$a0, minus_text
	syscall
	addi	$s0, $s0, -1
	beq	$s0, $zero, finish_edge
	j	edge_loop
finish_edge:
	li	$v0, PRINT_STRING
	la	$a0, plus_text
	syscall
	jal	print_blank_line

	lw	$s0, 0($sp)
	lw	$a0, 4($sp)
	lw	$ra, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra

#
# prints the value at a specific (x, y) cordinate on the board
# parameters: a0 (x), a1 (y)
# returns: none
#
print_value:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	jal	grid_get
	move	$t0, $v0
	li	$t1, 1
	beq	$t0, $t1, print_grass
	li	$t1, 2
	beq	$t0, $t1, print_tree
	li	$t1, 3
	beq	$t0, $t1, print_burning
print_error:
	la	$a0, error_text
	j	print_value_final
print_grass:
	la	$a0, grass_text
	j	print_value_final
print_tree:
	la	$a0, tree_text
	j	print_value_final
print_burning:
	la	$a0, burning_text
print_value_final:
	li	$v0, PRINT_STRING
	syscall

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4	
	jr	$ra
	
#
# prints a blank line
#
print_blank_line:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)

	li	$v0, PRINT_STRING
	la	$a0, blank_line_text
	syscall

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
