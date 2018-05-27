# Kamil Szpakowski
# program służący do nałożenia siatki
# oraz ponumerowanie segmentów
# nowego budynku wydziału ETI

import cv2
import glob
import numpy as np

class Siatka:

    images = []
    NE = []

    font = cv2.FONT_HERSHEY_SIMPLEX
    fontScale = 0.5
    fontColor = (255, 0, 0)
    lineType = 1
    wsp = 31
    index = 30

    def __init__(self):

        for j in range(0, 3):
            self.NE.append(self.images[j])
            self.image2 = cv2.imread(self.NE[j], -1)


            res = cv2.resize(self.image2, None, fx=2, fy=2, interpolation=cv2.INTER_CUBIC)  # powiększenie obrazów
            reshelp = cv2.resize(self.image2, (2500, 2500), cv2.INTER_LINEAR)

            rows = res.shape[0]
            cols = res.shape[1]
            rows2 = reshelp.shape[0]
            cols2 = reshelp.shape[1]

            temp = res[0:rows, 0:cols]
            reshelp[0:rows, 0:cols] = temp

            if j == 0:
                self.parterSiatka(reshelp)
                self.numeracjaParter(reshelp)
                SiatkaParter = reshelp[0:rows, 0:cols]
                cv2.imshow('final', SiatkaParter)
                cv2.waitKey(0)

            if j > 0:
                self.siatka2(reshelp)
                self.numeracjaPieter(reshelp)

                M = cv2.getRotationMatrix2D((cols2 / 2, rows2 / 2), 330, 1)  # 330
                dst = cv2.warpAffine(reshelp, M, (cols2, rows2))

                self.siatka3(dst)
                self.numeracjaPieter2(dst)

                M = cv2.getRotationMatrix2D((cols2 / 2, rows2 / 2), 60, 1)
                img2 = cv2.warpAffine(dst, M, (cols2, rows2))

                self.siatka4(img2)
                self.numeracjaPieter3(img2,j)

                M = cv2.getRotationMatrix2D((cols2 / 2, rows2 / 2), -30, 1)
                finish = cv2.warpAffine(img2, M, (cols2, rows2))

                SiatkaNE = finish[0:rows, 0:cols]
                cv2.imshow('final', SiatkaNE)
                cv2.waitKey(0)
                self.index = 30

        cv2.destroyAllWindows()


    for item in glob.glob("D:\\Python\\PlanyNE\\*"): # wczytujemy jpg z folderu
        images.append(item) # dodajemy je do wektora

    def parterSiatka(self,reshelp):
        for k in range(0, 37):  ## rysowanie linii pionowych
            cv2.line(reshelp, (600 + int(self.wsp) * k, 600), (600 + int(self.wsp) * k, 1547), (0, 0, 255), 1)

        for l in range(0, 30):  # rysowanie linii poziomych
            cv2.line(reshelp, (550 - 31, int(self.wsp) * l + 600), (1711, int(self.wsp) * l + 600), (0, 0, 255), 1)

    def numeracjaParter(self,reshelp):
        STARTX = 605 - 36
        STARTY = 618
        indexP = 1

        bottomLeftCornerOfTextX = STARTX
        bottomLeftCornerOfTextY = STARTY
        bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

        for g in range(1, 30):
            for i in range(1, 34):
                bottomLeftCornerOfTextX = bottomLeftCornerOfTextX + 31
                bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)
                cv2.putText(reshelp, str(indexP), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                indexP += 1

            bottomLeftCornerOfTextY = bottomLeftCornerOfTextY + 31
            bottomLeftCornerOfTextX = STARTX
            bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

    def siatka2(self,reshelp):
        for k in range(0, 30):  ## rysowanie linii pionowych
            cv2.line(reshelp, (625 + int(self.wsp) * k, 615), (625 + int(self.wsp) * k, 863), (0, 0, 255), 1)

        for l in range(0, 9):  # rysowanie linii poziomych
            cv2.line(reshelp, (625, int(self.wsp) * l + 615), (1524, int(self.wsp) * l + 615), (0, 0, 255), 1)

    def numeracjaPieter(self,reshelp):
        STARTX = 594
        STARTY = 640
        self.index = 30

        bottomLeftCornerOfTextX = STARTX
        bottomLeftCornerOfTextY = STARTY
        bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

        for g in range(1, 9):
            for i in range(1, 30):
                bottomLeftCornerOfTextX = bottomLeftCornerOfTextX + 31
                bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)
                cv2.putText(reshelp, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                self.index += 1

            bottomLeftCornerOfTextY = bottomLeftCornerOfTextY + 31
            bottomLeftCornerOfTextX = STARTX
            bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)



    def siatka3(self,dst):
        for k in range(0, 30):  ## rysowanie linii pionowych
            cv2.line(dst, (146 + int(self.wsp) * k, 690 - 2 * 31), (146 + int(self.wsp) * k, 1463), (0, 0, 255), 1)

        for l in range(0, 28):  # rysowanie linii poziomych
            cv2.line(dst, (146, int(self.wsp) * l + 690 - 2 * 31), (1050, int(self.wsp) * l + 690 - 2 * 31), (0, 0, 255), 1)

    def numeracjaPieter2(self,dst):
        STARTX = 115
        STARTY = 706


        bottomLeftCornerOfTextX = STARTX
        bottomLeftCornerOfTextY = STARTY
        bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

        for g in range(1, 24):
            for i in range(1, 30):
                bottomLeftCornerOfTextX = bottomLeftCornerOfTextX + 31
                bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)
                if  g < 9 and i < 5:
                    cv2.putText(dst, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                    self.index += 1
                elif i > 19:
                    cv2.putText(dst, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                    self.index += 1
                elif g >= 8 and g < 14 and i < 20:
                    cv2.putText(dst, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                    self.index += 1

            bottomLeftCornerOfTextY = bottomLeftCornerOfTextY + 31
            bottomLeftCornerOfTextX = STARTX
            bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

    def siatka4(self,img2):
        for k in range(0, 29):  ## rysowanie linii pionowych
            if k < 3:
                cv2.line(img2, (1190 + int(self.wsp) * k, 800), (1190 + int(self.wsp) * k, 1447), (0, 0, 255), 1)
            elif k >= 3:
                cv2.line(img2, (1190 + int(self.wsp) * k, 800), (1190 + int(self.wsp) * k, 1547), (0, 0, 255), 1)
        cv2.line(img2, (1190 - 31, 850), (1190 - 31, 1447), (0, 0, 255), 1)

        for l in range(0, 24):  # rysowanie linii poziomych
            cv2.line(img2, (1190 - 31, int(self.wsp) * l + 800), (2011, int(self.wsp) * l + 800), (0, 0, 255), 1)

    def numeracjaPieter3(self,img2,j):
        STARTX = 1220
        STARTY = 820

        bottomLeftCornerOfTextX = STARTX
        bottomLeftCornerOfTextY = STARTY
        bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

        for g in range(1, 25):
            for i in range(1, 28):
                if i < 8 and i < 23:
                    if self.index == 899 and j == 1:
                        continue
                    elif self.index == 908 and j == 2:
                        continue
                    else:
                        cv2.putText(img2, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                        self.index += 1

                elif g > 11 and g < 18 and j == 1 and i < 23:
                    cv2.putText(img2, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                    self.index += 1

                elif g > 7 and g <= 11 and i > 17 and j == 1 and i < 23:
                    cv2.putText(img2, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                    self.index += 1
                elif j == 2 and g > 9 and g <= 15 and i > 7:
                    cv2.putText(img2, str(self.index), (bottomLeftCornerOfText), self.font, self.fontScale, self.fontColor, self.lineType)
                    self.index += 1

                bottomLeftCornerOfTextX = bottomLeftCornerOfTextX + 31
                bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)


            bottomLeftCornerOfTextY = bottomLeftCornerOfTextY + 31
            bottomLeftCornerOfTextX = STARTX
            bottomLeftCornerOfText = (bottomLeftCornerOfTextX, bottomLeftCornerOfTextY)

h = Siatka()

