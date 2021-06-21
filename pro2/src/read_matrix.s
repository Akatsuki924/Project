.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -32
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw ra 28(sp)

    mv s0 a0
    mv s1 a1
    mv s2 a2
	
    # fopen
    mv a1 s0
    mv a2 x0
    jal ra fopen
    addi t0 x0 -1
    beq t0 a0 Exit50
    mv s4 a0

    # fread rows number
    mv a1 s4 # descripe number
    mv a2 s1
    addi a3 x0 4 # read the first two elements in text
    jal fread
    addi t0 x0 4
    bne a0 t0 Exit51

    # fread colomun number
    mv a1 s4 # descripe number
    mv a2 s2
    addi a3 x0 4 # read the first two elements in text
    jal fread
    addi t0 x0 4
    bne a0 t0 Exit51

    # malloc for matrix
    lw t1 0(s1)
    lw t2 0(s2)
    mul s5 t1 t2
    slli t0 s5 2 # bytes for malloc
    mv a0 t0
    jal malloc
    mv s6 a0 # matrix address

    # fread matrix
    mv a1 s4
    mv a2 s6
    slli a3 s5 2 # total bytes for matrix fread
    jal fread
    slli t0 s5 2
    bne a0 t0 Exit51

    #fclose
    mv a1 s4
    jal fclose
    bne x0 a0 Exit52
    jal x0 Epilogue

Exit50:
    addi a1 x0 50
    jal exit2

Exit51:
    addi a1 x0 51
    jal exit2

Exit52:
    addi a1 x0 52
    jal exit2
  

Epilogue:
    mv a0 s6
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw ra 28(sp)
    addi sp sp 32


    ret