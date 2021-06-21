.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "tests/inputs/test_read_matrix/test_input.bin"

.text
main:
    # Read matrix into memory
    addi a0 x0 8
    jal malloc
    mv a1 a0
    mv s1 a0
    addi a2 a0 4
    mv s2 a2
    la a0 file_path
    jal ra read_matrix
    mv s3 a0


    # Print out elements of matrix
    mv a0 s3
    lw a1 0(s1)
    lw a2 0(s2)
    jal print_int_array

    # Terminate the program
    mv a0 s1
    jal free
    mv a0 s3
    jal free
    jal exit