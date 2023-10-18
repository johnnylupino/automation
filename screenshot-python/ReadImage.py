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
def open_the_web(): 
    browser.goto("http://www.kermeet.pl")
    page = browser.page()
    page.screenshot(path="screenhshot-with-path.png",full_page=True,scale="css")
    read_image()
    color_analysis()

def read_image(): 
    image = "screenhshot-with-path.png"  
    image = cv2.imread(image)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    modified_img = image.reshape(image.shape[0]*image.shape[1], 3)
    return modified_img

def rgb_to_hex(rgb_color):
    hex_color = "#"
    for i in rgb_color:
        i = int(i)
        hex_color += ("{:02x}".format(i))
    return hex_color

def color_analysis():
    #https://towardsdatascience.com/building-an-image-color-analyzer-using-python-12de6b0acf74
    modified_img = read_image()
    clf = KMeans(n_clusters = 5)
    color_labels = clf.fit_predict(modified_img)
    center_colors = clf.cluster_centers_
    counts = Counter(color_labels)
    ordered_colors = [center_colors[i] for i in counts.keys()]
    hex_colors = [rgb_to_hex(ordered_colors[i]) for i in counts.keys()]
    plt.figure(figsize = (12, 8))
    plt.pie(sorted(counts.values()), labels = hex_colors, colors = hex_colors)
    plt.savefig("analyzed_image.png")
    build_dictionary(keys=keys(),vals=hex_colors)

def keys():
    f = open("variables.txt",'r')
    keys = []
    for i in f:
        keys.append(i.strip('\n'))
    return keys

def build_dictionary(keys,vals):
    cols = dict(map(lambda i,j : (i,j) , keys,vals))
    return cols
