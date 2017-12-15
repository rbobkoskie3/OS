
"""
A linked list is said to contain a cycle if any node is visited more
than once while traversing the list.

Complete the function provided in the editor below. It has one parameter:
a pointer to a Node object named head that points to the head of a linked list.
Your function must return a boolean denoting whether or not there is a cycle
in the list. If there is a cycle, return true; otherwise, return false.

Note: If the list is empty, head will be null.
"""

class Node:
    def __init__(self, data=None, next=None):
        self.data = data
        self.next  = next

    def __str__(self):
        return str(self.data)

node1 = Node(1)
node2 = Node(2)
node3 = Node(3)
node4 = Node(4)
node5 = Node(5)

#node1.next = None
#'''
node1.next = node2
node2.next = node3
node3.next = node4

node4.next = node5
node5.next = None
#node4.next = node3  #Will create a cycle
#node5.next = node1  #Will create a cycle
#'''

# 1st solution:
# Cycle detection: Keep track of visited NODES
# and return True if a NODE is revisted, e.g., a cycle
def has_cycle(head):
    cur = head
    seen = []
    while cur:
        print cur
        if cur in seen:
            return True
        seen.append(cur)
        cur = cur.next
    return False

# 2nd solution: Use two pointers, one slow and one fast.
# If there is a loop, slow == fast, e.g., a cycle
def has_cycle_TWO(head):
    if (head == None):
        return False
    slow = head
    fast = head.next
    print slow, fast
    while (slow != fast):
        if (fast == None or fast.next == None):
            return False
        slow = slow.next
        fast = fast.next.next
        print slow, fast
    return True

#cycle = has_cycle(node5)
cycle = has_cycle(node1)
print cycle

#cycle = has_cycle_TWO(node5)
cycle = has_cycle_TWO(node1)
print cycle

'''
#node = Node("test")
#print node

def print_list(node):
    while node:
        print node,
        node = node.next
    print

print_list(node1)
'''
