#!/usr/bin/env python-flood

# ID: rb868x 754 Nov  4 19:35 Verify_Connectivity_IGW_9017.py

from flood.util.rsshexec import rsshexec
import os.path

def main():
	key = 'flood_grp_dsa_key'
	user = 'floodanl'
	keyUser = 'flood'

	fullKeyPath = os.path.expanduser( '~%s/.ssh/%s' % ( keyUser, key ) )
	cmd = 'hostname'
	args = []
	role = 'digger'
	try:
		results = rsshexec( cmd, args, role=role, user=user, key=fullKeyPath, doExec=False )
		#print "Success! cmd: '%s', role: '%s', user: '%s', key: '%s'" % ( cmd, role, user, fullKeyPath )
		print results,
	except Exception, e:
		print "Error running command through rsshexec. cmd: '%s', role: '%s', user: '%s', key: '%s', error: %s" % (cmd, role, user, fullKeyPath, e )

if __name__ == '__main__':
	main()
