
"""
For the purposes of this challenge, we define a binary search tree to be a
binary tree with the following ordering properties:

 - The  value of every node in a node's left subtree is less than the
   data value of that node.
 - The  value of every node in a node's right subtree is greater than the
   data value of that node.

Given the root node of a binary tree, can you determine if it's also
a binary search tree?
"""

import random

#####################################
# Create binary tree
#####################################
class Tree:

    def __init__(self, data, left=None, right=None):
        self.data = data
        self.left = left
        self.right = right

    def __str__(self):
        return str(self.data)

#tree = Tree(1, Tree(2), Tree(3)) #3 node tree
treeL = Tree(2, Tree(1), Tree(3)) #IS binary tree
#treeL = Tree(2, Tree(9), Tree(3)) #NOT binary tree
treeR = Tree(6, Tree(5), Tree(7)) #IS binary tree
#treeR = Tree(6, Tree(7), Tree(5)) #NOT binary tree
#treeR = Tree(1, Tree(5), Tree(7)) #NOT binary tree
tree = Tree(4, treeL, treeR)
#####################################


#####################################
# O(n) solution: Is Tree a BST?
#####################################
def check(root, min_, max_):
    if root is None:
        #print ' - TRUE-1', root, min_, max_
        return True
    elif (min_ < root.data < max_ and
          check(root.left, min_, root.data) and
          check(root.right, root.data, max_)):
        #print ' - TRUE-2', min_, root.data, max_
        return True
    else:
        #print ' -- FALSE', root, min_, max_
        return False

def check_binary_search_tree(root):
    return check(root, -float('inf'), float('inf'))
#####################################


#####################################
# O(n) solution: Is Tree a BST?
#####################################
#prev = Tree(None)
prev = None
def isBST(root):
    global prev
    if root:
        #In-order traversal of BST
        #print '   --- INIT', root.data, prev.data
        if not isBST(root.left):
            #print 'FALSE-1   ', root.left
            return False
        if prev and root.data <= prev.data:
            #print 'FALSE-2', root.data, prev.data
            return False
        #print '  TRUE--1   ', root.data, prev, root.right
        prev = root
        #print '  TRUE--2   ', root.data, prev, root.right
        return isBST(root.right)
    #print 'TRUE--3   -------------'
    return True

def checkBST(root):
    return isBST(root)
#####################################


#####################################
def Total(tree):
    if tree == None:
        return 0
    print 'ROOT:', tree.data
    print '    ', tree.left, tree.right
    return Total(tree.left) + Total(tree.right) + tree.data

def Walk_BST(root):
    if root:
        '''
        #Pre-order traversal of BST
        print root.data
        Walk_BST(root.left)
        Walk_BST(root.right)
        '''
        #In-order traversal of BST
        Walk_BST(root.left)
        print root.data
        Walk_BST(root.right)
        '''
        #Post-order traversal of BST
        Walk_BST(root.left)
        Walk_BST(root.right)
        print root.data
        '''

#Walk_BST(tree)
#print check_binary_search_tree(tree)
#print checkBST(tree)
#####################################




#####################################
# Create binary tree from a random list of ints
#####################################
class Node:
    def __init__(self, val):
        self.value = val
        self.left = None
        self.right = None

    def insert(self, data):
        if self.value == data:
            return False
        elif self.value > data:
            if self.left:
                return self.left.insert(data)
            else:
                self.left = Node(data)
                return True
        else:
            if self.right:
                return self.right.insert(data)
            else:
                self.right = Node(data)
                return True

    def find(self, data):
        if self.value == data:
            return True
        elif self.value > data:
            if self.left:
                return self.left.find(data)
            else:
                return False
        else:
            if self.right:
                return self.right.find(data)
            else:
                return False

    def getHeight(self):
        if self.left and self.right:
            return 1 + max(self.left.getHeight(), self.right.getHeight())
        elif self.left:
            return 1 + self.left.getHeight()
        elif self.right:
            return 1 + self.right.getHeight()
        else:
            return 1

    def preorder(self):
        if self:
            print (str(self.value))
            if self.left:
                self.left.preorder()
            if self.right:
                self.right.preorder()

    def postorder(self):
        if self:
            if self.left:
                self.left.postorder()
            if self.right:
                self.right.postorder()
            print (str(self.value))

    def inorder(self):
        if self:
            if self.left:
                self.left.inorder()
            print (str(self.value))
            if self.right:
                self.right.inorder()

class BST:
    def __init__(self, data):
        self.root = None

    def insert(self, data):
        if self.root:
            return self.root.insert(data)
        else:
            self.root = Node(data)
            return True

    def find(self, data):
        if self.root:
            return self.root.find(data)
        else:
            return False

    def getHeight(self):
        if self.root:
            return self.root.getHeight()
        else:
            return -1

    def preorder(self):
        if self.root:
            print("PreOrder")
            self.root.preorder()
		
    def postorder(self):
        if self.root:
            print("PostOrder")
            self.root.postorder()
			
    def inorder(self):
        if self.root:
            print("InOrder")
            self.root.inorder()
        
def Make_BST(size):
    ints_ = random.sample(range(size*2), size)
    #print ints_
    for i, v in enumerate(ints_):
        if i == 0:
            my_BST = BST(v)
        else:
            #print i, v
            my_BST.insert(v)
    return my_BST


TREE = Make_BST(10)
'''
mynode = BST(4)
mynode.insert(9)
mynode.insert(5)
mynode.insert(7)
mynode.insert(11)
mynode.insert(8)
'''
print TREE.insert(1001)
TREE.inorder()
#TREE.preorder()
#print TREE.find(3)
#print TREE.getHeight()

