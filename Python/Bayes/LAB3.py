import matplotlib.pyplot as plt
import csv
import math

Ax = []
Ay = []
Bx = []
By = []

radius = 1
newx = 2
newy = 4

with open('D:\Python\PycharmProjects\ASEIE\data2.csv', newline='') as csvfile: # wczytanie z csv
    spamreader = csv.reader(csvfile, delimiter='|')
    for row in spamreader:
        x, y = row
        Bx.append(x)
        By.append(y)

with open('D:\Python\PycharmProjects\ASEIE\data1.csv', newline='') as csvfile:
    spamreader = csv.reader(csvfile, delimiter='|')
    for row in spamreader:
        x, y = row
        Ax.append(x)
        Ay.append(y)


def convert():
    for i in range(0, len(Bx)):
        Bx[i] = float(Bx[i]) # zamiana z stringa na floata
        By[i] = float(By[i])

    for i in range(0, len(Ax)):
        Ax[i] = float(Ax[i])
        Ay[i] = float(Ay[i])


def check2(radius):
    neighbours2 = 0
    while neighbours2 < 1: # do poki nie znajdziemy sasiada
        if neighbours2 == 0:
            for i in range(0, len(Bx)):    # dla kazdego elementu
                if math.sqrt((Bx[i]-newx)**2 + (By[i]-newy)**2) < radius: # sprawdzamy czy lezy w srodku okregu
                    neighbours2 += 1
            if neighbours2 == 0: # jezeli nie znalazl punktu, to zwiekszamy promien i powtarzamy
                radius += 0.25
                print(radius)
    return neighbours2/len(Bx)


def check1(radius,newx,newy):
    neighbours1 = 0
    while neighbours1 < 1:
        if neighbours1 == 0:
            for i in range(0, len(Ax)):
                if math.sqrt((Ax[i] - newx) ** 2 + (Ay[i] - newy) ** 2) < radius:
                    neighbours1 += 1
            if neighbours1 == 0:
                radius += 0.25
                print(radius)
    return neighbours1/len(Ax)


def bayes(radius, newx, newy):
    neighbours1 = check1(radius,newx,newy)
    neighbours2 = check2(radius)

    apriori_1 = len(Ax)/(len(Ax)+len(Bx))
    apriori_2 = len(Bx)/(len(Ax)+len(Bx))

    prob1 = neighbours1 * apriori_1
    prob2 = neighbours2 * apriori_2

    if prob1 > prob2:
        Ax.append(newx)
        Ay.append(newy)
    else:
        Bx.append(newx)
        By.append(newy)


convert()
bayes(radius,newx,newy)
fig = plt.figure(1)
ax = fig.add_subplot(1, 1, 1)
circ = plt.Circle((newx, newy), radius=0.1, color='black', fill=False)
ax.add_patch(circ)
circ2 = plt.Circle((newx, newy), radius=1, color='black', fill=False)
ax.add_patch(circ2)
#plt.axis([0,10,0,10])
plt.plot(Ax, Ay, 'bo')
plt.plot(Bx, By, 'ro')
plt.show()
