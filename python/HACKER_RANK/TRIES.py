
"""
We're going to make our own Contacts application!
The application must perform two types of operations:

add name, where  is a string denoting a contact name.
This must store  as a new contact in the application.
find partial, where  is a string denoting a partial name
to search the application for. It must count the number
of contacts starting with  and print the count on a new line.
Given  sequential add and find operations, perform each
operation in order.
"""

import string
from collections import Counter

#P = [[0. for row in range(5)] for col in range(5)]
#for x in P: print [ round(elem, 2) for elem in x ]


###########################
# Use hash, e.g., dict to match chars,
# will work, however solution is slow
###########################
class Contacts:
    contacts = {}

    def add_c(self, name):
        self.contacts[name] = 1

    def find_c(self, name):
        result = [ key
                   for key, val in self.contacts.iteritems()
                   if key.startswith(name) ]
        print len(result)#, result

def ToDo(cmnd, name):
    my_c = Contacts()
    if cmnd == 'add':
        my_c.add_c(name)
    elif cmnd == 'find':
        result = my_c.find_c(name)

    #print my_c.contacts

'''
command = 'add rob'
op, contact = command.strip().split(' ')
ToDo(op, contact)
command = 'add robert'
op, contact = command.strip().split(' ')
ToDo(op, contact)
command = 'add red'
op, contact = command.strip().split(' ')
ToDo(op, contact)

command = 'find ro'
op, contact = command.strip().split(' ')
ToDo(op, contact)

n = int(raw_input().strip())
for a0 in xrange(n):
    op, contact = raw_input().strip().split(' ')
    ToDo(op, contact)
'''
###########################



###########################
# Use hash of chars, Faster solution
###########################
# all letters, a, ab, abc, ..
def edge_ngram(contact):
    #print [contact[0:idx] for idx in range(1, len(contact) + 1)]
    return [contact[0:idx] for idx in range(1, len(contact) + 1)]

contact_indices = {}
def add_c(contact):
    for token in edge_ngram(contact):
        contact_indices[token] = contact_indices.get(token, 0) + 1
    #print contact_indices

def find_c(name):
    return contact_indices.get(name, 0)

n = int(raw_input().strip())
for a0 in range(n):
    op, contact = raw_input().strip().split(' ')
    if op == 'add':
        add_c(contact)
    elif op == 'find':
        print(find_c(contact))
###########################
