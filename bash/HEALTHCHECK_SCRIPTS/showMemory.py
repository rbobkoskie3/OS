#! /usr/bin/env python

# ID: rb868x 5130 May 21 14:56 showMemory.py
# Tested on Solaris 10, Red Hat 5.[35]

# showMemory.py will monitor the overall free memory and, if it gets
# above a <threshold>%, e.g., 30%, then, determine and display all the
# processes that are consuming 100M (Megabyte) or more memory at that
# time.


#####################################
import os, glob
import fnmatch
import time
import stat
import re, string
import getopt

from subprocess import *
#####################################

lineDelim = '-----------------------------------------------------------'

def showMemory(lowmemLimit, OS):

    #print('%s' % lineDelim)
    #print('\tMemory available on this host')
    print('%s' % lineDelim)

    REGEX_G = re.compile('[Gg]')
    REGEX_M = re.compile('[Mm]')
    REGEX_K = re.compile('[Kk]')

    # OS == Linux
    if OS == 'Linux':
	cmd = 'top -bn1  2>/dev/null | grep Mem.*:'

	input = os.popen(cmd,'r')
	for line in input.readlines():
	    print ('%s' % (line))
	    items = string.split(line)
	    totmem = int(items[1][:-1])
	    freemem = int(items[5][:-1])
	    usedmem = int(items[3][:-1])
	    memthreshold = totmem * float(lowmemLimit)
	    # print ('total/free/used/threshold = %s/%s/%s/%s' % (totmem,freemem,usedmem,memthreshold))

	    if REGEX_G.match(items[1][-1]):
		BYTES = 'G'
		TOTALMEM_MEGA = totmem * 1000
	    elif  REGEX_M.match(items[1][-1]):
		BYTES = 'M'
		TOTALMEM_MEGA = totmem
	    elif  REGEX_K.match(items[1][-1]):
		BYTES = 'K'
		TOTALMEM_MEGA = totmem / 1000

	    # print 'TOTALMEM_MEGA: ', TOTALMEM_MEGA

    else:
	# Then OS == Solaris
	cmd = 'top -d1  2>/dev/null | grep Mem.*:'

	input = os.popen(cmd,'r')
	for line in input.readlines():
	    print ('%s' % (line))
	    items = string.split(line)
	    totmem = int(items[1][:-1])
	    freemem = int(items[4][:-1])
	    usedmem = totmem - freemem
	    memthreshold = totmem * float(lowmemLimit)
	    # print ('total/free/used/threshold = %s/%s/%s/%s' % (totmem,freemem,usedmem,memthreshold))

	    if REGEX_G.match(items[1][-1]):
		BYTES = 'G'
		TOTALMEM_MEGA = totmem * 1000
	    elif  REGEX_M.match(items[1][-1]):
		BYTES = 'M'
		TOTALMEM_MEGA = totmem
	    elif  REGEX_K.match(items[1][-1]):
		BYTES = 'K'
		TOTALMEM_MEGA = totmem / 1000

	    # print 'TOTALMEM_MEGA: ', TOTALMEM_MEGA

    if usedmem > memthreshold:
	print ('ERROR: Memory Used now at %s%s is greater than %s Utilization' % (usedmem, BYTES, lowmemLimit))
    else:
	print ('INFO: Memory Used at %s%s is under %s Utilization' % (usedmem, BYTES, lowmemLimit))

    # look at /tmp for avalable space and trigger alarm when SWAP is over-utilized
    SWAP = 50
    print('%s' % lineDelim)
    cmd = 'df -h  /tmp 2>/dev/null' 
    input = os.popen(cmd,'r')
    HDR = 0
    for line in input.readlines():
	# skip header record
	if HDR == 0:
	    HDR += 1
	    continue
	print line
	TMP = string.split(line)
	swapused = int(TMP[4][:-1])
	if swapused > SWAP:
	    print ('ERROR: SWAP is > %s\n%s' % (swapused, line[:-1]))
	else:
	    print ('INFO: SWAP is OK: %s' % (swapused))

    return TOTALMEM_MEGA

def procMemUsage(memLimit, OS):

    displayFlag = True
    MEGA = memLimit / 1000

    # memory use for each PID

    # OS == Linux
    if OS == 'Linux':
	cmd = 'ps efo pid,vsz,args | grep -v grep'
    else:
	# Then OS == Solaris
	cmd = 'ps -ef -o pid -o vsz -o args | grep -v grep'

    if displayFlag:
	print('%s' % lineDelim)
	print('\tProcesses consuming more than %d Mbytes' % MEGA)

	# Heading
	#  UID   PID  STIME  TIME CMD
	#heading = '  PID     SIZE(M)    CMD'
	heading = '  SIZE(M)    CMD'
	print('%s' % lineDelim)
	print('%s' % heading)
	print('%s' % lineDelim)

    cnt = 0
    HDR = 0
    procList = []
    totSz = 0
    input = Popen(cmd, shell=True, stdout=PIPE).stdout
    for line in input.readlines():
	# skip heading
	if HDR == 0:
	    HDR += 1
	    continue
	# parse
	items = string.split(line)
	PID = items[0]
	VSZ = items[1]
	CMD = items[2:]
	qStr = '%-8s %8s  %s' % (PID, VSZ, CMD)
	#print('%s' % qStr)

	# check for memory limit
	if int(VSZ) < memLimit:
	    continue

	cnt += 1
	procList.append(PID)
	# size in M
	sz = int(VSZ) / 1000
	totSz += sz
	qStr = '%-8d %s' % (sz, CMD)
	if displayFlag:
	    print('%s' % qStr)

    if displayFlag:
	if cnt == 0:
	    print('No Memory Hogs (> %d Mbytes) running' % MEGA)
	else:
	    print('%s' % lineDelim)
	    print('Total Count = %s' % cnt)
	    print('Total Size = %d(M)' % totSz)


if __name__ == '__main__':  
    #lowMem = sys.argv[1]
    #print 'lowMem = %s' % lowMem

    # Query for 'lowmemLimit' % threshold on which additional memory queries will run.
    # NOTE for automation, hardcode 'lowmemLimit':
    # lowmemLimit = 30
    lowmemLimit = float(raw_input('Enter the threshold %, such that ALERTS are noted when mem used is  > threshold, e.g., 30: '))/100

    # Determine OS:
    OS = os.uname()[0]
    print 'OS :', OS

    # Use the value returned for memLimit, to define the threshold for  mem consumption with respect to individual process:
    memLimit = showMemory(lowmemLimit, OS)
    # print 'memLimit: ', memLimit
    procMemUsage(memLimit, OS)
