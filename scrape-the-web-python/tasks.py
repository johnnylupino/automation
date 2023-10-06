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

site_name = "http://www.kermeet.pl"
output_image = "output/screenshot.png"
analyzed_image = "output/color_analysis_report.png"
output_colors = "output/output_colors.txt"
variables_file = "devdata/variables.txt"
theme_config_json =  "devdata/theme-config.json"
theme_config_json_updated = "output/theme-config-updated.json"

@task
def open_web_and_screenshot():
    open_the_web()
    image_analysis()
    f = build_dictionary(keys=keys(),vals=vals())
    find_in_json_and_replace(colors_dictionary=f)
    

def open_the_web():
    browser.goto(site_name)
    page = browser.page()
    page.screenshot(path=output_image,full_page=True, scale="css",omit_background=False)
    
    
    #https://towardsdatascience.com/building-an-image-color-analyzer-using-python-12de6b0acf74
if output_image:
    image = cv2.imread(output_image)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
else:
    print("no screenshot found")
    
def rgb_to_hex(rgb_color):
    hex_color = "#"
    for i in rgb_color:
        i = int(i)
        hex_color += ("{:02x}".format(i))
    return hex_color

def prep_image(raw_img):
    #modified_img = cv2.resize(raw_img, (400, 250), interpolation = cv2.INTER_AREA)
    modified_img = raw_img.reshape(raw_img.shape[0]*raw_img.shape[1], 3)
    return modified_img

def color_analysis(img):
    clf = KMeans(n_clusters = 5)
    color_labels = clf.fit_predict(img)
    center_colors = clf.cluster_centers_
    counts = Counter(color_labels)
    ordered_colors = [center_colors[i] for i in counts.keys()]
    hex_colors = [rgb_to_hex(ordered_colors[i]) for i in counts.keys()]
    plt.figure(figsize = (12, 8))
    plt.pie(sorted(counts.values()), labels = hex_colors, colors = hex_colors)
    plt.savefig(analyzed_image)
    files = [f for f in pathlib.Path().glob(output_colors)]
    if len(files) > 0:
        os.remove(output_colors)
        write_to_output_colors(hex_colors)
    else:
        write_to_output_colors(hex_colors)

def image_analysis():
    modified_image = prep_image(image)
    color_analysis(modified_image)

def write_to_output_colors(colors):
    f = open(output_colors, 'a')
    for hex in colors:
        f.write(hex + '\n')
    f.close()

def keys():
    f = open(variables_file,'r')
    keys = []
    for i in f:
        keys.append(i.strip('\n'))
    return keys
def vals():
    f = open(output_colors,'r')
    vals = []
    for i in f:
        vals.append(i.strip('\n'))
    return vals
def build_dictionary(keys,vals):
    cols = dict(map(lambda i,j : (i,j) , keys,vals))
    #print(cols)
    return cols

def find_in_json_and_replace(colors_dictionary):
    """gets theme-config.json, finds color variables and matches them again cols dictionary
    from build_dictionary function"""
    shutil.copy2(theme_config_json, theme_config_json_updated)
    search_variables(colors_dictionary)


def search_variables(colors_dictionary):
    f = open(theme_config_json, 'r')
    d = json.load(f)
    json_dict = d['colors'][0]
    json_dict.update(colors_dictionary)
    print(json_dict)
    with open(theme_config_json_updated,'w') as updated_file:
        json.dump(d, updated_file)
        f.close()
    print(updated_file)



