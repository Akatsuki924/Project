.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    bge x0 a2 Exit5
    bge x0 a3 Exit6
    bge x0 a4 Exit6
    add t0 x0 x0
    add t4 x0 x0

loop_start:
    bge t0 a2 loop_end
    slli t1 t0 2
    mul t2 t1 a3
    mul t3 t1 a4
    add t2 t2 a0 # address element in v0
    add t3 t3 a1 # address element in v1
    lw t2 0(t2)
    lw t3 0(t3)
    mul t5 t2 t3
    add t4 t5 t4
    addi t0 t0 1
    jal x0 loop_start

Exit5:
    addi a1 x0 5
    jal exit2

Exit6:
    addi a1 x0 6
    jal exit2

loop_end:
    add a0 t4 x0
    ret