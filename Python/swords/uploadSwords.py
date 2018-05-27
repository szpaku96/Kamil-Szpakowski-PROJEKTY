import cv2
import urllib.request
import numpy as np

swords = 0

for url in open("sabre_imagenet.synset.txt").readlines():
    if(swords<11):
        print(url)
        try:
            req = urllib.request.urlopen(url)
        except:
            continue

        arr = np.asarray(bytearray(req.read()),dtype = np.uint8)
        img = cv2.imdecode(arr,-1)
        if img is not None:
            cv2.imwrite("sword" + str(swords)+".jpg",img)
            cv2.imshow('iloveswords',img)
            cv2.waitKey()
            swords+=1



