# Performance Analysis of Randomly Built Binary Search Trees

## Brief Description
This project investigates the expected height of randomly built binary search trees (BST) and analyzes the time complexities associated with the insertion and deletion of nodes. The project comprises two main parts: 
1. Evaluating the claim regarding the expected height of randomly built binary search trees and conducting experiments to measure the time taken for tree construction and destruction.
2. Implementing order-statistic trees using binary search trees augmented with size attributes, including coding the essential operations and explaining necessary algorithm modifications.

## Key Features
- **Tree-Insert Algorithm**: Efficiently inserts keys into the binary search tree while maintaining BST properties.
- **Tree-Delete Algorithm**: Removes nodes from the binary search tree while ensuring the tree remains valid.
- **Height Measurement**: Calculates and plots the average height of randomly built BSTs for varying sizes of `n`.
- **Performance Analysis**: Records and graphs the time taken to build and destroy binary search trees.
- **Order-Statistic Tree Implementation**: Supports operations on order-statistic trees, including OS-Search and OS-rank, while maintaining size attributes in nodes.
- **Visual Graphs**: Provides graphical representations of the height and performance metrics derived from experimental data.

## Installation Steps
1. Ensure you have a C++ compiler (g++) installed on your system.
2. Clone the repository and navigate to the project directory.
3. Compile the project using the following command:
    ```bash
    g++ main.cpp -o ./cmake-build-debug/main.out
    ```

## Usage Instructions
1. After compiling the code, run the executable:
    ```bash
    ./cmake-build-debug/main.out
    ```
2. You can modify the range of nodes, step sizes, and iterations in the source code to experiment with different tree sizes. After making any changes, remember to recompile the code using the command above before running it again.

## Technologies Used
- **C++**: For implementing the algorithms and performing experiments.
- **Python**: For plotting graphs of the height and performance analysis.
- **LaTeX**: For documentation, pseudocode, and explanations.

## Links for additional reading:
  - [Binary Search Tree (BST) Data Structure](https://www.geeksforgeeks.org/binary-search-tree-data-structure/)
  - [Order Statistics in BST](https://www.geeksforgeeks.org/find-k-th-smallest-element-in-bst-order-statistics-in-bst/)
  
---
