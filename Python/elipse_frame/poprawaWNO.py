#8S1Sj3
import matplotlib.pyplot as plt
import random
from matplotlib.patches import Ellipse
import math

def createPoints(numPoints):

    points = []

    for i in range(0, numPoints):
        points.append([])
        x = random.randint(10, 200)
        y = random.randint(10, 200)
        a = random.randint(20, 40)
        b = random.randint(20, 40)
        alfa = random.randint(0, 180)
        points[i].append(x)
        points[i].append(y)
        points[i].append(a)
        points[i].append(b)
        points[i].append(alfa)

    return points


def elipsePoints(points,numPoints):

    x = []
    y = []

    for index in range(0,numPoints):
        x0 = points[index][0]
        y0 = points[index][1]
        a = points[index][2]
        b = points[index][3]
        alfa = points[index][4]

        for i in range(0,360,20):
            x.append((( a * math.cos(math.pi * i / 180)) * math.cos(math.pi * alfa / 180) - ( b * math.sin(math.pi * i / 180)) * math.sin(math.pi * alfa / 180))/2 + x0)
            y.append((( a * math.cos(math.pi * i / 180)) * math.sin(math.pi * alfa / 180) + ( b * math.sin(math.pi * i / 180)) * math.cos(math.pi * alfa / 180))/2 + y0)

    return x,y


def jarvis(x,y):

    punktyX = []
    punktyY = []
    minY = y[0]
    maxY = y[0]
    count = len(y)
    for l in range(0, count):
        if (y[l] < minY):  # szukamy najmniejszej i największej wartości Y
            minY = y[l]
            WspMinY = l
        if (y[l] > maxY):
            maxY = y[l]
            WspMaxY = l

    punktyX.append(x[WspMinY])
    punktyY.append(y[WspMinY])

    iteracje = 1
    koniec = 1
    # polowa algorytmu

    while (koniec != 0):
        startowyX = punktyX[iteracje - 1]  # zaczynając od punktu z najmnijeszą wartością Y
        startowyY = punktyY[iteracje - 1]

        if (startowyY == maxY):
            koniec = 0

        if (startowyY == y[0]):  # obliczamy kąty pomiędzy punktem startowym, każdym innym punktem
            angle = math.atan2((y[1] - startowyY), (x[1] - startowyX))  # i wybieramy najmniejszy
            if (angle < 0):
                angle = 2 * 3.145 + angle
            else:
                angle = angle
        else:
            angle = math.atan2((y[0] - startowyY), (x[0] - startowyX))
            if (angle < 0):
                angle = 2 * 3.145 + angle
            else:
                angle = angle
        n = 0
        for n in range(0, count):
            if (startowyY != y[n]):
                angle2 = math.atan2((y[n] - startowyY), (x[n] - startowyX))
                if (angle2 < 0):
                    angle2 = 2 * 3.145 + angle2
                else:
                    angle2 = angle2
                if (angle2 < angle):
                    angle = angle2
                    WspAngle = n
            else:
                angle2 = 1000
        punktyX.append(x[WspAngle])
        punktyY.append(y[WspAngle])
        iteracje = iteracje + 1

    koniec1 = 1
    while (koniec1 != 0):
        startowyX = punktyX[iteracje - 1]
        startowyY = punktyY[iteracje - 1]

        if (startowyY == minY):
            koniec1 = 0

        if (startowyY == y[0]):
            angle = math.atan2((y[1] - startowyY), (x[1] - startowyX))
            angle = angle + 3.1415
        else:
            angle = math.atan2((y[0] - startowyY), (x[0] - startowyX))
            angle = angle + 3.1415
        n = 0
        for n in range(0, count):
            if (startowyY != y[n]):
                angle2 = math.atan2((y[n] - startowyY), (x[n] - startowyX))
                angle2 = angle2 + 3.1415
                if (angle2 < angle):
                    angle = angle2
                    WspAngle = n
            else:
                angle2 = 1000
        punktyX.append(x[WspAngle])
        punktyY.append(y[WspAngle])
        iteracje = iteracje + 1

    plt.plot(x, y, 'k.')
    plt.plot(punktyX, punktyY, 'r--')
    plt.ylim((0, 230))
    plt.xlim((0, 230))
    plt.show()


def main():

    numPoints = 10
    punktyX = []
    punktyY = []

    points = createPoints(numPoints)

    for i in range(0, numPoints):
        ax = plt.gca()
        plt.plot(points[i][0], points[i][1], 'r*', markersize=12)
        ells = Ellipse(xy=(points[i][0], points[i][1]), width=points[i][2], height=points[i][3], angle=points[i][4], edgecolor='b', fill = True, lw=2)
        ax.add_patch(ells)

    x,y = elipsePoints(points,numPoints)
    jarvis(x,y)

main()
