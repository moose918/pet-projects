#include <iostream>
#include <chrono> /// Timer for algorithms
#include <fstream>

#include "BST.cpp"
#include "OS_BST.cpp"
#include "RandomListGen.cpp"

using namespace std;
using namespace chrono;

const int MAX_ITER_COUNT = 30;
const int MIN_SIZE = 16;
const int MAX_SIZE = 65536;
const int STEP_SIZE = 128;

const string OUTPUT_FILE_A = "resultsA.csv";
const string OUTPUT_FILE_B = "resultsB.csv";


void partA();
void partB();

long long destroyTree(BST &bst);
long long destroyOrderStatisticTree(OS_BST &bst);

int main(){
//    partA();
    partB();
}

void partA() {
    ofstream outputFile;
    vector<int> vecInputKeys;
    RandomListGen randListGen;

    vector<int> vecSizes;
    vector<long long> vecRuntimes = {0};
    vector<int> vecHeights = {0};
    vector<long long> vecDestroyTimes = {0};

    /**
     *  Insert Operations: part A : (ii), (iii) & (iv)
     */
    for (int currSize = MIN_SIZE; currSize <= MAX_SIZE; currSize += STEP_SIZE) {
        vecSizes.push_back(currSize);
        for (int iterCount = 0; iterCount < MAX_ITER_COUNT; ++iterCount) {
            BST T;
            vecInputKeys = randListGen.generateList(currSize);

            // Start the timer for insertion
            auto start = high_resolution_clock::now();

            for (auto key : vecInputKeys)
                treeInsert(T, key);

            // Stop the timer
            auto stop = high_resolution_clock::now();

            // Calculate the duration
            auto duration = duration_cast<microseconds>(stop - start);

            // Get the time taken to destroy the tree
            auto destroyTime = destroyTree(T);

            vecRuntimes.back() += duration.count();
            vecHeights.back() += T.treeHeight;
            vecDestroyTimes.back() += destroyTime;
        }

        // Calculates the average for the past iteration and leaves a placeholder for the sum of the next
        // iteration to be accumulated
        vecRuntimes.back() /= MAX_ITER_COUNT;
        vecRuntimes.push_back(0);

        vecHeights.back() /= MAX_ITER_COUNT;
        vecHeights.push_back(0);

        vecDestroyTimes.back() /= MAX_ITER_COUNT;
        vecDestroyTimes.push_back(0);
    }

    // Stores results in a csv file
    outputFile.open(OUTPUT_FILE_A);
    outputFile << "SIZE,AVG_HEIGHT,INSERT_RUNTIME,DESTROY_RUNTIME" << endl;
    for (int dex = 0; dex < vecSizes.size(); ++dex) {
        outputFile << vecSizes[dex] << "," << vecHeights[dex] << "," << vecRuntimes[dex] << "," << vecDestroyTimes[dex] << endl;
    }
    outputFile.close();
}

long long destroyTree(BST &bst) {
    // Start the timer
    auto start = high_resolution_clock::now();

    // The best way to destroy the tree is to constantly delete the root node
    // This guarantees O(1) time as opposed to potential O(logn) time
    while (bst.root != nullptr)
        treeDelete(bst, bst.root);

    // Stop the timer
    auto stop = high_resolution_clock::now();

    // Calculate the duration
    auto duration = duration_cast<microseconds>(stop - start);

    return duration.count();
}

void partB() {
    ofstream outputFile;
    vector<int> vecInputKeys;
    RandomListGen randListGen;

    vector<int> vecSizes;
    vector<long long> vecRuntimes = {0};
    vector<int> vecHeights = {0};
    vector<long long> vecDestroyTimes = {0};

    /**
     *  Insert Operations: part B : (ii), (iii) & (iv)
     */
    for (int currSize = MIN_SIZE; currSize <= MAX_SIZE; currSize += STEP_SIZE) {
        vecSizes.push_back(currSize);
        for (int iterCount = 0; iterCount < MAX_ITER_COUNT; ++iterCount) {
            OS_BST osBst;
            vecInputKeys = randListGen.generateList(currSize);

            // Start the timer for insertion
            auto start = high_resolution_clock::now();

            for (auto key : vecInputKeys)
                treeInsert(osBst, key);

            // Stop the timer
            auto stop = high_resolution_clock::now();

            // Calculate the duration
            auto duration = duration_cast<microseconds>(stop - start);

            // Get the time taken to destroy the tree
            auto destroyTime = destroyOrderStatisticTree(osBst);

            vecRuntimes.back() += duration.count();
            vecHeights.back() += osBst.treeHeight;
            vecDestroyTimes.back() += destroyTime;
        }
        // Calculates the average for the past iteration and leaves a placeholder for the sum of the next
        // iteration to be accumulated
        vecRuntimes.back() /= MAX_ITER_COUNT;
        vecRuntimes.push_back(0);

        vecHeights.back() /= MAX_ITER_COUNT;
        vecHeights.push_back(0);

        vecDestroyTimes.back() /= MAX_ITER_COUNT;
        vecDestroyTimes.push_back(0);
    }

    // Stores results in a csv file
    outputFile.open(OUTPUT_FILE_B);
    outputFile << "SIZE,AVG_HEIGHT,INSERT_RUNTIME,DESTROY_RUNTIME" << endl;
    for (int dex = 0; dex < vecSizes.size(); ++dex) {
        outputFile << vecSizes[dex] << "," << vecHeights[dex] << "," << vecRuntimes[dex] << "," << vecDestroyTimes[dex] << endl;
    }
    outputFile.close();
}

long long destroyOrderStatisticTree(OS_BST &bst) {
    // Start the timer
    auto start = high_resolution_clock::now();

    // The best way to destroy the tree is to constantly delete the root node
    // This guarantees O(1) time as opposed to potential O(logn) time
    while (bst.root != nullptr) {
        osTreeDelete(bst, bst.root);

    }

    // Stop the timer
    auto stop = high_resolution_clock::now();

    // Calculate the duration
    auto duration = duration_cast<microseconds>(stop - start);

    return duration.count();
}

