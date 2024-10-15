#!/usr/bin/env python
# coding: utf-8

# # Managed Imports

# In[76]:


import numpy as np
from numpy.linalg import norm as norm2


# # Defined functions

# In[77]:


def SOSE(arr_x, assigned_x, arr_c):
    sose = 0

    for dex in range(len(arr_x)):
        sose += norm2(arr_x[dex] - arr_c[assigned_x[dex]])**2
    return sose

def assignToClusters(arr_x, assigned_x, arr_c):
    for x_dex in range(len(arr_x)):
        min_dex = 0
        min_val = norm2(arr_x[x_dex] - arr_c[min_dex])

        for cluster_dex in range(1, len(arr_c)):
            val = norm2(arr_x[x_dex] - arr_c[cluster_dex])

            if val < min_val:
                min_val = val
                min_dex = cluster_dex

        assigned_x[x_dex] = min_dex

    return assigned_x

def updateClusterCentres(arr_x, assigned_x, arr_c):
    avg_c = np.zeros(arr_c.shape, dtype=float)
    assign_count = np.zeros((arr_c.shape[0], 1))

    for x_dex in range(len(arr_x)):
        avg_c[assigned_x[x_dex]] += arr_x[x_dex]
        assign_count[assigned_x[x_dex]] += 1

    for c_dex in range(len(arr_c)):
        avg_c[c_dex] /= assign_count[c_dex]

    return avg_c


# # Dataset

# In[78]:


DATASET = np.array([
    [0.22, 0.33],
    [0.45, 0.76],
    [0.73, 0.39],
    [0.25, 0.35],
    [0.51, 0.69],
    [0.69, 0.42],
    [0.41, 0.49],
    [0.15, 0.29],
    [0.81, 0.32],
    [0.50, 0.88],
    [0.23, 0.31],
    [0.77, 0.30],
    [0.56, 0.75],
    [0.11, 0.38],
    [0.81, 0.33],
    [0.59, 0.77],
    [0.10, 0.89],
    [0.55, 0.09],
    [0.75, 0.35],
    [0.44, 0.55]
])


# # Initial cluster centre retrieval

# In[79]:


K = 3
DIM = 2
N = 20

assigned_x = np.zeros((N), dtype=int)

arr_centres = np.zeros((K, DIM))
for k in range(K):
    for dex in range(DIM):
        arr_centres[k][dex] = float(input())
# arr_centres = np.array([
#     [0.45, 0.55],
#     [0.70, 0.71],
#     [0.11, 0.67]
# ])


# # Initial SOSE

# In[80]:


assigned_x = assignToClusters(DATASET, assigned_x, arr_centres)
initial_sose = SOSE(DATASET, assigned_x, arr_centres)
print(f"{initial_sose:.4f}")


# # SOSE after cluster update

# In[81]:


arr_centres = updateClusterCentres(DATASET, assigned_x, arr_centres)
assigned_x = assignToClusters(DATASET, assigned_x, arr_centres)
first_iter_sose = SOSE(DATASET, assigned_x, arr_centres)
print(f"{first_iter_sose:.4f}")

