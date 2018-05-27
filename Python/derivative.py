#Kamil Szpakowski
# Program do obliczania pochodnej ze wzoru
# f'(x) = ( f(x+h)- f(x-h) )/ 2h
# dla różnych wartości parametru h i
# f(x) = arctan(x), w punkcie x = 0.5


import numpy as np
from matplotlib import pyplot as plt

def derivative(x,k):
    h = np.ones(k) * 2
    five = np.ones(k)*5
    five = np.cumprod(five)
    h = (h /five)
    deriv = (np.arctan(x+h) - np.arctan(x-h)) / (2 * h)
    realderiv = (1/(1+(x*x)))
    absolut = np.abs(realderiv - deriv)
    print("                        h                  pochodna                  błąd")

    for i in range (0, k):
        print(repr(h[i]).rjust(25), repr(deriv[i]).rjust(25), repr(absolut[i]).rjust(25))

    plt.figure()
    plt.xlabel("x")
    plt.ylabel("y")
    plt.title("pochodna")
    plt.plot(h,absolut,'X')
    plt.xscale('log')
    plt.yscale('log')

    min = np.min(absolut)
    print(min)
    minindex = np.where(min==absolut)[0][0]
    print(minindex)
    plt.show()


derivative(0.5,20)