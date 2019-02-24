from keras.models import Sequential
from keras.layers import Dense
from matplotlib import pyplot as plt
import numpy as np
import tensorflow as tf
import keras
import math

def neuron():
    colors = ['r', 'g', 'b', 'y', 'c', 'm', 'C9', 'C0', 'C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8']
    file = open("results.txt", "r")
    x,y,index = np.loadtxt("results.txt",  unpack=True)
    coords = []

    for i in range(5000):
        coords.append([])
        coords[i].append(x[i]/1000000)
        coords[i].append(y[i]/1000000)
        coords[i].append(index[i])

    coords = np.asarray(coords)
    input = coords.copy()

    np.random.shuffle(input)

    train_set = input[:4000, :2]
    train_labels = input[:4000, 2]

    test_set = input[4000:, :2]
    test_labels = input[4000:, 2]

    model = keras.models.Sequential([
        # keras.layers.Flatten(input_shape=(2,)),
        keras.layers.Dense(7, activation=tf.nn.relu, input_dim=2),
        keras.layers.Dense(15, activation=tf.nn.softmax)
    ])

    model.compile(optimizer=tf.train.AdamOptimizer(),
                  loss='sparse_categorical_crossentropy',
                  metrics=['accuracy'])

    model.fit(train_set, train_labels, epochs=200, batch_size=32)

    test_loss, test_acc = model.evaluate(test_set, test_labels)
    y = model.predict(test_set, verbose=16)

    results = np.zeros((1000, 3), dtype=float)
    for i in range(0, 1000):
        ind = np.argmax(y[i]) + 1
        results[i] = [test_set[i, 0], test_set[i, 1], ind]

    for i in range(0, 1000):
        plt.plot(results[i][0], results[i][1], colors[int(results[i][2])]+'o')
    plt.title('Neural Network')
    plt.show()


neuron()

    # x1 = []
    # y1 = []
    #
    # for i in range(0,1000):
    #     x1.append(test_set[i][0])
    #     y1.append(test_set[i][1])
    #
    # print(x1)
    # centerX=[]
    # centerY=[]
    # centroids=[]
    # centers = [240000, 840000, 420000, 780000, 670000, 850000, 825000, 720000, 140000, 540000, 340000, 560000, 610000,
    #            560000, 850000, 540000, 175000, 350000, 400000, 390000, 620000, 400000, 805000, 320000, 325000, 160000,
    #            500000, 170000, 850000, 150000]
    #
    # for i in range(0, 15):
    #     centerX.append(centers[2*i]/1000000)
    #     centerY.append(centers[2*i + 1]/1000000)
    #     centroids.append([])
    #
    # for iterations in range(1):
    #     for i in range(0000,1000):
    #         distMin = math.inf
    #         indexMin = 0
    #         for j in range(0, 15):
    #             dist = math.hypot(x1[i] - centerX[j], y1[i] - centerY[j])
    #             if dist < distMin:
    #                 distMin = dist
    #                 indexMin = j
    #         centroids[indexMin].append(i)
    #    # for k in range(15):
    #        # centerX[k] = (np.sum([centroids[k]]) / len([centroids[k]]))
    #         #centerY[k] = (np.sum([centroids[k]]) / len([centroids[k]]))
    #
    #     for i in range(15):
    #         plt.plot(x1[[centroids[i]]], [centroids[i]], colors[i] + 'o')
    #
    # #plt.plot(centerX,centerY,'ro')
    # plt.axis("equal")
    # plt.show()


