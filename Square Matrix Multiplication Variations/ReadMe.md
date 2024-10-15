# Performance Analysis Square Matrix Multiplication

## Description
This assignment implements three algorithms for square matrix multiplication:
1. **Regular Square Matrix Multiplication**: The standard method for multiplying matrices. []()
2. **Recursive Square Matrix Multiplication**: A divide-and-conquer approach that recursively halves and multiplies the corresponding halves of the matrix. More on recursive matrix multiplication can be found [here.](GeeksforGeeks article on Recursive Matrix Multiplication)
3. **Strassen's Method**: An advanced algorithm that reduces the multiplication operations needed, improving efficiency for large matrices. More on the standard and Strassen's method can be found [here.](https://www.tutorialspoint.com/data_structures_algorithms/strassens_matrix_multiplication_algorithm.htm)

Additionally, padding is added to accommodate odd-sized matrices and those that are not a power of 2.

A comprehensive analysis of the experiment can be found in the `results.pdf` file and `writeup` folder.

## Key Features
- Implementation of three different matrix multiplication algorithms.
- Padding for odd-sized matrices and matrices that are not powers of 2.
- Detailed empirical analysis of algorithm performance across various matrix dimensions.

## Installation
To compile and run the project, ensure you have a C++ compiler installed. Use the following command:

```bash
g++ main.cpp -o ./cmake-build-debug/matrix_multiplication
./cmake-build-debug/matrix_multiplication
```

## Usage
To configure properties for evaluation (min/max values, matrix sizes, iteration counts), edit the top line of the `main.cpp` file.

### Experimentation Details
The experimentation involved a range of matrix dimensions spanning from:
- 4x4 \(2^2\) to 516x516 (approximately \(2^{9.011}\) )

This range included increments of 32 \(2^5\), resulting in 16 different matrix sizes to enable a detailed assessment of algorithm performance across various dimensions.

## Technologies Used
- C++
- Python (notebook and graph generation)

## Authors
- Musa Gumpu