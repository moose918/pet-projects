#include <iostream>
#include <vector> /// After confirmation with Prof. Clint, vectors are allowed only for use as containers
                    //// As built-in arrays cannot be resized
#include <random> /// Necessary for populating the matrices with random values
#include <chrono> /// Timer for algorithms
#include <fstream> /// Recording results

using namespace std;
using namespace chrono;

// CONSTANTS, to be editet for he input size
const int MIN = 1;  // minimum value in cell
const int MAX = 100;    // maximum value value in cell
const int MIN_SIZE = int (pow(2, 2));   // minimum matrix size
const int MAX_SIZE = int (pow(2, 5));  // maximum matrix size
const int STEP_SIZE = int (pow(2, 3));  // step size for next iteration
const int REPEAT_COUNT = 3; // number to be averaged over
const string OUTPUT_FILE = "results.csv";

/* Cluster configurations
// CONSTANTS, to be editet for he input size
const int MIN = 1;  // minimum value in cell
const int MAX = 100;    // maximum value value in cell
const int MIN_SIZE = int (pow(2, 2));   // minimum matrix size
const int MAX_SIZE = int (pow(2, 10));  // maximum matrix size
const int STEP_SIZE = int (pow(2, 5));  // step size for next iteration
const int REPEAT_COUNT = 3; // number to be averaged over
const string OUTPUT_FILE = "results.csv";*/

const int ADD = 1;
const int SUBTRACT = -1;

/**
 * Class for generating random integers
 */
class RandomGen {
public:
    size_t randomGenerator(size_t min, size_t max) {
        std::mt19937 rng;
        rng.seed(std::random_device()());
        std::uniform_int_distribution<std::mt19937::result_type> dist(min, max);

        return dist(rng);
    }
} randomGen;

/**
 * Class for storing matrices and performing varioius multiplication techniques
 */
class MatrixHelper{
public:
    MatrixHelper(){};

    int size;
    vector<vector<int>> outputMatrixClassic, outputMatrixRecursive, outputStrassen, matrixA, matrixB;

    /**
     * Populates matrices with given input sizes
     * @param inSize
     */
    void generateMatrices(int inSize) {
        this->size = inSize;
        matrixA = vector<vector<int>> (inSize, vector<int> (inSize));
        matrixB = vector<vector<int>> (inSize, vector<int> (inSize));

        for (int rowDex = 0; rowDex < inSize; ++rowDex) {
            for (int colDex = 0; colDex < inSize; ++colDex) {
                matrixA[rowDex][colDex] = randomGen.randomGenerator(MIN, MAX);
                matrixB[rowDex][colDex] = randomGen.randomGenerator(MIN, MAX);
            }
        }
    }

    /**
     * Prints the output of a given matrix
     * Used for validation and observation
     * @param matrix
     */
    void printMatrix( vector<vector<int>> &matrix) {
        for (auto &row : matrix) {
            for (auto &elem : row) {
                cout << elem << "\t";
            }
            cout << endl;
        }
        cout << endl;
    }

    /**
     * Prints the factor matrices to be multiplied
     */
    void printInputMatrices() {
        cout << "A" << endl;
        printMatrix(matrixA);
        cout << "B" << endl;
        printMatrix(matrixB);
    }

    /**
     * Prints the product of the intput matrices using each individual algorithm
     */
    void printOutputMatrices() {
        cout << "Output of square-matrix-multiply" << endl;
        printMatrix(outputMatrixClassic);
        cout << "Output of square-matrix-multiply-recursive" << endl;
        printMatrix(outputMatrixRecursive);
        cout << "Output of strassen-multiplication" << endl;
        printMatrix(outputStrassen);
    }


    /**
     * Classic matrix multiplication
     * @return
     */
    auto squareMatrixMultipy() {
        outputMatrixClassic = vector<vector<int>> (size, vector<int> (size));

        auto start = high_resolution_clock::now();

        for (int row = 0; row < size; ++row) {
            for (int col = 0; col < size; ++col) {
                for (int dex = 0; dex < size; ++dex) {
                    outputMatrixClassic[row][col] += matrixA[row][dex] * matrixB[dex][col];
                }
            }
        }

        // Stop the timer
        auto stop = high_resolution_clock::now();

        // Calculate the duration
        auto duration = duration_cast<microseconds>(stop - start);

        return duration.count();
    }

    /**
     * Creates a padded matrix and copies over the element-wise positions to it
     * @param padSize
     * @param paddedMat
     * @param originalMat
     */
    static void copyToPaddedMatrix(int padSize, vector<vector<int>> &paddedMat, vector<vector<int>> &originalMat) {
        int originalSize = originalMat.size();
        int newSize = originalSize + padSize;

        paddedMat = vector<vector<int>> (newSize, vector<int> (newSize));

        for (int rowDex = 0; rowDex < originalSize; ++rowDex) {
            for (int colDex = 0; colDex < originalSize; ++colDex) {
                paddedMat[rowDex][colDex] = originalMat[rowDex][colDex];
            }
        }
    }

    /**
     * Copies the elements of the padded matrix to the original one
     * @param paddedMat
     * @param originalMat
     */
    static void copyToUnpaddedMatrix(vector<vector<int>> &paddedMat, vector<vector<int>> &originalMat) {
        int originalSize = originalMat.size();

        for (int rowDex = 0; rowDex < originalSize; ++rowDex) {
            for (int colDex = 0; colDex < originalSize; ++colDex) {
                originalMat[rowDex][colDex] = paddedMat[rowDex][colDex];
            }
        }
    }

    /**
     * Performs the Recursive form of matrix multiplication
     * Padding is done to allow the multiplication of any square-sized matrix
     * that is not a multiple of 2 to be computed
     */
    auto squareMatrixMultiplyRecursive() {
        int padSize, matSize, startDex, endDex, trueEndDex;
        vector<vector<int>> outputMat, matA, matB;

        int k = 0;
        while (pow(2, k) < size) {
            ++k;
        }

        matSize = int (pow(2, k));

        padSize = matSize - size;

        outputMat = vector<vector<int>> (matSize, vector<int> (matSize));
        outputMatrixRecursive = vector<vector<int>> (size, vector<int> (size));

        copyToPaddedMatrix(padSize, matA, matrixA);
        copyToPaddedMatrix(padSize, matB, matrixB);

        auto start = high_resolution_clock::now();

        outputMat = squareMatrixMultiplyRecursive(matA, matB);

        // Stop the timer
        auto stop = high_resolution_clock::now();

        // Calculate the duration
        auto duration = duration_cast<microseconds>(stop - start);

        copyToUnpaddedMatrix(outputMat, outputMatrixRecursive);

        return duration.count();
    }

    /**
     * Performs the strassen multiplication
     * @return
     */
    auto strassenMultiplication() {
        int padSize, matSize, startDex, endDex, trueEndDex;
        vector<vector<int>> outputMat, matA, matB;

        int k = 0;
        while (pow(2, k) < size) {
            ++k;
        }

        matSize = int (pow(2, k));

        padSize = matSize - size;

        outputMat = vector<vector<int>> (matSize, vector<int> (matSize));
        outputStrassen = vector<vector<int>> (size, vector<int> (size));

        copyToPaddedMatrix(padSize, matA, matrixA);
        copyToPaddedMatrix(padSize, matB, matrixB);

        auto start = high_resolution_clock::now();

        outputMat = stassenMultiplicaiton(matA, matB);

        // Stop the timer
        auto stop = high_resolution_clock::now();

        // Calculate the duration
        auto duration = duration_cast<microseconds>(stop - start);

        copyToUnpaddedMatrix(outputMat, outputStrassen);

        return duration.count();
    }
    /**
     * Creates a partition of the matrix given its indicies
     * @param matOut
     * @param startRowDex
     * @param endRowDex
     * @param startColDex
     * @param endColDex
     * @return
     */
    static vector<vector<int>> copyMatrixPartition(vector<vector<int>> &matOut, int startRowDex, int endRowDex, int startColDex, int endColDex) {
        int partSize = endRowDex - startRowDex + 1;
        vector<vector<int>> matPart = vector<vector<int>> (partSize, vector<int> (partSize));


        for (int rowDex = startRowDex; rowDex <= endRowDex; ++rowDex) {
            for (int colDex = startColDex; colDex <= endColDex; ++colDex) {
                matPart[rowDex - startRowDex][colDex - startColDex] = matOut[rowDex][colDex];
            }
        }

        return matPart;
    }

    /**
     * Adds the partitions together to an output matrix
     * @param outputMatrix
     * @param factorA
     * @param factorB
     * @param startRowDex
     * @param endRowDex
     * @param startColDex
     * @param endColDex
     * @param intOperator
     */
    static void addSubtractFromPartition(vector<vector<int>> &outputMatrix, vector<vector<int>> factorA, vector<vector<int>> factorB,
                                         int startRowDex, int endRowDex, int startColDex, int endColDex, int intOperator) {

        for (int rowDex = startRowDex; rowDex <= endRowDex; ++rowDex) {
            for (int colDex = startColDex; colDex <= endColDex; ++colDex) {
                if (intOperator == ADD)
                    outputMatrix[rowDex][colDex] += factorA[rowDex - startRowDex][colDex - startColDex] + factorB[rowDex - startRowDex][colDex - startColDex];
                else
                    outputMatrix[rowDex][colDex] += factorA[rowDex - startRowDex][colDex - startColDex] - factorB[rowDex - startRowDex][colDex - startColDex];
            }
        }
    }

    /**
     * The recursive implementation of matrix multiplication
     * @param matA
     * @param matB
     * @return
     */
    vector<vector<int>> squareMatrixMultiplyRecursive(vector<vector<int>> &matA, vector<vector<int>> &matB) {
        int currSize = matA.size();
        int halfSize = int (floor(currSize / 2));

        vector<vector<int>> outMat = vector<vector<int>> (currSize, vector<int> (currSize));

        if (currSize == 1) {
            outMat[0][0] = matA[0][0] * matB[0][0];
            return outMat;
        }

        int startRowDex = 0;
        int startColDex = 0;
        int midRowDex = halfSize - 1;
        int midColDex = halfSize - 1;
        int endRowDex = currSize - 1;
        int endColDex = currSize - 1;

        auto A11 = copyMatrixPartition(matA, startRowDex, midRowDex, startColDex, midColDex);
        auto A12 = copyMatrixPartition(matA, startRowDex, midRowDex, midColDex + 1, endColDex);
        auto A21 = copyMatrixPartition(matA, midRowDex + 1, endRowDex, startColDex, midColDex);
        auto A22 = copyMatrixPartition(matA, midRowDex + 1, endRowDex, midColDex + 1, endColDex);

        auto B11 = copyMatrixPartition(matB, startRowDex, midRowDex, startColDex, midColDex);
        auto B12 = copyMatrixPartition(matB, startRowDex, midRowDex, midColDex + 1, endColDex);
        auto B21 = copyMatrixPartition(matB, midRowDex + 1, endRowDex, startColDex, midColDex);
        auto B22 = copyMatrixPartition(matB, midRowDex + 1, endRowDex, midColDex + 1, endColDex);

        addSubtractFromPartition(outMat, squareMatrixMultiplyRecursive(A11, B11),
                                 squareMatrixMultiplyRecursive(A12, B21),
                                 startRowDex, midRowDex, startColDex, midColDex,
                                 ADD);
        addSubtractFromPartition(outMat, squareMatrixMultiplyRecursive(A11, B12),
                                 squareMatrixMultiplyRecursive(A12, B22),
                                 startRowDex, midRowDex, midColDex + 1, endColDex,
                                 ADD);
        addSubtractFromPartition(outMat, squareMatrixMultiplyRecursive(A21, B11),
                                 squareMatrixMultiplyRecursive(A22, B21),
                                 midRowDex + 1, endRowDex, startColDex, midColDex,
                                 ADD);
        addSubtractFromPartition(outMat, squareMatrixMultiplyRecursive(A21, B12),
                                 squareMatrixMultiplyRecursive(A22, B22),
                                 midRowDex + 1, endRowDex, midColDex + 1, endColDex,
                                 ADD);

        return outMat;
    }

    static void addSubtractPartitions(vector<vector<int>> &outMat, int partSize,
                               vector<vector<int>> &factorA, int aStartRow, int aStartCol,
                               vector<vector<int>> &factorB, int bStartRow, int bStartCol,
                               int intOperator) {

        for (int rowDex = 0; rowDex < partSize; ++rowDex) {
            for (int colDex = 0; colDex < partSize; ++colDex) {
                if (intOperator == ADD)
                    outMat[rowDex][colDex] = factorA[aStartRow + rowDex ][aStartCol + colDex] + factorB[bStartRow + rowDex][bStartCol + colDex];
                else
                    outMat[rowDex][colDex] = factorA[aStartRow + rowDex][aStartCol + colDex] - factorB[bStartRow + rowDex][bStartCol + colDex];
            }
        }
    }

    /**
     * The strassen implementation of matrix multiplication
     * @param matA
     * @param matB
     * @return
     */
    vector<vector<int>> stassenMultiplicaiton(vector<vector<int>> &matA, vector<vector<int>> &matB) {
        int currSize = matA.size();
        int halfSize = int (floor(currSize / 2));

        if (currSize == 1)
            return {{ matA[0][0] * matB[0][0] }};

        vector<vector<int>> outMat = vector<vector<int>> (currSize, vector<int> (currSize));

        vector<vector<int>> S1 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S2 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S3 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S4 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S5 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S6 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S7 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S8 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S9 = vector<vector<int>> (halfSize, vector<int> (halfSize));
        vector<vector<int>> S10 = vector<vector<int>> (halfSize, vector<int> (halfSize));

        int startRowDex = 0;
        int startColDex = 0;
        int midRowDex = halfSize - 1;
        int midColDex = halfSize - 1;
        int endRowDex = currSize - 1;
        int endColDex = currSize - 1;


        addSubtractPartitions(S1, halfSize, matB, startRowDex, midColDex + 1, matB, midRowDex + 1, midColDex + 1, SUBTRACT);
        addSubtractPartitions(S2, halfSize, matA, startRowDex, startColDex, matA, startRowDex, midColDex + 1, ADD);
        addSubtractPartitions(S3, halfSize, matA, midRowDex + 1, startColDex, matA, midRowDex + 1, midColDex + 1, ADD);
        addSubtractPartitions(S4, halfSize, matB, midRowDex + 1, startColDex, matB, startRowDex, startColDex, SUBTRACT);
        addSubtractPartitions(S5, halfSize, matA, startRowDex, startColDex, matA, midRowDex + 1, midColDex + 1, ADD);
        addSubtractPartitions(S6, halfSize, matB, startRowDex, startColDex, matB, midRowDex + 1, midColDex + 1, ADD);
        addSubtractPartitions(S7, halfSize, matA, startRowDex, midColDex + 1, matA, midRowDex + 1, midColDex + 1, SUBTRACT);
        addSubtractPartitions(S8, halfSize, matB, midRowDex + 1, startColDex, matB, midRowDex + 1, midColDex + 1, ADD);
        addSubtractPartitions(S9, halfSize, matA, startRowDex, startColDex, matA, midRowDex + 1, startColDex, SUBTRACT);
        addSubtractPartitions(S10, halfSize, matB, startRowDex, startColDex, matB, startRowDex, midColDex + 1, ADD);

        auto A11 = copyMatrixPartition(matA, startRowDex, midRowDex, startColDex, midColDex);
        auto A22 = copyMatrixPartition(matA, midRowDex + 1, endRowDex, midColDex + 1, endColDex);

        auto B11 = copyMatrixPartition(matB, startRowDex, midRowDex, startColDex, midColDex);
        auto B22 = copyMatrixPartition(matB, midRowDex + 1, endRowDex, midColDex + 1, endColDex);

        // C11 = P5 + (P4 - P2) + P6 = P5 + P6 + P4 - P2... Matrix addition is commutative
        addSubtractFromPartition(outMat, stassenMultiplicaiton(S5, S6), stassenMultiplicaiton(S7, S8),
                                 startRowDex, midRowDex, startColDex, midColDex, ADD);
        addSubtractFromPartition(outMat, stassenMultiplicaiton(A22, S4), stassenMultiplicaiton(S2, B22),
                                 startRowDex, midRowDex, startColDex, midColDex, SUBTRACT);

        addSubtractFromPartition(outMat, stassenMultiplicaiton(A11, S1), stassenMultiplicaiton(S2, B22),
                                 startRowDex, midRowDex, midColDex + 1, endColDex, ADD);

        addSubtractFromPartition(outMat, stassenMultiplicaiton(S3, B11), stassenMultiplicaiton(A22, S4),
                                 midRowDex + 1, endRowDex, startColDex, midColDex, ADD);

        // C22 = P5 + P1 - P3 - P7 = (P5 - P3) + (P1 - P7)
        addSubtractFromPartition(outMat, stassenMultiplicaiton(S5, S6), stassenMultiplicaiton(S3, B11),
                                 midRowDex + 1, endRowDex, midColDex + 1, endColDex, SUBTRACT);
        addSubtractFromPartition(outMat, stassenMultiplicaiton(A11, S1), stassenMultiplicaiton(S9, S10),
                                 midRowDex + 1, endRowDex, midColDex + 1, endColDex, SUBTRACT);

        return outMat;
    }
private:
};

int main() {
    ofstream  outputFile;
    vector<vector<int>> matrixA, matrixB;
    MatrixHelper matHelper;

    long long arrRuntimes[3];

    outputFile.open(OUTPUT_FILE, ios::app);

    outputFile << "SIZE,CLASSIC,RECURSIVE,STRASSEN" << "\n";

    outputFile.close();

    for (int inputSize = MIN_SIZE; inputSize <= MAX_SIZE; inputSize += STEP_SIZE ) {
        outputFile.open(OUTPUT_FILE, ios::app);

        cout << "Input Size: " << inputSize << endl;
        matHelper.generateMatrices(inputSize);

        for (long long &v : arrRuntimes)
            v = 0;

        for (int repeatCount = 0; repeatCount < REPEAT_COUNT; ++repeatCount) {
            //    matHelper.printInputMatrices();
            arrRuntimes[0] += matHelper.squareMatrixMultipy();
            arrRuntimes[1] += matHelper.squareMatrixMultiplyRecursive();
            arrRuntimes[2] += matHelper.strassenMultiplication();
            //    matHelper.printOutputMatrices();
        }

        for (long long &v : arrRuntimes)
            v /= REPEAT_COUNT;

        outputFile << inputSize << "," << arrRuntimes[0] << "," << arrRuntimes[1] << "," << arrRuntimes[2] << "\n";

        outputFile.close();
    }


    return 0;
}
