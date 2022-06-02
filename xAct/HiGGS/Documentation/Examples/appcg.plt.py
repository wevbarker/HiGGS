#!/usr/bin/env python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import sys
import random
import matplotlib as mpl
from matplotlib import cm
from matplotlib.collections import LineCollection
from matplotlib.colors import ListedColormap, BoundaryNorm
import os
from os.path import exists
import shutil
import subprocess
import socket
import colorsys     #   for converting hsl to rgb
import re   #   for extracting kernel numbers from strings
from matplotlib import cm
from matplotlib.colors import ListedColormap, LinearSegmentedColormap

#================ plot params and TeX setup ======================

mpl.use('Agg')

plt.rc('text',usetex = True)

plt.rc('text.latex', preamble = 
r'\usepackage[notextcomp]{stix}'+
r'\usepackage{amsmath}'+
r'\usepackage{etoolbox}'+
r'\usepackage{bm}')

mpl.rcParams['font.family'] = 'serif'

# we want the width always to be a single or double column, we can get this from revtex using
# \uselengthunit{in}\printlength{\linewidth} ---> 3.40457
# \uselengthunit{in}\printlength{\textwidth} ---> 7.05826
# mpl like to use inches

onecol = 3.40457
twocol = 7.05826

#=============== tuning params ==========================

cols = twocol                           #   onecol or twocol
asp = 0.5                                #   vertical aspect ratio
barwidth = 0.9                          #   main thickness of bar
size = 10000                            #   how many slices
time_array = np.linspace(0,1,size)      #   plotting space
maxtheory = 10                          #    how many total theory columns did we allow?
rough_number_of_functions = 6           #   less info, middle sub-bar
rougher_number_of_functions = 5         #   even less, upper sub-bar

xmx = 1     #1
ymx = 1      #  5

#=============== cols params ==========================

greys = cm.get_cmap('Greys', 120)
blues = cm.get_cmap('Blues', 120)
greens = cm.get_cmap('Greens', 120)
oranges = cm.get_cmap('Oranges', 120)
rdpu = cm.get_cmap('RdPu', 120)
gnbu = cm.get_cmap('GnBu', 120)
pnbugn = cm.get_cmap('PuBuGn', 120)
purd = cm.get_cmap('PuRd', 120)
orrd = cm.get_cmap('OrRd', 120)
purples = cm.get_cmap('Purples', 120)
ylgn = cm.get_cmap('YlGn', 120)

newcolors = greys(np.linspace(0, 1, 256))
newcolors = np.append(newcolors,blues(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,greens(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,oranges(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,rdpu(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,gnbu(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,pnbugn(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,ylgn(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,orrd(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,purples(np.linspace(0, 1, 256)),axis=0)
newcolors = np.append(newcolors,purd(np.linspace(0, 1, 256)),axis=0)

print(np.shape(newcolors))

def my_rgb(hue,sat):
    val = np.asarray(colorsys.hsv_to_rgb(hue,sat,1.))
    return val


#=============== misc =================================

width = cols
height = asp*cols 

#=============== plot setup =================================

fig, axs = plt.subplots(1,1,sharex = True, sharey = True, figsize = (width,height), gridspec_kw = {'wspace':0.1, 'hspace':0.2})
#, gridspec_kw = {'wspace':0.1, 'hspace':0.2}
#fig, axs = plt.subplots(2,5, gridspec_kw = {'wspace':0, 'hspace':-0.2})
#sp = fig.add_subplot(111)

#plt.subplots_adjust(hspace = 0.,wspace = 0.)

#=============== node loop =================================

plt.draw()

#plt.savefig('kernels-2.pdf',bbox_inches = 'tight',pad_inches=0)
plt.savefig('appcg.plt.png',bbox_inches = 'tight',dpi = 900)

mycmaps = { 'notacmap' : 0 }
twinxs = { 'notacmap' : 0 }

for x in range(xmx):
    for y in range(ymx):


        node = y*xmx+x
        if node == node:
        #try:
            '''
            try:
            '''

            #=============== files =================================

            kernel_files = os.listdir("svy/node-" + str(node) + "/chr/")

            ticklabels=[]
            for filename in kernel_files:
                if 'kernel' in filename:
                    list_digits = re.findall(r'\d+', filename)
                    ticklabels.append(list_digits[0])

            kernel_files = [x for _,x in sorted(zip(list(map(int,ticklabels)),kernel_files))]
            ticklabels = [x for _,x in sorted(zip(list(map(int,ticklabels)),ticklabels))]
            ticklabels = list(map(lambda x : r"\texttt{"+ x +"}", ticklabels))

            #del ticklabels[1::4]
            #del ticklabels[1::3]
            #del ticklabels[1::2]

            print(ticklabels)

            def make_np(filename):
                pds = pd.read_csv('svy/node-' + str(node) + '/chr/'+filename).to_numpy()
                print(filename)
                print(np.shape(pds))
                return pd.read_csv('svy/node-' + str(node) + '/chr/'+filename).to_numpy()

            #   a list, not np, of np arrays containing all data with headers
            all_kernel_data = list(map(make_np,kernel_files))

            #   all numerical columns, no headers, with the start times
            def start_cols(array):
                return array[1:,::2]

            #   to find the start and end of the whole survey
            start_times = np.concatenate(list(map(start_cols,all_kernel_data)))
            start_times = start_times.astype('float')
            s_times = np.copy(start_times)
            start_times[start_times == 0.] = 'nan'
            start_time = np.nanmin(start_times)
            stop_time = np.nanmax(start_times)
            total_time=stop_time-start_time

            time_array = np.linspace(0,total_time,size)    #   plotting space

            number_of_functions = int(list(np.shape(all_kernel_data[0]))[1]/(2*maxtheory))
            number_of_kernels = len(all_kernel_data)

            ticksthem = list(range(0,number_of_kernels))
            #del ticksthem[1::4]
            #del ticksthem[1::3]
            #del ticksthem[1::2]
            print(ticksthem)
            print(ticklabels)


            acttheory = np.floor(np.max(np.nonzero(np.sum(s_times,axis=0)))/number_of_functions).astype(int)


            #====================== use of axs ==============

            if xmx == ymx and xmx == 1:
                axr = axs
            else:
                axr = axs[y,x]

            twinxs['twinx'+str(x)+str(y)] = axr.twinx()
            #====================== bar width and chart geometry ==============

            propunit = 1.

            point_hei = axr.get_window_extent().transformed(fig.dpi_scale_trans.inverted()).height*fig.dpi
            line_width = 0.8*point_hei/number_of_kernels

            #=============== colourmap =============================

            print("building new colormap ",node)

            rcolors = 0.
            rcolors = greys(np.linspace(0, 1, 256))
            print(np.shape(rcolors))

            for theory in range(10):
                hue = random.uniform(0,1)
                '''
                cma = my_rgb(hue,np.asarray(np.linspace(0, 1, 256)))
                '''
                cma = np.array([my_rgb(hue,sat) for sat in np.asarray(np.linspace(0, 1, 256))])
                cma = np.transpose(cma)
                print(np.shape(cma))
                print(np.shape(np.expand_dims(np.asarray(np.full(256,1.)),axis = 0)))
                cma = np.append(cma,np.expand_dims(np.asarray(np.full(256,1.)),axis = 0),axis = 0)
                cma = np.transpose(cma)
                print(np.shape(cma))
                rcolors = np.append(rcolors,cma,axis = 0)

            endpt = 256*(1+acttheory)
            '''silly = ListedColormap(newcolors[0:endpt:,:],name='silly')'''

            mycmaps['silly'+str(node)] = ListedColormap(rcolors[0:endpt:,:],name='silly'+str(node))

            #==================== construct the data ===========================

            for kernel in range(0,number_of_kernels):

                print("plotting data from node ",node," and kernel ",kernel)
                kernel_data = all_kernel_data[kernel]

                kernel_array = np.full(size,kernel*propunit)    #   this is for the horizontal line position
                function_data = np.zeros(size)  #   by  default, assume the kernel is idle the whole time
                for theory in range(0,acttheory+1):
                    for function_number in range(1,rougher_number_of_functions+1):
                        function_times = kernel_data[1::,(theory*2*number_of_functions+2*function_number-2):(theory*2*number_of_functions+2*function_number):]    #   just take the two columns that affect that function in that theory
                        for row in function_times:
                            if row[0]>0:
                                t1=int(np.floor(size*(row[0]-start_time)/total_time))
                                t2=int(np.floor(size*(row[0]+row[1]-start_time)/total_time))+1
                                function_data[t1 : t2] = ((theory*2*number_of_functions+2*function_number-2)/((acttheory+1)*2*number_of_functions))

                ##   superior method using collections
                points = np.array([time_array, kernel_array]).T.reshape(-1, 1, 2)
                segments = np.concatenate([points[:-1], points[1:]], axis=1)

                # Create a continuous norm to map from data points to colors
                norm = plt.Normalize(0., 1.)
                lc = LineCollection(segments, cmap=mycmaps['silly'+str(node)], norm=norm)

                # Set the values used for colormapping
                lc.set_array(function_data)
                lc.set_linewidth(line_width)
                line = axr.add_collection(lc)

                kernel_array = np.full(size,(kernel-0.7*(1-0.75))*propunit)    #   this is for the horizontal line position
                function_data = np.zeros(size)  #   by  default, assume the kernel is idle the whole time
                for theory in range(0,acttheory+1):
                    for function_number in range(1,rough_number_of_functions+1):
                        function_times = kernel_data[1::,(theory*2*number_of_functions+2*function_number-2):(theory*2*number_of_functions+2*function_number):]    #   just take the two columns that affect that function in that theory
                        for row in function_times:
                            if row[0]>0:
                                t1=int(np.floor(size*(row[0]-start_time)/total_time))
                                t2=int(np.floor(size*(row[0]+row[1]-start_time)/total_time))+1
                                function_data[t1 : t2] = ((theory*2*number_of_functions+2*function_number-2)/((acttheory+1)*2*number_of_functions))

                ##   superior method using collections
                points = np.array([time_array, kernel_array]).T.reshape(-1, 1, 2)
                segments = np.concatenate([points[:-1], points[1:]], axis=1)

                # Create a continuous norm to map from data points to colors
                norm = plt.Normalize(0., 1.)
                lc = LineCollection(segments, cmap=mycmaps['silly'+str(node)], norm=norm)

                # Set the values used for colormapping
                lc.set_array(function_data)
                lc.set_linewidth(0.75*line_width)
                line = axr.add_collection(lc)

                kernel_array = np.full(size,(kernel-0.7*(1-0.5))*propunit)    #   this is for the horizontal line position
                function_data = np.zeros(size)  #   by  default, assume the kernel is idle the whole time
                for theory in range(0,acttheory+1):
                    for function_number in range(1,number_of_functions+1):
                        function_times = kernel_data[1::,(theory*2*number_of_functions+2*function_number-2):(theory*2*number_of_functions+2*function_number):]    #   just take the two columns that affect that function in that theory
                        for row in function_times:
                            if row[0]>0:
                                t1=int(np.floor(size*(row[0]-start_time)/total_time))
                                t2=int(np.floor(size*(row[0]+row[1]-start_time)/total_time))+1
                                function_data[t1 : t2] = ((theory*2*number_of_functions+2*function_number-2)/((acttheory+1)*2*number_of_functions))
             
                ##   superior method using collections
                points = np.array([time_array, kernel_array]).T.reshape(-1, 1, 2)
                segments = np.concatenate([points[:-1], points[1:]], axis=1)

                # Create a continuous norm to map from data points to colors
                norm = plt.Normalize(0., 1.)
                lc = LineCollection(segments, cmap=mycmaps['silly'+str(node)], norm=norm)

                lc.set_array(function_data)
                lc.set_linewidth(0.5*line_width)
                line = axr.add_collection(lc)

            #=================== limits ======================

            axr.set_xlim(0., total_time)
            '''
            axr.set_yticks(list(propunit*np.array(list(range(0,number_of_kernels)))))
            '''
            axr.set_yticks(ticksthem)
            axr.set_yticklabels(ticklabels)
            axr.set_ylim(-0.5*propunit, (number_of_kernels-0.5)*propunit)
            axr.tick_params(axis = 'y',labelsize = 6)
            axr.tick_params(axis = 'x',labelsize = 6)
            #axr.set_xscale('symlog',linthreshx = 10000) #   this causes serious delays

            #=================== end admin to label the plot ======================

            title_string = r"Node " + str(node)
            #axr.set_title(title_string, fontsize = 6, pad = 0)
            #title_string = r"Node: \texttt{"+socket.gethostname()+"}"
            #axs[node].set_ylabel(r"\texttt{\${}KernelID}")
            #axs[node].set_xlabel(r"Wallclock time/s")


            twinxs['twinx'+str(x)+str(y)].set_ylabel(title_string, fontsize = 6)
            twinxs['twinx'+str(x)+str(y)].set_yticks([])

            if x == 0:
                axr.set_ylabel(r"Core (\texttt{\${}KernelID})", fontsize = 6)
            if y == ymx-1:
                axr.set_xlabel(r"Wallclock time/s", fontsize = 6)
            
        #except:
        #    print("there was a problem with plotting node ",node)

#=================== plt draw ======================

#fig.text(0.5, 0.04, r"Wallclock time/s", ha='center')
#fig.text(0.0, 0.5, r"Core (\texttt{\${}KernelID})", va='center', rotation='vertical')

print('drawing plot')
plt.draw()

#plt.savefig('kernels-2.pdf',bbox_inches = 'tight',pad_inches=0)
plt.savefig('appcg.plt.png',bbox_inches = 'tight',pad_inches=0,dpi = 900)

sys.exit()
