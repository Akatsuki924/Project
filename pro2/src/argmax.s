.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    bge x0 a1 Exit
    add t0 x0 x0 
    # counter

loop_start:
    bge t0 a1 loop_end # scan all elements of vector
    slli t2 t0 2
    add t2 t2 a0 # element address
    lw t2 0(t2)
    bne t0 x0 L1
    add t1 t2 x0 # first one just give the value
L1:
    bge t1 t2 loop_continue
    add t1 t2 x0 # replace the smaller one
    add t3 x0 t0 # store the index

loop_continue:
    addi t0 t0 1
    jal x0 loop_start 

Exit:
    addi a1 x0 7
    jal exit2

loop_end:
    add a0 x0 t3 # return the index
    ret