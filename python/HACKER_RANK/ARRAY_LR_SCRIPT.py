
"""
Given an array of size N and a number d, rotate the array to the left by d
i.e. shift the array elements to the left by d.
Ex: The array [1, 2, 3, 4, 5] after rotating by 2 gives [3, 4, 5, 1, 2].
"""
#P = [[0. for row in range(5)] for col in range(5)]
#for x in P: print [ round(elem, 2) for elem in x ]
N, d = map(int, raw_input().split())
a = list(raw_input().split())

A = a
#print A
d_ = d % len(A) #1< = d <= len(A)
A_ = len(A)*[0]
for i in range(len(A)):
    A_[i-d_] = A[i]
#print '\n'
for x in A_: print x,

