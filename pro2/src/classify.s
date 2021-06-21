.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1 <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

	# =====================================
    # LOAD MATRICES
    # =====================================
    # Arguments for read_matrix:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory
    addi sp sp -4
    sw ra 0(sp)

    #load address
    addi t0 x0 5
    bne a0 t0 Exit49 # arc correctness
    lw s0 4(a1) # m0 address
    lw s1 8(a1) # m1 address
    lw s2 12(a1) # input address
    lw s3 16(a1) # output address
    mv s6 a2 # write out signal

    #read input matrix
    addi a0 x0 8
    jal malloc
    mv s8 a0

    mv a0 s2
    mv a1 s8
    addi t0 s8 4
    mv a2 t0
    jal read_matrix
    mv s2 a0 # input pointer in memeory

    # read m0 matrix
    addi a0 x0 8
    jal malloc
    mv s9 a0

    mv a0 s0
    mv a1 s9
    addi t0 s9 4
    mv a2 t0
    jal read_matrix
    mv s0 a0 # m0 pointer in memeory

    # read m1 matrix
    addi a0 x0 8
    jal malloc
    mv s10 a0

    mv a0 s1
    mv a1 s10
    addi t0 s10 4
    mv a2 t0
    jal read_matrix
    mv s1 a0 # m1 pointer in memeory
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)

    # matmul Arguments:
    # 	a0 (int*)  is the pointer to the start of m0 
    #	a1 (int)   is the # of rows (height) of m0
    #	a2 (int)   is the # of columns (width) of m0
    #	a3 (int*)  is the pointer to the start of m1
    # 	a4 (int)   is the # of rows (height) of m1
    #	a5 (int)   is the # of columns (width) of m1
    #	a6 (int*)  is the pointer to the the start of d

    # malloc room for matmul result with m0
    lw t0 0(s9) # rows in m0
    lw t1 4(s8) # colomns in inputs
    mul a0 t0 t1
    slli a0 a0 2 # bytes for matmul result with m0
    jal malloc
    mv s4 a0 # matmul result pointer with m0

    # call matmul function
    mv a0 s0
    lw a1 0(s9) # rows in m0
    lw a2 4(s9) # colomns in m0
    mv a3 s2
    lw a4 0(s8) # rows in input
    lw a5 4(s8) # colomns in input
    mv a6 s4
    jal matmul

    # call Relu function
    # Arguments:
    # 	a0 (int*) is the pointer to the array
    #	a1 (int)  is the # of elements in the array
    mv a0 s4
    lw t0 0(s9) # rows in m0
    lw t1 4(s8)  # colomns in input
    mul a1 t0 t1
    jal relu

    # malloc room for matmul result with m1
    lw t0 0(s10) # rows in m1
    lw t1 4(s8) # colomns in input(equal situation)
    mul a0 t0 t1
    slli a0 a0 2
    jal malloc
    mv s5 a0 # matmul result pointer with m1

    # matmul Arguments:
    # 	a0 (int*)  is the pointer to the start of m0 
    #	a1 (int)   is the # of rows (height) of m0
    #	a2 (int)   is the # of columns (width) of m0
    #	a3 (int*)  is the pointer to the start of m1
    # 	a4 (int)   is the # of rows (height) of m1
    #	a5 (int)   is the # of columns (width) of m1
    #	a6 (int*)  is the pointer to the the start of d

    #call matmul funciton
    mv a0 s1
    lw a1 0(s10) # rows in m1
    lw a2 4(s10) # colomns in m1
    mv a3 s4
    lw a4 0(s9) # rows in m0
    lw a5 4(s8) # colomns in input
    mv a6 s5
    jal matmul 
    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is the pointer to the start of the matrix in memory
    #   a2 (int)   is the number of rows in the matrix
    #   a3 (int)   is the number of columns in the matrix
    mv a0 s3
    mv a1 s5
    lw a2 0(s10)
    lw a3 4(s8)
    jal write_matrix

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    # Arguments:
    #  	a0 (int*) is the pointer to the start of the vector
    #	a1 (int)  is the # of elements in the vector
    mv a0 s5
    lw t0 0(s10)
    lw t1 4(s8)
    mul a1 t0 t1
    jal argmax
    mv s7 a0

    # Print classification
    bne s6 x0 free_heap
    mv a1 s7
    jal print_int
    
    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char
    jal x0 free_heap

Exit49:
    addi a1 x0 49
    jal exit2

free_heap:
    mv a0 s0 # free m0 malloc
    jal free

    mv a0 s1 # free m1 malloc
    jal free

    mv a0 s2 # free input malloc
    jal free

    mv a0 s4 # free matmul result malloc(with m0)
    jal free 

    mv a0 s5 # free matmul result malloc(with m1)
    jal free

    mv a0 s8 # free input row/colomn malloc
    jal free

    mv a0 s9 # free m0 row/colomn malloc
    jal free

    mv a0 s10 # free m1 row/colomn malloc
    jal free

    # return classification result
    mv a0 s7

    lw ra 0(sp)
    addi sp sp 4
    ret