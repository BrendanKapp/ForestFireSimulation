#
# Makefile for CCS Experiment 5 - merge sort
#

#
# Location of the processing programs
#
RASM  = /home/fac/wrc/bin/rasm
RLINK = /home/fac/wrc/bin/rlink

#
# Suffixes to be used or created
#
.SUFFIXES:	.asm .obj .lst .out

#
# Transformation rule: .asm into .obj
#
.asm.obj:
	$(RASM) -l $*.asm > $*.lst

#
# Transformation rule: .obj into .out
#
.obj.out:
	$(RLINK) -m -o $*.out $*.obj > $*.map

#
# Object files
#
OBJECTS = forest_fire.obj input.obj output.obj grid.obj rules.obj

#
# Main target
#
forestfire.out:	$(OBJECTS)
	$(RLINK) -m -o forest_fire.out $(OBJECTS) > forest_fire.map


