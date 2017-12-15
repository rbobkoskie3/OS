
#import numpy as np
from math import *

def Array_LR(n, d):
    """
    Given an array of size N and a number d, rotate the array to the left by d
    i.e. shift the array elements to the left by d.
    Ex: The array [1, 2, 3, 4, 5] after rotating by 2 gives [3, 4, 5, 1, 2].
    """
    #P = [[0. for row in range(5)] for col in range(5)]
    #for x in P: print [ round(elem, 2) for elem in x ]

    A = [x+1 for x in range(n)]
    #print A
    d_ = d % len(A) #1< = d <= len(A)
    A_ = len(A)*[0]
    for i in range(len(A)):
        A_[i-d_] = A[i]
    #print '\n'
    for x in A_: print x,

#############################
def main():
    n = 5
    d = 4
    '''
    for n in range(3):
        for d in range(n+1):
            #print n+1, d+1
    '''
    Array_LR(n, d)

if __name__ == '__main__':
    main()
#############################
