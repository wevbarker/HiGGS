#!/bin/bash
#	this file runs the jobs specified in jobs.m 
echo "welcome to peta4.job.sh"

#	first make sure we are in the correct directory
echo "moving to HiGGS_development"
cd /home/wb263/HiGGS_development


#	flush the stats directory
echo "flushing stats directory and build time"
rm -rf ./svy/node-$1/chr
mkdir ./svy/node-$1/chr
rm ./svy/node-$1/peta4.chr.mx
rm ./svy/node-$1/peta4.nom.mx

echo "commencing run loop"

#	run the job	
while [ $(ls ./svy/node-$1/chr | wc -l) -le 32 ]; do
  echo "fewer than 32 kernel files were found in the stats directory, running script peta4.job.m"

  #	flush the stats directory
  echo "flushing stats directory and build time"
  rm -rf ./svy/node-$1/chr
  mkdir ./svy/node-$1/chr
  rm ./svy/node-$1/peta4.chr.mx
  rm ./svy/node-$1/peta4.nom.mx

  math -run < peta4.job.m $1
  echo "script peta4.job.m has exited and returned to peta4.job.sh"
done

echo "exiting run loop because at least 32 kernel files were found in the stats directory, assuming we can kill the job"

echo "killing processes with pkill"

pkill -9 "Mathematica"
pkill -9 "Wolfram"
pkill -9 "xPert"
pkill -9 "xperm"

echo "the following processes are still running on this node:"

ps -u wb263

echo "exiting with code 0"
exit 0
