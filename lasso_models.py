#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 25 11:17:45 2019

@author: greert
"""

from sklearn import linear_model
import csv
import pandas as pd
from heapq import nlargest
from sklearn import preprocessing
import math
import numpy as np
import matplotlib.pyplot as plt



standardize = False



#ij is the song
#    1. Emotion - happy song
#    2. Enjoyment - happy song
#    3. Emotion - sad long song
#    4. Enjoyment - sd long song
#    5. Emotion - sad short song
#    6. Enjoyment - sad long song


minaa = []
minRMSE = []
for ij in range(6):
    my_num = ij+1
    RMSEs = []
    #These values will change
    myMin = 100000000000
    myaa = -99

    for aa in [10e-6,10e-5,10e-4]:#,10e-5,10e-4,10e-3,10e-2,10e-1,1]:
        
        clf = linear_model.Lasso(alpha=aa, normalize=True)
        
        
        
        
        
        #standardized vs normalized features?
        
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
        X_cut = X 
        y_cut = y
        
        
        #Split into training and testing
        X_train = X_cut[:math.floor(.8*len(X_cut))][:] 
        y_train = y_cut[:math.floor(.8*len(y_cut))]
        
        X_test = X_cut[math.floor(.8*len(X_cut)):][:] 
        y_test = y_cut[math.floor(.8*len(y_cut)):]
        
        clf.fit(X_test, y_test)
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
        #63-74 lpcs
        
        #Determine which variables are most important
        rel_vars = abs(clf.coef_)>.02
        inds = [j for (i,j) in zip(clf.coef_,range(len(clf.coef_))) if abs(i) >= .005]
        
        print(inds)
        
        print(sum(abs(clf.coef_)>.02))
        
        print((abs(clf.coef_)>.02))
        
        print(nlargest(3, clf.coef_))
        
        print(clf.intercept_)
        
        RMSE = (len(y_test)**-1)*sum((clf.predict(X_test)-y_test)**2)
        print(RMSE)
        if RMSE < myMin:
            myMin = RMSE
            myaa = aa
    minaa.append(myaa)
    minRMSE.append(myMin)
    plt.plot(range(len(y_test[:-2])),clf.predict(X_test[:][:-2]))
    plt.plot(range(len(y_test[:-2])),y_test[:-2])
    plt.show()
    print(RMSEs)