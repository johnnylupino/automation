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
    page.screenshot(path="screenhshot-with-path.png")
    read_image()

def read_image():
    image = "screenhshot-with-path.png"
    image = cv2.imread(image)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)