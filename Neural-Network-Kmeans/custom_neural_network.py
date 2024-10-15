#!/usr/bin/env python
# coding: utf-8

# # Handle imports

# In[5]:


import numpy as np
import math as m


# # Initialize functions

# In[6]:


'''
    Debugging
'''
def print_params(a, b, c):
    for line in a:
        print(line)
    print()
    for line in b:
        print(line)
    print()
    for line in c:
        print(line)
    
'''
    Returns an np array from the given array
'''
def gen_array(arr):
    return np.array(arr, dtype=float)

'''
    Returns an np array of ones
'''
def gen_ones(r, c):
    return np.ones((r, c), dtype=float)
'''
    Returns an np array of zeroes
'''
def gen_zeroes(r, c):
    return np.zeros((r, c), dtype=float)

'''
    Activation function
'''
def sigmoid(z):
    return 1/(1+m.e**(-z))

def sigmoid_prime(z):
    y = sigmoid(z)
    return y-y**2

'''
    Calculates the activation values at each node
'''
def feedforward(x, weights, biases):
    a_values = [x]
    for l_dex in range(1, len(weights)):
        a_curr = sigmoid(np.matmul(a_values[l_dex-1], weights[l_dex]) + biases[l_dex])
        a_values.append(a_curr)
        
    return a_values

'''
    The SOSE loss function
'''
def calc_loss(y, t):
    return 0.5 * np.sum((y-t)**2)

'''
    Calculates the delta values at each node
'''
def calc_deltas(t, a, weights, biases):
    ETA = 0.1
    delta_vals = []
    
    # handle the outer layer, (y - t)a(1-a)
    delta_curr = np.multiply(np.multiply((a[-1] - t), a[-1]), 1-a[-1])
    delta_vals.append(delta_curr)
    
    # now for the nodes in the inner layers
    # figured that one can use matrix multiplication to get the sum of products to the next layer
    for l_dex in range(len(weights)-1, 1, -1):    
        delta_curr = np.multiply(np.multiply(np.matmul(delta_curr, np.transpose(weights[l_dex])), a[l_dex-1]), 1-a[l_dex-1])
        delta_vals.append(delta_curr)
    
    # deltas are calculated from the back layers to the front, so this array needs to be reversed
    # in order for it to match the activation value array
    delta_vals.append([])
    delta_vals.reverse()
    return delta_vals

'''
    Performs the weight and bias updates
'''
def backpropagation(t, a, weights, biases):
    ETA = 0.1
    
    deltas = calc_deltas(t, a, weights, biases)
    
    # also figured that one can use matrix multiplication to simplify the process
    # would like to determine a simpler method to reshape the array as transposing does not give the required (n, 1) shape
    for l_dex in range(1, len(weights)):
        weights[l_dex] -= ETA * np.multiply(np.reshape(np.array(a[l_dex-1]), (a[l_dex-1].size, 1)), deltas[l_dex])
            
        biases[l_dex] -= ETA*deltas[l_dex]
      
    return weights, biases


# # Initialize the NN

# In[7]:


NUM_INPUT = 4
NUM_HIDDEN = 6
NUM_OUTPUT = 3

W1 = gen_ones(NUM_INPUT, NUM_HIDDEN)
W2 = gen_ones(NUM_HIDDEN, NUM_OUTPUT)
weights = [[], W1, W2]

b1 = gen_ones(1, NUM_HIDDEN)
b2 = gen_ones(1, NUM_OUTPUT)
biases = [[], b1, b2]

x = gen_zeroes(1, NUM_INPUT)


# # Retrieve input

# In[8]:


line = []

for count in range(NUM_INPUT + NUM_OUTPUT):
    val = float(input())
    line.append(val)

x = gen_array(line[:NUM_INPUT])
t = gen_array(line[NUM_INPUT:NUM_INPUT + NUM_OUTPUT])


# In[9]:


# print(x)
# print(t)


# # Begin feedforward step

# In[10]:


a = feedforward(x, weights, biases)


# In[11]:


# print_params(a, weights, biases)


# # Begin 1 iter of backpropagation

# In[12]:


def printout(a, weights, biases):
    for line in a:
        print(line)
    print()
    for layer in weights:
        print(layer)
    print()
    for layer in biases:
        print(layer)

weights_new, biases_new = backpropagation(t, a, weights, biases)


# # Calculate activation values of updated NN

# In[13]:


a_new = feedforward(x, weights_new, biases_new)


# In[14]:


# printout(weights, biases, a)


# In[15]:


# printout(weights_new, biases_new, a_new)


# # Calculate and print old and new Loss outputs

# In[16]:


L = calc_loss(a[-1], t)
L_new = calc_loss(a_new[-1], t)
print(f"{L:.4f}\n{L_new:.4f}")


# In[ ]:




