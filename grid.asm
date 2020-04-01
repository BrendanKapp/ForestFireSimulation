#
# @author Brendan Kapp (bek7883)
#
# This file handles all the grid management (get, set, create, close, etc.)
#

#
# DATA
#
	.data
	.align	2
grid_data:	
	.word	0:1024
after_grid:
	.word	1
#
# CODE
#	
	.text
	.align	2
	.globl	grid_create
	.globl	grid_get
	.globl	grid_set
#
# assigns 0's to the entire grid of memory to be used
# grid builds from the top left outwards but always uses a 32x32 grid
# this enables the movement vertically to be done by +/- 32
# to move horizontally +/- 1
# parameters: a0 (x size), a1 (y size)
# returns: v0 (0 for fail)
#
grid_create:
	# not implemented yet
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

	lw	$v0, 0($t3)
	
	jr	$ra
#
# grid_set will set the value at (a0, a1)
# parameters: a0 (x location), a1 (y location), a2 (value)
# returns: nothing
#
grid_set:
	la	$t0, grid_data
						# to retrieve a value:
						#  mem = 32 * y + x
	mul	$t1, $a1, 32
	add	$t2, $t1, $a0			# t2 is the offset
	add	$t3, $t2, $t0			# t3 is the address 

	sw	$a2, 0($t3)	
		
	jr	$ra
