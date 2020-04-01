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
	.asciiz " ====\n"
blank_line_text:
	.asciiz	"\n"
bar_text:
	.asciiz "|"
plus_text:
	.asciiz "+"
minus_text:
	.asciiz "-"
#
# CODE
#

#
# print the initial banner
# parameters: none
# returns: none
#
print_banner:
	li	$v0, PRINT_STRING
	la	$a0, banner_text
	syscall
	jal	print_blank_line
	jr	$ra

#
# prints the initial gridx
# parameters: a0 (grid address), a1 (generation number), a2 (grid size)
# returns: none
#
print_grid:
	addi	$sp, $sp -28
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
			
	li	$t0, 0			# x counter
	li	$t1, 0			# y counter
	jal	print_board_edge	
y_loop:
		
	addi	$t1, $t1, 1
	beq	$t1, $s2, finish
x_loop:
	addi	$t0, $t0, 1
	beq	$t0, $s2, y_loop_next
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
	jal	print_board_edge
	jal	print_blank_line
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8(sp)
	lw	$s3, 12$sp)
	lw	$s4, 16($sp)
	lw	$s5, 20$sp)
	lw	$ra, 24($sp)
	addi	$sp, 28
	jr	$ra
#
# prints the edge of the board, specifically the upper and lower edges
# formate: +------+ (with the number of minuses = grid size)
# parameters: a0 (how wide is the board)
# returns: none
#
print_board_edge:
	move	$t0, $a0
	li	$v0, PRINT_STRING
	la	$a0, plus_text
	syscall
edge_loop:
	li	$v0, PRINT_STRING
	la	$a0, minus_text
	syscall
	beq	$t0, $zero, finish_top
	addi	$t0, $t0, -1
	j	top_loop
finish_edge:
	li	$v0, PRINT_STRING
	la	$a0, plus_text
	syscall
	jal	print_blank_line
	jr	$ra

#
# prints the value at a specific (x, y) cordinate on the board
# parameters: a0 (x), a1 (y)
# returns: none
#
print_value:
	
#
# prints a blank line
#
print_blank_line:
	li	$v0, PRINT_STRING
	la	$a0, blank_line_text
	syscall
	jr	$ra
