.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:

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

    mv s0 a0 # file name pointer
    mv s1 a1 # matrix pointer
    mv s2 a2 # row number
    mv s3 a3 # colomn number

    # fopen
    mv a1 s0
    addi a2 x0 1
    jal fopen
    addi t0 x0 -1
    beq a0 t0 Exit53
    mv s4 a0

    
    # malloc room for row and colomn
    addi a0 x0 8
    jal malloc
    mv s6 a0
    sw s2 0(s6)
    sw s3 4(s6)

    # fwrite row and colomn
    mv a1 s4
    mv a2 s6
    addi a3 x0 2
    addi a4 x0 4
    jal fwrite
    addi t0 x0 2
    bne t0 a0 Exit54
    # free malloc
    mv a0 s6
    jal free


    # fwrite total elements
    mul s5 s2 s3 # total elements
    mv a3 s5
    mv a1 s4
    mv a2 s1
    addi a4 x0 4
    jal fwrite
    bne s5 a0 Exit54

    # fclose
    mv a1 s4
    jal fclose
    bne a0 x0 Exit55
    jal x0 Epilogue

Exit53:
    addi a1 x0 53
    jal exit2

Exit54:
    addi a1 x0 54
    jal exit2

Exit55:
    addi a1 x0 55
    jal exit2


Epilogue:
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
