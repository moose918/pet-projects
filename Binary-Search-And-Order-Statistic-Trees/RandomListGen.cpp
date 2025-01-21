#include <random> /// Necessary for populating the matrices with random values
#include <chrono> /// Timer for algorithms
#include <vector>
#include <algorithm>
#include <cstdlib> // Required for std::rand() and std::srand()

const int MIN = 1;
const int MAX = 100;

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

class RandomListGen {
public:
    static std::vector<int> generateList(int size) {
        std::vector<int> vecKeys(size);

        for (int dex = 0; dex < size; ++dex) {
            vecKeys[dex] = randomGen.randomGenerator(MIN, MAX);
        }
        std::random_shuffle(vecKeys.begin(), vecKeys.end());
        return vecKeys;
    }
};