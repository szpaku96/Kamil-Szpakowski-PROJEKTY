from matplotlib import pyplot as plt
import numpy as np
import math
from mpl_toolkits.mplot3d import Axes3D
import tensorflow as tf
import keras
import skfuzzy as fuzz


def kmeans():

    x1, x2, x3, x4, x5, x6, x7, x8, x9 = np.loadtxt("breast.txt", unpack=True)
    alldata = np.vstack((x1, x2, x3, x4, x5, x6, x7, x8, x9))
    lenght = len(x1)
    center1 = [1, 1, 1, 1, 1, 1, 1, 1, 1]
    center2 = [10, 10, 10, 10, 10, 10, 10, 10, 10]
    iterations = 10
    centroid1 = []
    centroid2 = []

    for j in range(20):
        centroid1 = []
        centroid2 = []
        for i in range(0, lenght):
            a = 0
            b = 0
            for k in range(0, 9):
                a += math.pow((alldata[k][i] - center1[k]), 2)
                b += math.pow((alldata[k][i] - center2[k]), 2)
            if a > b:
                centroid1.append(i)
            else:
                centroid2.append(i)

        for k in range(9):
            center1[k] = np.sum(alldata[k][centroid1]) / len(centroid1)
            center2[k] = np.sum(alldata[k][centroid2]) / len(centroid2)

    return centroid1, centroid2


def neuralNetwork(centroid1, centroid2):

    x1, x2, x3, x4, x5, x6, x7, x8, x9 = np.loadtxt("breast.txt", unpack=True)
    alldata = np.vstack((x1, x2, x3, x4, x5, x6, x7, x8, x9))
    lenght = len(x1)
    index = []
    for i in range(lenght):
        index.append(0)

    for i in range(len(centroid1)):
        index[centroid1[i]] = 1

    for i in range(len(centroid2)):
        index[centroid2[i]] = 2

    coords = []

    for i in range(lenght):
        coords.append([])
        coords[i].append(x1[i])
        coords[i].append(x2[i])
        coords[i].append(x3[i])
        coords[i].append(x4[i])
        coords[i].append(x5[i])
        coords[i].append(x6[i])
        coords[i].append(x7[i])
        coords[i].append(x8[i])
        coords[i].append(x9[i])
        coords[i].append(index[i])

    coords = np.asarray(coords)
    input = coords.copy()

    np.random.shuffle(input)

    train_set = input[:500, :9]
    train_labels = input[:500, 9]

    test_set = input[500:, :9]
    test_labels = input[500:, 9]

    print(train_set)
    print("#######################################")

    model = keras.models.Sequential([
        # keras.layers.Flatten(input_shape=(2,)),
        keras.layers.Dense(7, activation=tf.nn.relu, input_dim=9),
        keras.layers.Dense(15, activation=tf.nn.softmax)
    ])

    model.compile(optimizer=tf.train.AdamOptimizer(),
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    model.fit(train_set, train_labels, epochs=200, batch_size=32)

    test_loss, test_acc = model.evaluate(test_set, test_labels)
    y = model.predict(test_set, verbose=16)

    idkLen = lenght - 500

    results = np.zeros((idkLen, 10), dtype=float)
    for i in range(0, idkLen):
        ind = np.argmax(y[i])-1
        results[i] = [test_set[i, 0], test_set[i, 1], test_set[i, 2], test_set[i, 3], test_set[i, 4], test_set[i, 5],
                      test_set[i, 6], test_set[i, 7], test_set[i, 8], ind]

    return results


def fuzzy(centroid1,centroid2):
    x1, x2, x3, x4, x5, x6, x7, x8, x9 = np.loadtxt("breast.txt", unpack=True)
    alldata = np.vstack((x1, x2, x3, x4, x5, x6, x7, x8, x9))
    alldata_f_train = alldata[:9, 150:]
    alldata_f_test = alldata[:9, :150]
    num_centroid = 2

    cntr, u, u0, d, jm, p, fpc = fuzz.cluster.cmeans(
        alldata_f_train, num_centroid, 2, error=0.005, maxiter=10000, init=None)

    u, u0, d, jm, p, fpc = fuzz.cluster.cmeans_predict(
        alldata_f_test, cntr, 2, error=0.005, maxiter=1000)
    cluster_membership = np.argmax(u, axis=0)  # Hardening for visualization

    print(fpc)

    return cluster_membership,alldata_f_test


def main():
    fig = plt.figure()
    centroid1, centroid2 = kmeans()
    results = neuralNetwork(centroid1, centroid2)
    cluster_membership,alldata_f_test = fuzzy(centroid1,centroid2)

    colors = ['r', 'b']
    x1, x2, x3, x4, x5, x6, x7, x8, x9 = np.loadtxt("breast.txt", unpack=True)
    alldata = np.vstack((x1, x2, x3, x4, x5, x6, x7, x8, x9))


    ax = fig.add_subplot(331, projection='3d')
    ax.scatter(alldata[0][centroid1], alldata[1][centroid1], alldata[2][centroid1], c='r', marker='o')
    ax.scatter(alldata[0][centroid2], alldata[1][centroid2], alldata[2][centroid2], c='b', marker='o')

    ax = fig.add_subplot(332, projection='3d')
    plt.title("Kmeans")
    ax.scatter(alldata[3][centroid1], alldata[4][centroid1], alldata[5][centroid1], c='r', marker='o')
    ax.scatter(alldata[3][centroid2], alldata[4][centroid2], alldata[5][centroid2], c='b', marker='o')

    ax = fig.add_subplot(333, projection='3d')
    ax.scatter(alldata[6][centroid1], alldata[7][centroid1], alldata[8][centroid1], c='r', marker='o')
    ax.scatter(alldata[6][centroid2], alldata[7][centroid2], alldata[8][centroid2], c='b', marker='o')

    ax = fig.add_subplot(334, projection='3d')
    idkLen = len(x1)-500
    for i in range(0, idkLen-1):
        ax.scatter(results[i][0], results[i][1], results[i][2], color=colors[int(results[i][9])], marker='o')

    ax = fig.add_subplot(335, projection='3d')
    plt.title("Neural Network")

    for i in range(0, idkLen - 1):
        ax.scatter(results[i][3], results[i][4], results[i][5], color=colors[int(results[i][9])], marker='o')

    ax = fig.add_subplot(336, projection='3d')
    for i in range(0, idkLen - 1):
        ax.scatter(results[i][6], results[i][7], results[i][8], color=colors[int(results[i][9])], marker='o')

    ax = fig.add_subplot(337, projection='3d')
    ax.scatter(alldata_f_test[0][cluster_membership == 0], alldata_f_test[1][cluster_membership == 0],
               alldata_f_test[2][cluster_membership == 0], '.',
               color=colors[1])
    ax.scatter(alldata_f_test[0][cluster_membership == 1], alldata_f_test[1][cluster_membership == 1],
               alldata_f_test[2][cluster_membership == 1], '.',
               color=colors[0])

    ax = fig.add_subplot(338, projection='3d')
    plt.title("Fuzzy logic")
    ax.scatter(alldata_f_test[3][cluster_membership == 0], alldata_f_test[4][cluster_membership == 0],
               alldata_f_test[5][cluster_membership == 0], '.',
               color=colors[1])
    ax.scatter(alldata_f_test[3][cluster_membership == 1], alldata_f_test[4][cluster_membership == 1],
               alldata_f_test[5][cluster_membership == 1], '.',
               color=colors[0])

    ax = fig.add_subplot(339, projection='3d')
    ax.scatter(alldata_f_test[6][cluster_membership == 0], alldata_f_test[7][cluster_membership == 0],
               alldata_f_test[8][cluster_membership == 0], '.',
               color=colors[1])
    ax.scatter(alldata_f_test[6][cluster_membership == 1], alldata_f_test[7][cluster_membership == 1],
               alldata_f_test[8][cluster_membership == 1], '.',
               color=colors[0])

    plt.show()


main()