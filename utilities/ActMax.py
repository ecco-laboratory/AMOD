#!/usr/bin/env python

# -*- coding: utf-8 -*-
"""
Original file is located at
    https://colab.research.google.com/drive/1F5gJjzrNHAgRuIzGmenzqiiChtwk2ZXu

# High-performance Evolutionary Algorithms for Online Neuron Control (GECCO 2022)

Binxu Wang, Carlos R. Ponce

**Author of notebook**: Binxu Wang (binxu_wang@hms.harvard.edu)

**Github Repo**: https://github.com/Animadversio/ActMax-Optimizer-Dev

## Set up

Set up dependency and import basics
"""
import torch
import argparse
import numpy as np
from matplotlib import animation
from matplotlib import rc
import matplotlib.pyplot as plt
import os
# %matplotlib inline
# equivalent to rcParams['animation.html'] = 'html5'
rc('animation', html='html5')

assert torch.cuda.is_available(), "Need a GPU runtime to run evolutions efficiently."

"""## Simple Evolution Experiment"""

from core.insilico_exps import ExperimentEvolution
from core.Optimizers import CholeskyCMAES, ZOHA_Sphere_lr_euclid, Genetic, pycma_optimizer

def main():

 parser = argparse.ArgumentParser(description='Process some images.')
 parser.add_argument('--classifier',metavar='s',type=str, default="emonet",help='ANN to optimize')
 parser.add_argument('--opt_layer', metavar='s', type=str, default="fc6", help='Layer at which we optimize a code')
 parser.add_argument('--act_layer', metavar='s', type=str, default=".Conv2dConv_6", help='Layer at which we activate neurons')
 parser.add_argument('--encoding_filename', metavar='s', type=str, default=None, help='Filename of csv file with encoding weights, e.g., /home/pkragel/fc7_sub1_betas_amy_subregion2.csv')
 parser.add_argument('--output_filename', metavar='b', type=str, default="emonet_genfc6_actfc7_sub1_betas_amy_subregion2", help='Name for saving results')
 parser.add_argument('--unit', type=float, default=0,help='Unit to maximize')
 parser.add_argument('--init_code',type=float,default = np.random.normal(0,1,[1, 4096]), help = 'How to initialize tokens') 
 parser.add_argument('--output_folder',type=str,default = "tmp", help = 'Name of folder to write output.')
 parser.add_argument('--code_dim', type=int, default=4096,help='Dimensionality of codes')
 parser.add_argument('--imgsize',type=int,default=(227,227),help='Size of image to generate')


 args = parser.parse_args()


 tmpsavedir = args.output_folder # Temporary save directory
 current_directory = os.getcwd()
 final_directory = os.path.join(current_directory, tmpsavedir)
 if not os.path.exists(final_directory):
   os.makedirs(final_directory)

 # load optimizer
 #optim = CholeskyCMAES(4096, population_size=40, init_sigma=2.0, Aupdate_freq=10, init_code=np.random.normal(0,1,[1, 4096]))
 optim = CholeskyCMAES(args.code_dim, population_size=40, init_sigma=2.0, Aupdate_freq=10,init_code=args.init_code) #add init code- pk 5/15/23


 explabel, model_unit = args.output_filename, (args.classifier, args.act_layer, args.unit)

 #explabel, model_unit = "alexnet_fc6_3", ("alexnet", ".classifier.Linear6", 7)
 Exp = ExperimentEvolution(model_unit, savedir=tmpsavedir, explabel=explabel, optimizer=optim, GAN=args.opt_layer,max_step=500,encoding_file = args.encoding_filename,imgsize=(227, 227))
 # run evolutions
 Exp.run()
 Exp.visualize_best()
 Exp.visualize_trajectory()
 Exp.save_last_gen()

if __name__ == '__main__':
  main()
