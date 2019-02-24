import numpy as np
import matplotlib.pyplot as plt
import math

def kmeans():
    x, y = np.loadtxt("s1.txt", unpack=True)
    colors = ['r', 'g', 'b', 'y', 'c', 'm', 'C9', 'C0', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8']
    centerX = []
    centerY = []
    centers = [240000, 840000, 420000, 780000, 670000, 850000,825000, 720000, 140000, 540000,340000, 560000,610000, 560000,850000, 540000,175000, 350000,400000, 390000,620000, 400000,805000, 320000,325000, 160000,500000, 170000,850000, 150000]
    centroids = []

    for i in range (0,15):
        centerX.append(centers[2*i])
        centerY.append(centers[2*i + 1])
        centroids.append([])

    for iterations in range(10):
        for i in range(0,5000):
            distMin = math.inf
            indexMin = 0
            for j in range(0,15):
                dist = math.hypot(x[i]-centerX[j],y[i]-centerY[j])
                if dist < distMin:
                    distMin = dist
                    indexMin = j
            centroids[indexMin].append(i)
        for k in range(15):
            centerX[k]=(np.sum(x[centroids[k]]) / len(x[centroids[k]]))
            centerY[k]=(np.sum(y[centroids[k]]) / len(y[centroids[k]]))

        # w centroids[1] siedza wszystkie indeksy ktore naleza do pierwszego klasra
    for i in range(15):
        plt.plot(x[centroids[i]], y[centroids[i]],'.',color = colors[i])
    plt.title("Kmeans")
    plt.plot(centerX,centerY,'ro')
    plt.show()

kmeans()