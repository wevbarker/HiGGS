#!/bin/bash
#	this file prepares a kernel report and sends it to the tower by ssh 
#	if this is run as a standalone, then load the modules
module load anaconda/python3
#	this file prepares a kernel report and sends it to the tower by ssh 
while true; do
  echo "			(...replotting...)"
  ./appcg.plt.py
  #./appcg.plt.py > /dev/null 2>&1
  scp ./appcg.plt.png tower:~/Documents/physics/projects/HiGGS_development/ 
  #./peta4_jobs_plot.py > /dev/null 2>&1 	#	 for quiet plotting
done
