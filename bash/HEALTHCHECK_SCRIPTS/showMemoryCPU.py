#! /usr/bin/env python

# ID: rb868x 6717 May 24 18:52 showMemoryCPU.py
# Tested on Solaris 10, Red Hat 5.[35]

# showMemoryCPU.py will monitor the overall free memory and, if it gets
# above a <threshold>%, e.g., 30%, then, determine and display all the
# processes that are consuming 100M (Megabyte) or more memory at that
# time. If there is at least one process consuming 100M (Megabyte) or more
# memory, then a cross check of these processes will be run to verify the
# process CPU utilization.


#####################################
import os, re, string
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
	cmdTOP = 'top -bn1  2>/dev/null | grep Mem.*:'

	input = os.popen(cmdTOP,'r')
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
	cmdTOP = 'top -d1  2>/dev/null | grep Mem.*:'

	input = os.popen(cmdTOP,'r')
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
    cmdDF = 'df -h  /tmp 2>/dev/null' 
    input = os.popen(cmdDF,'r')

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
	cmdMEM = 'ps efo pid,vsz,args | grep -v grep'
    else:
	# Then OS == Solaris
	cmdMEM = 'ps -ef -o pid -o vsz -o args | grep -v grep'

    # Hardcoded to output the top 10 CPU Hogs
    cmdCPU = 'ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10'

    if displayFlag:
	print('%s' % lineDelim)
	print('\tProcesses consuming more than %d Mbytes' % MEGA)

	# Heading, defaul Megabytes (M)
	heading = '  SIZE(M)    CMD'
	print('%s' % lineDelim)
	print('%s' % heading)
	print('%s' % lineDelim)

    cnt = 0
    pidList = []
    totSz = 0

    ##################################
    # MEM Hogs:
    HDR = 0
    input = Popen(cmdMEM, shell=True, stdout=PIPE).stdout
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
	pidList.append(PID)

	# check for memory limit
	if int(VSZ) < memLimit:
	    continue

	cnt += 1
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
	    # print('%s' % lineDelim)
    ##################################

	    ##################################
	    # CPU Hogs:
	    HDR = 0
	    # NOTE that using the 'os.popen' comadn produces
	    # the following error with Python 2.4.3 on Linux.
	    # Solaris runs w/o error on Python 2.4.4.
	    # sort: write failed: standard output: Broken pipe
	    # sort: write error
	    # input = os.popen(cmdCPU,'r')

	    p = Popen(cmdCPU, shell=True, stdout=PIPE)
	    # communicate() returns a tuple with the 0th entry is the stdout, and the 1 position is the stderr
	    input = p.communicate()[0].split('\n')
	    # print 'input', input

	    heading = '         %CPU        PID      CMD'
	    print('%s' % lineDelim)
	    print('%s' % heading)
	    print('%s' % lineDelim)

	    # for line in input.readlines():
	    for line in input:
		# skip heading
		if HDR == 0:
			HDR += 1
			continue

		# print ('%s' % (line))
		items = string.split(line)
		# print 'items', items

		# Check that list is NOT EMPTY:
		if items:
			cpu = float(items[0])
			pidCPU = int(items[1])
			CMD = str(items[3])
			# print 'cpu, pidCPU', cpu, pidCPU

		for pidMEM in pidList:
			# print 'pidMEM, pidCPU', pidMEM, pidCPU
			if int(pidMEM) == int(pidCPU):
				qStr = '%-10s %-8s %-8s %s' % ('WARNING', cpu, pidCPU, CMD)
				print('%s' % qStr)
	    print('%s' % lineDelim)
	    ##################################


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
