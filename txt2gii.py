#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Saves a txt matrix to gifti


    Parameters
    ----------

    conn     : str, path to connectivity matrix

    Usage
    -----
    txt2gii.py --conn input_name

Created on June 2023 (the year of light)

@author: rcruces
"""

import argparse
import pandas as pd
import nibabel as nib
import numpy as np
import os

# Function save as gifti
def save_gii(data_array, file_name):
    # Initialize gifti: NIFTI_INTENT_SHAPE - 2005, FLOAT32 - 16
    gifti_data = nib.gifti.GiftiDataArray(data=data_array, intent=2005, datatype=16)

    # this is the GiftiImage class
    gifti_img = nib.gifti.GiftiImage(meta=None, darrays=[gifti_data])

    # Save the new GIFTI file
    nib.save(img=gifti_img, filename=file_name)

# Argument parsing
parser = argparse.ArgumentParser(description="micapipe txt to gii function")
parser.add_argument("--conn", help="path to connectivity matrix", required=True)
args = parser.parse_args()

# Read connectivity matrix
M = pd.read_csv(args.conn, sep=" ", header=None).values
print("INFO.... Connectome dimensions: {} x {}".format(M.shape[0], M.shape[1]))
print("INFO.... Saving as GIFTI")
output_file = args.conn.replace("txt", "shape.gii")
save_gii(M, output_file)
print("GIFTI file saved as:", output_file)
