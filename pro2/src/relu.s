.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    bge x0 a1 Exit8
    addi t0 x0 0 # counter

loop_start:
    bge t0 a1 loop_end
    slli t2 t0 2
    add t2 t2 a0 # 
    lw t3 0(t2)
    bge t3 x0 loop_continue
    sw x0 0(t2) #

loop_continue:
    addi t0 t0 1
    jal x0 loop_start

Exit8:
    addi a0 x0 8
    jal exit2

loop_end:

	ret
