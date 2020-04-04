#
# @author Brendan Kapp
# this routine will perform the basic rules of the simulation
#

	.text
	.align	2
	.globl	setup_rules
	.globl	rule_1
	.globl	rule_2
	.globl	rule_3
grid_location:
	.word	0, 0		# grid, old grid

#
# setup_rules sets up the grid addresses for the rules to use
# parameters: a0 (grid), a1 (old grid)
# returns: none
#
setup_rules:
	la	$t0, grid_location
	sw	$a0, 0($t0)
	sw	$a1, 4($t1)
	jr	$ra
get_grid:
	la	$t0, grid_location
	lw	$v0, 0($t0)
	jr	$ra
get_old_grid:
	la	$t0, grid_location
	lw	$v0, 4($t0)
	jr	$ra
#
# rule_1 applies the first rule to the grid location (x, y)
# a burning cell from the previous generation turns into an empty grass
# cell in the current generation
# parameters: a0 (x), a1 (y)
# returns: none
#
rule_1:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20	
	jr	$ra

#
# rule_2 applies the second rule to the grid location (x, y)
# a tree in the previous generation will burn if at least one
# of its cardinal direction neighbors in the previous generation
# is burning, otherwise it will stay a tree
# paramters: a0 (x), a1 (y)
# returns: none
# 
rule_2:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20	
	jr	$ra

#
# rule_3 applies the third rule to the grid location (x, y)
# a previous generation tree will turn an adjacent empty
# grass cell into a current generation tree if that
# empty cell is in the given wind direction
# parameters: a0 (x), a1 (y), a2 (wind direction)
# returns: none
#
rule_3:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20	
	jr	$ra

