# Kamil Szpakowski
# Trzy algorytmy do sortowania tablicy danych
# bubble sort, selection sort oraz quicksort

import numpy as np
import random
import time


def generowanie():
    tab = []
    elements = 500
    for i in range (elements):
        rand = random.randint(0, 1000)
        tab.append(rand)
    print("Wygenerowana tablica:")
    print(tab)
    print("Ilość elementów : ", elements, "\n")
    return tab


def babelkowy(tab):
    length = len(tab)
    index = length

    while index > 1: # zaczynamy od konca tablicy
        if tab[index - 1] < tab[index - 2]: # porownujemy ze sobą dwa sąsiednie elementy
            bufor = tab[index - 1]    # jezeli wartośc tablicy o starszym indeksie jest mniejsza
            tab[index - 1] = tab[index - 2] # od tej o młodszym, to zamieniamy
            tab[index - 2] = bufor
            index = length
        else:
            index -= 1 # w przeciwnym wypadku, zostawiamy

    return tab


def selection_sort(tab): # szukamy kolejnych najmniejszych elementow tablicy i ustawiamy je po kolei
    length = len(tab)
    index = 0
    smallest_index = 0

    while index < (length - 1):
        smallest = tab[index]

        for i in range(index, length):
            if tab[i] <= smallest:
                smallest = tab[i]
                smallest_index = i

        bufor = tab[index]
        tab[smallest_index] = bufor
        tab[index] = smallest
        index += 1

    return tab

def quicksort(tab):

    length = len(tab)
    left = []
    equal = []
    right = []

    if len(tab) > 1:
        for index in tab:    # dla kazdego elementu w tablicy
            pivot = tab[0]   # pivot ustawiamy jako pierwszy element
            if index < pivot:   # tworzymy trzy tablice
                left.append(index) # jedna zawiera elementy mniejsze od pivotu
            elif index > pivot:  # druga elementy większe
                right.append(index)
            elif index == pivot: # trzecia równe
                equal.append(index)

        return quicksort(left)+equal+quicksort(right) # algorytm rekurencyjny

    else:
        return tab

# bombelkowy
def output_bombelkowy():
    start = time.time()
    bubble = babelkowy(tablica)
    koniec = time.time() - start
    print("Tablica posortowana przy użyciu algorytmu bombelkowego")
    print(bubble)
    print("Czas sortowania przy użyciu algorytmu bombelkowego ", koniec, "\n")

#selection sort
def output_selectionsort():
    start = time.time()
    selection = selection_sort(tablica)
    koniec = time.time() - start
    print("Tablica posortowana przy użyciu algorytmu selection_sort")
    print(selection)
    print("Czas sortowania przy użyciu algorytmu selection sort ", koniec, "\n")

#quicksort
def output_quicksort():
    start = time.time()
    check_quicksort = quicksort(tablica)
    koniec = time.time() - start
    print("Tablica posortowana przy użyciu algorytmu quicksort")
    print(check_quicksort)
    print("Czas sortowania przy użyciu algorytmu quicksort ", koniec, "\n")

tablica = generowanie()
output_bombelkowy()
output_selectionsort()
output_quicksort()