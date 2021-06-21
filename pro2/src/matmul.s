.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    bge x0 a1 Exit2
    bge x0 a2 Exit2
    bge x0 a4 Exit3
    bge x0 a5 Exit3
    bne a2 a4 Exit4


    # Prologue
    addi sp sp -44
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw ra 40(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
    mv s3 a3
    mv s4 a4
    mv s5 a5
    mv s6 a6
    mv s7 x0
    mv s9 x0

outer_loop_start:
    bge s7 s1 outer_loop_end
    mv s8 x0
    jal x0 inner_loop_start
    

inner_loop_start:
    bge s8 s5 inner_loop_end
    mul t0 s7 s2
    slli t0 t0 2
    add t0 s0 t0 #left v0 address
    slli t1 s8 2
    add t1 s3 t1 # right v1 address
    mv a0 t0
    mv a1 t1
    mv a2 s2
    addi a3 x0 1
    mv a4 s5
    jal ra dot
    slli t3 s9 2
    add t3 s6 t3 # element address in d
    sw a0 0(t3)
    addi s8 s8 1
    addi s9 s9 1
    jal x0 inner_loop_start

Exit2:
    addi a1 x0 2
    jal exit2

Exit3:
    addi a1 x0 3
    jal exit2

Exit4:
    addi a1 x0 4
    jal exit2

inner_loop_end:
    addi s7 s7 1
    jal x0 outer_loop_start

outer_loop_end:
    # Epilogue

    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw ra 40(sp)
    addi sp sp 44
    
    ret