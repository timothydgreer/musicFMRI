#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 25 14:12:28 2019

@author: greert
"""

from sklearn import linear_model
import csv
import pandas as pd
from heapq import nlargest
from sklearn import preprocessing
import numpy as np
import math
import matplotlib.pyplot as plt


standardize = False

#1000000

#ij is the song
#    1. Emotion - happy song
#    2. Enjoyment - happy song
#    3. Emotion - sad long song
#    4. Enjoyment - sd long song
#    5. Emotion - sad short song
#    6. Enjoyment - sad long song
RMSEs = []
for ij in range(6):
    my_num = ij+1
    
    clf = linear_model.LinearRegression()
    
    #Which variables are > thresh?
    thresh = .05
    #How far in the future are we predicting?
    offset = 40
    #What is the length of the autoregression
    attn_length = 40
    
    
    #Load X
    with open('X_matrix'+str(my_num)+'.csv', 'r') as f:
        reader = csv.reader(f)
        your_list = list(reader)
    
    
    X = list()
    for i in range(len(your_list)):
        X.append([float(x) for x in your_list[i]])
    
    #Standardize, if necessary. Normalization makes values between 0 and 1
    if standardize:
        X = preprocessing.scale(X)
    else:
        pass
    
    #Load y
    with open('y_matrix'+str(my_num)+'.csv', 'r') as f:
        reader = csv.reader(f)
        your_list = list(reader)
    
    y = [float(x[0]) for x in your_list]
    
    #Snip out first 30 sec (ALREADY DONE)
    y_cut = y
    
    
    #Make the autoregressive IVs
    y_regress = list()
    for i in range(offset+attn_length,len(y_cut)):
        y_regress.append(np.reshape(y_cut[i-attn_length-offset:i-offset][:],attn_length))
    
    
    
    #Split into training and testing
    X_train = y_regress[:math.floor(.8*len(y_cut))-attn_length-offset][:] 
    y_train = y_cut[attn_length+offset:math.floor(.8*len(y_cut))]
    
    X_test = y_regress[math.floor(.8*len(y_cut))-attn_length-offset:][:] 
    y_test = y_cut[math.floor(.8*len(y_cut)):]
    
    
    
    
    #TODO: IS THIS RIGHT?
    clf.fit(X_train, y_train)
    print(clf.coef_)
    
    #0-12 MFCCs
    #13-25 dMFCCs
    #26-38 ddMFCCs
    #39 clarity
    #40 brightness
    #41 key_strength
    #42 rms
    #43 centroid
    #44 spread
    #45 skewness
    #46 kurtosis
    #47-58 chroma
    #59 mode
    #60 compress
    #61 hcdf
    #62 flux
    #63-73 lpcs
    
    
    #Determine which variables are most important
    rel_vars = abs(clf.coef_)>thresh
    inds = [j for (i,j) in zip(clf.coef_,range(len(clf.coef_))) if abs(i) >= thresh]
    
    inds_mod = [x%74 for x in inds]
    
    print(sorted(inds_mod))
    print(sum(abs(clf.coef_)>thresh))
    print((abs(clf.coef_)>thresh))
    print(nlargest(3, clf.coef_))
    print(clf.intercept_)

    
    #Get RMSE
    RMSE = (len(y_test)**-1)*sum((clf.predict(X_test)-y_test)**2)
    RMSEs.append(RMSE)
    plt.plot(range(len(y_test[:-2])),clf.predict(X_test[:][:-2]))
    plt.plot(range(len(y_test[:-2])),y_test[:-2])
    plt.show()
