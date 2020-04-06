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
	.globl	grid_get_old
	.globl	grid_set
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

	jal	grid_get_old
	li	$t1, 3
	bne	$v0, $t1, rule_1_end
						# set to grass
	li	$a2, 1
	jal	grid_set
rule_1_end:
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
# paramters: a0 (x), a1 (y), a2 (grid size)
# returns: none
# 
rule_2:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)
	
	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2

	jal	grid_get_old
	li	$t1, 2
	bne	$v0, $t1, rule_2_end
	# check above
	addi	$t0, $a0, -1
	slt	$t1, $t0, $zero			# 1 = val is neg, we skip
	bne	$t1, $zero, check_below
	# check if x - 1 is burning
	move	$a0, $t0
	move	$a1, $s1
	jal	grid_get_old
	li	$t1, 3
	beq	$v0, $t1, rule_2_burn
	# check below
check_below:
	addi	$t2, $s2, -1			# grid boundary
	addi	$t0, $s0, 1
	slt	$t1, $t2, $t0			# 1 = val is to large, skip
	bne	$t1, $zero, check_after	
	# check if x + 1 is burning
	move	$a0, $t0
	move	$a1, $s1
	jal	grid_get_old
	li	$t1, 3
	beq	$v0, $t1, rule_2_burn
	# check after
check_after:
	addi	$t2, $s2, -1			# grid boundary
	addi	$t1, $s1, 1
	slt	$t0, $t2, $t1			# 1 = val is to large, skip
	bne	$t0, $zero, check_before
	# check if y + 1 is burning
	move	$a0, $s0
	move	$a1, $t1
	jal	grid_get_old
	li	$t1, 3
	beq	$v0, $t1, rule_2_burn
	# check before
check_before:
	addi	$t1, $s1, -1
	slt	$t0, $s1, $zero			# 1 = val is neg, we skip
	bne	$t0, $zero, rule_2_end
	# check if y - 1 is burning
	move	$a0, $s0
	move	$a1, $t1
	jal	grid_get_old
	li	$t1, 3
	beq	$v0, $t1, rule_2_burn	
	j	rule_2_end
rule_2_burn:
	move	$a0, $s0
	move	$a1, $s1
	li	$a2, 3
	jal	grid_set
rule_2_end:
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
# parameters: a0 (x), a1 (y), a2 (grid size), a3 (wind direction)
# returns: none
#
rule_3:
	addi	$sp, $sp, -20
	sw	$ra, 16($sp)
	sw	$s3, 12($sp)
	sw	$s2, 8($sp)
	sw	$s1, 4($sp)
	sw	$s0, 0($sp)

	move	$s0, $a0
	move	$s1, $a1
	move	$s2, $a2
	move	$s3, $a3
	
	jal	grid_get_old
	li	$t1, 2
	bne	$v0, $t1, rule_3_end
	
	# check wind (N, S, E, W)
	# (78, 83, 69, 87)
	li	$t2, 78				# North
	beq	$s3, $t2, tree_before
	li	$t2, 83
	beq	$s3, $t2, tree_after		# South
	li	$t2, 69
	beq	$s3, $t2, tree_below		# East
	li	$t2, 87
	beq	$s3, $t2, tree_above		# West
	j	rule_3_end			# Error	
tree_above:	# west
	# check above
	addi	$t0, $a0, -1
	slt	$t1, $t0, $zero			# 1 = val is neg, we skip
	bne	$t1, $zero, rule_3_end
	# check if x - 1 is grass
	move	$a0, $t0
	move	$a1, $s1
	jal	grid_get_old
	li	$t1, 1
	beq	$v0, $t1, rule_3_tree
	j	rule_3_end
	# check below
tree_below:	# east
	addi	$t2, $s2, -1			# grid boundary
	addi	$t0, $s0, 1
	slt	$t1, $t2, $t0			# 1 = val is to large, skip
	bne	$t1, $zero, rule_3_end	
	# check if x + 1 is grass
	move	$a0, $t0
	move	$a1, $s1
	jal	grid_get_old
	li	$t1, 1
	beq	$v0, $t1, rule_3_tree
	j	rule_3_end
	# check after
tree_after:	# north
	addi	$t2, $s2, -1			# grid boundary
	addi	$t1, $s1, 1
	slt	$t0, $t2, $t1			# 1 = val is to large, skip
	bne	$t0, $zero, rule_3_end
	# check if y + 1 is grass
	move	$a0, $s0
	move	$a1, $t1
	jal	grid_get_old
	li	$t1, 1
	beq	$v0, $t1, rule_3_tree
	j	rule_3_end
	# check before
tree_before:	# south
	addi	$t1, $s1, -1
	slt	$t0, $s1, $zero			# 1 = val is neg, we skip
	bne	$t0, $zero, rule_3_end
	# check if y - 1 is grass
	move	$a0, $s0
	move	$a1, $t1
	jal	grid_get_old
	li	$t1, 1
	beq	$v0, $t1, rule_3_tree
	j	rule_3_end
rule_3_tree:
	#move	$a0, $s0
	#move	$a1, $s1
	li	$a2, 2
	jal	grid_set

rule_3_end:
	lw	$s0, 0($sp)
	lw	$s1, 4($sp)
	lw	$s2, 8($sp)
	lw	$s3, 12($sp)
	lw	$ra, 16($sp)
	addi	$sp, $sp, 20	
	jr	$ra

