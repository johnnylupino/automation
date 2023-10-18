from robocorp.tasks import task
from robocorp import browser

from collections import Counter
from sklearn.cluster import KMeans
from matplotlib import colors
import matplotlib.pyplot as plt
import numpy as np
import cv2
import pathlib
import os
import shutil
import json

@task
def get_colors():
   build_dictionary(keys=keys(),vals=vals())


def build_dictionary(keys,vals):
    cols = dict(map(lambda i,j : (i,j) , keys,vals))
    return cols

def keys():
    f = open("variables.txt",'r')
    keys = []
    for i in f:
        keys.append(i.strip('\n'))
    return keys
def vals():
    f = open("output/hex_colors.txt",'r')
    vals = []
    for i in f:
        vals.append(i.strip('\n'))
    return vals