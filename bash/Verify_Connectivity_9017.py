#!/usr/bin/env python-flood

# ID: rb868x 182 Sep  6 20:32 Verify_Connectivity_9017.py

from sis.rssh.rsshclient import runQuery
cmd = 'hostname'
R=runQuery( cmd, 'flood' )
print R,
