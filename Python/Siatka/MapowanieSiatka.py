import cv2
import glob
import numpy as np

images = []
NE = []
EA = []

for item in glob.glob("*.*"): # wczytujemy jpg z folderu
    images.append(item) # dodajemy je do wektora

for i in range (0,9):
    EA.append(images[i]) # pierwsze 9 to EA nastepne 4 to NE
    image = cv2.imread(EA[i], -1)
    height = np.shape(image)[0]
    width = np.shape(image)[1]
    wsp = 15 ## im wiekszy tym mniejsza siatka, oznacza ile pikseli na kratke, działa bardzo dobrze dla 30 lub 15 pikseli
    scaleH = height / wsp # szerokosc / dlugosc kratki  = ilosc lini poziomych, nizej analogicznie pionowe
    scaleW = width / wsp

    for k in range(0,int(scaleW)+1): ## rysowanie linii pionowych
        cv2.line(image,(0+int(wsp)*k,0),(0+int(wsp)*k,height),(0,0,255),1)

    for l in range(0,int(scaleH)+1): # rysowanie linii poziomych
        cv2.line(image,(0,17+int(wsp)*l),(width,17+int(wsp)*l),(0,0,255),1)

    cv2.imshow('EA', image)
    cv2.waitKey(0)
    #cv2.imwrite("EA" + str(i) + ".jpg", image)  # odkomentować, żeby zapisac nowe zdjęcia dla nowej rozdzielczości siatki


for j in range (0,4):
    NE.append(images[j+9]) # pozostałe plany, reszta analogicznie jak dla EA
    image2 = cv2.imread(NE[j],-1)
    height2 = np.shape(image2)[0]
    width2 = np.shape(image2)[1]
    wsp2 = 20 # trzeba będzie dobrać współczynnik
    scaleH2 = height2 / wsp2
    scaleW2 = width2 / wsp2
    for k in range(0,int(scaleW2)+1): ## rysowanie pionowe
        cv2.line(image2,(0+int(wsp2)*k,0),(0+int(wsp2)*k,height2),(0,0,255),1)
    for l in range(0,int(scaleH2)+1):
        cv2.line(image2,(0,0+int(wsp2)*l),(width2,0+int(wsp2)*l),(0,0,255),1)
    cv2.imshow('NE',image2)
    cv2.waitKey(0)
    #cv2.imwrite("NE" + str(j) + ".jpg", image2)  # odkomentować, żeby zapisac nowe zdjęcia dla nowej rozdzielczości siatki
cv2.destroyAllWindows()


