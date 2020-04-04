#
# @author Brendan Kapp (bek7883)
#
# This file handles all the grid management (get, set, create, close, etc.)
# Grid values are as follows:
# 0 = null
# 1 = grass
# 2 = tree
# 3 = burning tree
#

#
# DATA
#
	.data
	.align	2
grid_data:	
	.word	0:1024
grid_data_old:
	.word	0:1024
#
# CODE
#	
	.text
	.align	2
	.globl	grid_create
	.globl	grid_get
	.globl	grid_set
	.globl	grid_cycle
#
# assigns 0's to the entire grid of memory to be used
# grid builds from the top left outwards but always uses a 32x32 grid
# this enables the movement vertically to be done by +/- 32
# to move horizontally +/- 1
# parameters: a0 (x size), a1 (y size)
# returns: grid address
#
grid_create:
	la	$v0, grid_data
	jr	$ra
#
# grid_get will return the value at (a0, a1)
# parameters: a0 (x location), a1 (y location)
# returns: v0 (returns value, 0 for fail)
#
grid_get:
	la	$t0, grid_data
						# to retrieve a value:
						#  mem = 32 * y + x
	mul	$t1, $a1, 32
	add	$t2, $t1, $a0			# t2 is the offset
	add	$t3, $t2, $t0			# t3 is the address 

	lb	$v0, 0($t3)
	
	jr	$ra
#
# grid_set will set the value at (a0, a1)
# parameters: a0 (x location), a1 (y location), a2 (value)
# returns: none
#
grid_set:
	la	$t0, grid_data
						# to retrieve a value:
						#  mem = 32 * y + x
	mul	$t1, $a1, 32
	add	$t2, $t1, $a0			# t2 is the offset
	add	$t3, $t2, $t0			# t3 is the address 

	sb	$a2, 0($t3)	
		
	jr	$ra

#
# grid_cycle will copy the current data in grid into grid old
# this must be done for each cycle of the simulation
# this routine will copy the entirety of the 32x32 grid
# parameters: none
# returns: none
#
grid_cycle:
	addi	$sp, $sp, -4
	sw	$ra, 0($sp)
	
	li	$t0, 0			# x counter
	li	$t1, 0			# y counter
	la	$t2, grid_data		# used to access the memory addressses
	la	$t3, grid_data_old	# used to access the memory addresses
	li	$t4, 32
outer_cycle:
	li	$t0, 0			# reset x counter
	addi	$t1, $t1, 1
	beq	$t1, $t4, finish_cycle
inner_cycle:
	lb	$t5, 0($t2)		# load byte from old
	sb	$t5, 0($t3)		# save byte into new
	addi	$t2, $t2, 1		# memory address + 1
	addi	$t3, $t3, 1		# memory address + 1
	addi	$t0, $t0, 1
	beq	$t0, $t4, outer_cycle
	j	inner_cycle	
finish_cycle:

	lw	$ra, 0($sp)
	addi	$sp, $sp, 4
	jr	$ra
