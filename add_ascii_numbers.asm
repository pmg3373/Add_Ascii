# File:		add_ascii_numbers.asm
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#		<<Patrick Godard>>
#
# Updates:
#		3/2004	M. Reek, named constants
#		10/2007 W. Carithers, alignment
#		09/2009 W. Carithers, separate assembly
#
# Description:	Add two ASCII numbers and store the result in ASCII.
#
# Arguments:	a0: address of parameter block.  The block consists of
#		four words that contain (in this order):
#
#			address of first input string
#			address of second input string
#			address where result should be stored
#			length of the strings and result buffer
#
#		(There is actually other data after this in the
#		parameter block, but it is not relevant to this routine.)
#
# Returns:	The result of the addition, in the buffer specified by
#		the parameter block.
#

	.globl	add_ascii_numbers

add_ascii_numbers:
A_FRAMESIZE = 40

#
# Save registers ra and s0 - s7 on the stack.
#
	addi 	$sp, $sp, -A_FRAMESIZE
	sw 	$ra, -4+A_FRAMESIZE($sp)
	sw 	$s7, 28($sp)
	sw 	$s6, 24($sp)
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)
	
# ##### BEGIN STUDENT CODE BLOCK 1 #####

	li	$t0, 0		#String 1
	li	$t1, 0		#String 2
	li	$t2, 0		#Output String
	li	$t3, 0		#String Size
	li	$t4, 0		#String 1 Byte and result
	li	$t5, 0		#String 2 Byte
	li	$t6, 0		#Carry Bit
	li	$t7, 0		#Math Bit
	li	$t8, 0		#loop counter

	la	$t0, 0($a0)
	lw	$t0, 0($t0)
	la	$t1, 4($a0)
	lw	$t1, 0($t1)
	la	$t2, 8($a0)
	lw	$t2, 0($t2)
	la	$t3, 12($a0)

# Update All Addresses to point to the end of the string

	lw	$t3, 0($t3)
	
#decrement the number of chars by one during offset math
#need to move the address for each char after 1
	li	$t7, 1
	sub $t3, $t3, $t7
	
	add	$t0, $t0, $t3
	add	$t1, $t1, $t3
	add	$t2, $t2, $t3
	
	add $t3, $t3, $t7

add_ascii_numbers_loop_begin:
#load the ascii chars
	lb	$t4, 0($t0)
	lb	$t5, 0($t1)
	
#do ascii addition adjustment pre add to prevent overflow
	li	$t7, 48
	sub	$t4, $t4, $t7
	
	add 	$t4, $t4, $t5
	add		$t4, $t4, $t6	#need to add carry bit
	
#check if we need to carry a 1 over
	slti	$t7, $t4, 58
	beq	$t7, $zero, add_ascii_numbers_gt_ascii

#clear carry bit and jump over the carry math
	li 	$t6, 0
	j 	add_ascii_numbers_gt_end_if

add_ascii_numbers_gt_ascii:
#carry bit math
	li	$t7, 10
	sub	$t4, $t4, $t7
	li	$t6, 1
	
add_ascii_numbers_gt_end_if:
#save and loop inc
	sb	$t4, 0($t2)
	addi	$t8, 1
	beq	$t8, $t3, add_ascii_numbers_loop_end

#move addresses back 1 byte
	li	$t7, 1
	sub	$t0, $t0, $t7
	sub	$t1, $t1, $t7
	sub	$t2, $t2, $t7
	
	j	add_ascii_numbers_loop_begin
	
add_ascii_numbers_loop_end:


# ###### END STUDENT CODE BLOCK 1 ######

#
# Restore registers ra and s0 - s7 from the stack.
#
	lw 	$ra, -4+A_FRAMESIZE($sp)
	lw 	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw 	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, A_FRAMESIZE

	jr	$ra			# Return to the caller.
