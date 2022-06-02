#!/bin/bash
#	this file runs the jobs specified in jobs.m 
#	first make sure everything else is dead, slightly overkill...
pkill -9 "Mathematica"
pkill -9 "Wolfram"
pkill -9 "xperm"
pkill -9 "appcg.plt.py"
pkill -9 "appcg.plt.sh"

#	start the plotting script
#	better to run independently through appch
#./appcg.plt.sh &

#	run the job	
math -run < appcg.job.m

#	kill the plotting script
pkill -9 "appcg.plt.py"
pkill -9 "appcg.plt.sh"
exit 0
