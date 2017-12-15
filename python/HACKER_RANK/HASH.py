
"""
A kidnapper wrote a ransom note but is worried it will be traced back to him.
He found a magazine and wants to know if he can cut out whole words from it
and use them to create an untraceable replica of his ransom note.
The words in his note are case-sensitive and he must use whole words available
in the magazine, meaning he cannot use substrings or concatenation to create
the words he needs.

Given the words in the magazine and the words in the ransom note,
print Yes if he can replicate his ransom note exactly using whole
words from the magazine; otherwise, print No.
"""

import string
from collections import Counter

#P = [[0. for row in range(5)] for col in range(5)]
#for x in P: print [ round(elem, 2) for elem in x ]

'''
#######################
# 1st solution: Use counter
#######################
def ransom_note(magazine, ransom):
    print Counter(ransom)
    print Counter(magazine)
    print Counter(ransom) - Counter(magazine)
    return not (Counter(ransom) - Counter(magazine))
'''

#######################
# 2nd solution: Use hash, e.g., python dict
#######################
def ransom_note(magazine, ransom):
    mag = {}

    for word in magazine:
        if word not in mag:
            mag[word] = 1
        else:
            mag[word] += 1

    for word in ransom:
        if word in mag:
            mag[word] -= 1
        else:
            return False

    #print all([x >=0 for x in mag.values()])
    return all([x >=0 for x in mag.values()])

'''
magazine = 'two times three is not four'
#magazine = 'two times three is not four two two two'
#magazine = 'two times three is not four two'
ransom = 'two times two is four'
#magazine = 'give me one grand today night'
#ransom = 'give one grand today'
magazine = 'Gave give'
ransom = 'g give'
magazine = 'give'
ransom = 'give'
magazine = 'give give Gave'
ransom = 'Gave give'

ransom = 'z z'
magazine = 'z Z z'

magazine = magazine.strip().split(' ')
ransom = ransom.strip().split(' ')
'''
m, n = map(int, raw_input().strip().split(' '))
magazine = raw_input().strip().split(' ')
ransom = raw_input().strip().split(' ')

answer = ransom_note(magazine, ransom)
if(answer):
    print "Yes"
else:
    print "No"
