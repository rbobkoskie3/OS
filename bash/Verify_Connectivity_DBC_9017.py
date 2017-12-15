#!/usr/bin/env python-flood

# ID: rb868x 186 Nov  1 18:25 Verify_Connectivity_DBC_9017.py

from sis.rssh.rsshclient import runQuery
cmd = 'hostname'
R=runQuery( cmd, 'flood' )
print R,
