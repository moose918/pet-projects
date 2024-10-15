# Neural Network & K-means Model

## Description
This project implements two machine learning models from scratch in Python: a **Neural Network** and a **K-means Clustering** model. The neural network includes fully customizable forward and backpropagation mechanisms, with adjustable weights and layers. It uses sigmoid activation in the hidden layer and softmax for output. The K-means model clusters data points and evaluates the quality of clusters using the Sum of Squared Errors (SOSE) method.

## Key Features
- **Custom Neural Network**:
  - Forward and backpropagation implemented from scratch.
  - Adjustable number of layers, nodes, and weights.
  - Sigmoid activation for hidden layers and softmax for the output layer.
  - Supports multi-class classification.
  
- **K-means Clustering**:
  - Implements the K-means algorithm from scratch.
  - Cluster assignments based on nearest centroid calculation.
  - Uses Sum of Squared Errors (SOSE) to evaluate and adjust cluster centers.
  - Capable of clustering data into multiple clusters based on user-defined `k` values.

## Installation and Usage Instructions
1. To run the **Neural Network**:
   ```bash
   python custom_neural_network.py
   ```

2. To run the **K-means Model**:
   ```bash
   python k_means_model.py
   ```

3. You can modify the model parameters (such as the number of layers or the number of clusters) in the respective files. Ensure that the parameters are of the correct dimensions when making adjustments.

## Technologies Used
- **Python**: Core programming language for the neural network and K-means implementation.

## Additional Information
- Feel free to experiment with different datasets and parameters to test the model.

---