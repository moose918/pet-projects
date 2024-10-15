#!/bin/bash
#SBATCH -J matmul-app          # Job name
#SBATCH -o /home-mscluster/mgumpu/matmul-eval/output.log          # Output file for job's stdout
#SBATCH -e /home-mscluster/mgumpu/matmul-eval/error.log           # Output file for job's stderr
#SBATCH -n 1                   # Number of tasks (processes)
#SBATCH -c 12                   # Number of CPU cores per task
#SBATCH -t 16:00:00            # Max runtime (hh:mm:ss)

## run on cluster due to size
#g++ /home-mscluster/mgumpu/matmul-eval/main.cpp -o /home-mscluster/mgumpu/matmul-eval/main -std=c++14   # Compile C++ program
#/home-mscluster/mgumpu/matmul-eval/main                       # Execute compiled program

g++ main.cpp -o ./cmake-build-debug/main -std=c++14   # Compile C++ program
./cmake-build-debug/main