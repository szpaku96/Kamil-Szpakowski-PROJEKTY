# Kamil Szpakowski
# Program symuluję transmisję zgodną ze standardem RS232
# Dodatkowo umożliwia cenzurowanie wybranych słów

from PyQt5 import QtCore, QtWidgets
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
import binascii
import numpy as np
import sys


class MainWindow(QMainWindow):

    def __init__(self, encoding='utf-8'):  # GUI
        QMainWindow.__init__(self)
        self.setMinimumSize(QSize(800, 600))
        self.setWindowTitle("Architektura Systemów Komputerowych lab Zadanie 4")

        self.textbox = QLineEdit(self)
        self.textbox.move(50, 50)
        self.textbox.resize(300, 30)

        self.textbox2 = QLineEdit(self)
        self.textbox2.move(450, 50)
        self.textbox2.resize(300, 30)

        self.textbox3 = QLineEdit(self)
        self.textbox3.move(50, 250)
        self.textbox3.resize(700, 30)

        self.label = QLabel("Nadajnik", self)
        self.label.setFont(QFont('SansSerif', 13))
        self.label.move(150, 10)

        self.label = QLabel("Odbiornik", self)
        self.label.move(550, 10)
        self.label.setFont(QFont('SansSerif', 13))

        self.label = QLabel("Przekonwertowane", self)
        self.label.move(320, 200)
        self.label.resize(200, 30)
        self.label.setFont(QFont('SansSerif', 13))

        button1 = QPushButton('Transmisja', self)
        button1.clicked.connect(self.transmisja)
        button1.resize(150, 30)
        button1.move(325, 400)
        button1.setFont(QFont('SansSerif', 13))

    def transmisja(self, encoding='utf-8', errors='surrogatepass'):

        text = self.textbox.text()  # pobieramy tekst który będziemy wysyłać

        if text is not '':
            words = self.send(text)  # funkcja send konwertuje do odpowiedniej postaci i tworzy tablicę do przesłania
            self.receive(words)  # odbieranie i dekonwertowanie tablicy
        else:
            self.textbox3.setText('')
            self.textbox2.setText('')

    def send(self, text):

        char_ar = np.chararray([])  # zamieniamy string na char array
        char_ar = text
        word = []
        words = []

        for i in range(0, len(char_ar)):  # dla każdego znaku :
            a = self.text_to_bits(char_ar[i])  # zamiana jednego chara z ascii na binarny
            word.append('0')
            word += (list(reversed(a)))  # dodanie bitu startu i stopu oraz zamiana kolejnosci
            word.append('11')  # od najmniej znaczacego bitu, do najbardziej
            words = ''.join(word)

        self.textbox3.setText(words)
        return words

    def receive(self, words):
        all_data = []
        one_word = []
        number_of_chars = int(len(words) / 11)  # liczymy ile będziemy musieli odebrać znaków

        for i in range(0, number_of_chars):
            char_ar = []
            for j in range(0, 8):
                char_ar.append(words[
                                   11 * i + j + 1])  # pomijamy bity startu i stopu, pobieramy tylko 8 znaczących bitów i robimy z niego tablicę

            rev_char_ar = list(reversed(char_ar))  # odwracamy kolejność bitów
            ascii_char = self.text_from_bits(''.join(rev_char_ar))

            if ascii_char != ' ':  # jeżeli otrzymujemy znak inny niż spacja
                one_word.append(ascii_char)  # dodajemy go do słowa
                one_word = self.check(one_word)  # sprawdzamy czy jest dobre
            else:
                all_data += one_word  # jak dostajemy spację, to dodajemy słowo, przerwę i czyścimy słowo
                all_data += ' '
                one_word = []

        all_data += one_word

        self.textbox2.setText(''.join(all_data))

    def check(self, one_word):
        cenzura = []
        bad_word = False
        black_list = []
        word = ''.join(one_word)
        file = open("black_list.txt").read().split('\n')

        for line in file:
            black_list.append(line)
            if line == word:
                for i in range(0, len(one_word)):
                    cenzura.append('*')
                    bad_word = True

        if bad_word == True:
            return cenzura
        else:
            return one_word

    def text_to_bits(self, text, encoding='utf-8', errors='surrogatepass'): 
        bits = bin(int(binascii.hexlify(text.encode(encoding, errors)), 16))[2:]
        return bits.zfill(8 * ((len(bits) + 7) // 8))

    def text_from_bits(self, bits, encoding='utf-8', errors='surrogatepass'):
        n = int(bits, 2)
        return self.int2bytes(n).decode(encoding, errors)

    def int2bytes(self, i):
        hex_string = '%x' % i
        n = len(hex_string)
        return binascii.unhexlify(hex_string.zfill(n + (n & 1)))


app = QtWidgets.QApplication(sys.argv)
mainWin = MainWindow()
mainWin.show()
sys.exit(app.exec_())
