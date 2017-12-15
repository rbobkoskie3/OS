
"""
A bracket is considered to be any one of the following characters:
(, ), {, }, [, or ].

Two brackets are considered to be a matched pair if the an opening bracket
(i.e., (, [, or {) occurs to the left of a closing bracket
(i.e., ), ], or }) of the exact same type.
There are three types of matched pairs of brackets: [], {}, and ().

A matching pair of brackets is not balanced if the set of brackets it
encloses are not matched. For example, {[(])} is not balanced because
the contents in between { and } are not balanced. The pair of square
brackets encloses a single, unbalanced opening bracket, (, and the pair
of parentheses encloses a single, unbalanced closing square bracket, ].

By this logic, we say a sequence of brackets is considered to be balanced
if the following conditions are met:

It contains no unmatched brackets.
The subset of brackets enclosed within the confines of a matched pair of
brackets is also a matched pair of brackets.
Given  strings of brackets, determine whether each sequence of brackets
is balanced. If a string is balanced, print YES on a new line; otherwise,
print NO on a new line.
"""

import string
from collections import Counter

#P = [[0. for row in range(5)] for col in range(5)]
#for x in P: print [ round(elem, 2) for elem in x ]

'''
###########################
# 1st solution: FAILED, Did not pass all tests
# e.g., this will pass: expression = ']['
###########################
def is_matched(expression):
    if len(expression) %2 != 0:
        return False
    for x in range(len(expression)/2):
        start = expression[x]
        end = expression[len(expression) - x - 1]
        #print x, start, end
        if start == '[':
            if end != ']':
                return False
        if start == '{':
            if end != '}':
                return False
        if start == '(':
            if end != ')':
                return False
    return True
'''

#'''
###########################
# 2nd solution: PASSED, Use list as stack
###########################
def is_matched(expression):
    pairs = {'{' : '}', '[' : ']', '(' : ')'}
    stack = []
    for x in expression:
        # x is key, e.g., the left bracket in the pairs dict
        if x in pairs:
            stack.append(pairs[x])
            print x, pairs[x], '  ', stack
        # x is not in dict, e.g., it is a value, or the right bracket in 'pairs'
        elif not stack or x != stack.pop():
            print not stack, '  ', x, stack
            return False
    print stack
    return not stack
#'''

expression = '[[[({})]]]'
expression = '[[[[(((]))]]]]'
expression = '[[[[((()))]]]}'
expression = ']'
expression = '['
expression = '()()()'
expression = '}()()()(())'
expression = ']['
if is_matched(expression) == True:
    print "YES"
else:
    print "NO"

'''
t = int(raw_input().strip())
for a0 in xrange(t):
    expression = raw_input().strip()
    if is_matched(expression) == True:
        print "YES"
    else:
        print "NO"
'''
