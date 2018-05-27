# Kamil Szpakowski
# Jeden z pierwszych programów w jezyku Python
# Problem convexhull
# implementacja algorytmu Jarvisa

import matplotlib.pyplot as plt
import random
import math

x = []
y = []
punktyX = []
punktyY = []


for n in range(0, 50):     # losujemy współrzędne x i Y
    x.append(random.randint(0, 1000))
    y.append(random.randint(0, 1000))


minY = y[0]
maxY = y[0]

for l in range(0, 50):
    if (y[l] < minY):   # szukamy najmniejszej i największej wartości Y
        minY = y[l]
        WspMinY = l
    if(y[l] > maxY):
        maxY= y[l]
        WspMaxY = l

punktyX.append(x[WspMinY])
punktyY.append(y[WspMinY])

iteracje = 1
koniec = 1
# polowa algorytmu

while(koniec!=0):
    startowyX=punktyX[iteracje-1] # zaczynając od punktu z najmnijeszą wartością Y
    startowyY=punktyY[iteracje-1]

    if(startowyY == maxY):
        koniec=0

    if (startowyY == y[0]):         # obliczamy kąty pomiędzy punktem startowym, każdym innym punktem
        angle = math.atan2((y[1] - startowyY), (x[1] - startowyX)) # i wybieramy najmniejszy
        if (angle < 0):
            angle = 2*3.145 + angle
        else:
            angle=angle
    else:
        angle = math.atan2((y[0] - startowyY), (x[0] - startowyX))
        if (angle < 0):
            angle = 2*3.145 + angle
        else:
            angle=angle
    n=0
    for n in range(0, 50):
        if (startowyY != y[n]):
            angle2=math.atan2((y[n]-startowyY),(x[n]-startowyX))
            if(angle2<0):
                angle2=2*3.145+angle2
            else:
                angle2=angle2
            if(angle2<angle):
                angle = angle2
                WspAngle = n
        else:
            angle2=1000;
    punktyX.append(x[WspAngle])
    punktyY.append(y[WspAngle])
    iteracje = iteracje+1


koniec1=1
while(koniec1!=0):
    startowyX=punktyX[iteracje-1]
    startowyY=punktyY[iteracje-1]

    if(startowyY == minY):
        koniec1=0

    if (startowyY == y[0]):
        angle = math.atan2((y[1] - startowyY), (x[1] - startowyX))
        angle = angle + 3.1415
    else:
        angle = math.atan2((y[0] - startowyY), (x[0] - startowyX))
        angle = angle + 3.1415
    n=0
    for n in range(0, 50):
        if ( startowyY != y[n] ) :
            angle2=math.atan2((y[n]-startowyY),(x[n]-startowyX))
            angle2=angle2 + 3.1415
            if(angle2<angle):
                angle = angle2
                WspAngle = n
        else:
            angle2=1000
    punktyX.append(x[WspAngle])
    punktyY.append(y[WspAngle])
    iteracje=iteracje+1


plt.plot(x,y, 'k.')
plt.plot(punktyX,punktyY, 'r--')
plt.show()
