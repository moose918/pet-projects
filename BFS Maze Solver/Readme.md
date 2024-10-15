Here's a `README.md` file for the **BFS Maze** project:

---

# BFS Maze Solver

## Description
This project implements the Breadth-First Search (BFS) algorithm to solve mazes of varying complexity. It takes a maze as input, and if solvable, the BFS algorithm will find the shortest path from the starting point to the goal.

## Key Features
- **Maze Solver**: Implements the BFS algorithm with a queue to solve any maze with a solvable path.
- **Shortest Path**: The algorithm guarantees finding the shortest path in terms of number of steps.
- **Input Flexibility**: Accepts user-provided mazes in text file format.
- **Customizable**: Allows users to create their own maze input files.

## Installation Steps
1. To clean and build the project, run:
   ```bash
   make clean
   make
   ```

## Usage Instructions
1. You may use the sample input files from the `bfs-sampleio` folder or create your own maze file.
2. Ensure the maze file is in the same root directory and that the `makefile` is updated to include the new maze file for compilation.
3. To run the program with a custom maze, execute:
   ```bash
   g++ main.o -o output && ./output < <<mazeName.txt>>
   ```

## Technologies Used
- **C++**: The project is implemented entirely in C++.

---
