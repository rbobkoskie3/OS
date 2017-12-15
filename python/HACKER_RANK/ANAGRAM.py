
"""
Given two strings,  and , that may or may not be of the same length,
determine the minimum number of character deletions required to make
and  anagrams.
Any characters can be deleted from either of the strings.
"""
import string

#P = [[0. for row in range(5)] for col in range(5)]
#for x in P: print [ round(elem, 2) for elem in x ]

def number_needed(a, b):
    count = 0
    obs = 0
    observed_a = dict.fromkeys(string.ascii_lowercase, 0)
    observed_b = dict.fromkeys(string.ascii_lowercase, 0)
    for i in a: observed_a[i] +=1
    for i in b: observed_b[i] +=1   

    #print observed_a, '\n'
    #print observed_b, '\n'
    sum_ab = sum( {key: abs(observed_a[key] - observed_b.get(key, 0))\
                   for key in observed_a.keys()}.values() )
    '''
    sum_a  = sum({key: abs(observed_a[key] - 1)\
                  for key in observed_a.keys()\
                  if observed_a[key] != 0}.values())
    sum_b  = sum({key: abs(observed_b[key] - 1)\
                  for key in observed_b.keys()\
                  if observed_b[key] != 0}.values())
    
    print sum_a, sum_b, sum_ab
    print {key: abs(observed_a[key])\
                  for key in observed_a.keys()\
                  if observed_a[key] != 0}
    print {key: abs(observed_b[key])\
                  for key in observed_b.keys()\
                  if observed_b[key] != 0}
    '''

    return sum_ab

'''
a = 'abcabcaa'
b = 'abc'

a = 'aab'
b = 'bbaaa'

a = 'ab'
b = 'abcaa'

b = 'aaabbcccc'
a = 'abcdddd'

a = 'abc'
b = 'cde'

a = 'aab'
b = 'abbc'
'''
a = raw_input().strip()
b = raw_input().strip()

print number_needed(a, b)
