# Program do testowania bodźców akustycznych i optycznych

from PyQt5 import QtCore, QtWidgets
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtTest import *
import sys
import time
import random
import winsound

class MainWindow(QMainWindow):

    def __init__(self, parent=None):
        QMainWindow.__init__(self, parent)
        self.central_widget = QStackedWidget()
        self.setCentralWidget(self.central_widget)
        self.setMinimumSize(QSize(800, 600))
        self.setFont(QFont('SansSerif', 17))
        self.setWindowTitle("Architektura Systemów Komputerowych lab Zadanie 5")

        self.start_screen = Start()
        self.test_screen = Test()
        self.training_screen = Training()

        self.central_widget.addWidget(self.start_screen)
        self.central_widget.addWidget(self.test_screen)
        self.central_widget.addWidget(self.training_screen)

        self.central_widget.setCurrentWidget(self.start_screen)

        self.start_screen.test_click.connect(lambda: self.central_widget.setCurrentWidget(self.test_screen))
        self.start_screen.training_click.connect(lambda: self.central_widget.setCurrentWidget(self.training_screen))

        self.test_screen.start_click.connect(lambda: self.central_widget.setCurrentWidget(self.start_screen))

        self.training_screen.start_click.connect(lambda: self.central_widget.setCurrentWidget(self.start_screen))


class Start(QWidget):

    test_click = pyqtSignal()
    training_click = pyqtSignal()

    def __init__(self):
        super(Start, self).__init__()

        self.label = QLabel("Witam w teście sprawności psychomotorycznej", self)
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setGeometry(100, 50, 600, 50)

        self.label2 = QLabel("Rozpocznij test",self)
        self.label2.setAlignment(Qt.AlignCenter)
        self.label2.setGeometry(100, 400, 200, 50)

        self.label3 = QLabel("Trenuj",self)
        self.label2.setAlignment(Qt.AlignCenter)
        self.label3.setGeometry(550, 400, 200, 50)


        testButton = QPushButton('Test', self)
        testButton.setGeometry(100, 500, 200, 50)
        testButton.clicked.connect(self.test_click.emit)

        trainingButton = QPushButton('Trening', self)
        trainingButton.setGeometry(500, 500, 200, 50)
        trainingButton.clicked.connect(self.training_click.emit)


class Test(QWidget):
    OPTIC_NUMBER = 1
    SOUND_NUMBER = 1
    etap = 'poczatek'
    BEGINING = 0
    END = 0
    start_click = pyqtSignal()
    results = []

    def __init__(self):
        super(Test, self).__init__()
        self.label = QLabel("Kliknij by rozpocząć",self)
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setGeometry(100, 0, 600, 150)

        self.label2 = QLabel(self)
        self.label2.setAlignment(Qt.AlignCenter)
        self.label2.setGeometry(100, 100, 600, 50)

        self.label3 = QLabel(self)
        self.label3.setAlignment(Qt.AlignCenter)
        self.label3.setGeometry(100, 150, 600, 50)

        startButton = QPushButton('Powrot do Menu', self)
        startButton.setGeometry(275, 500, 250, 50)
        startButton.clicked.connect(self.start_click.emit)

        self.drawRectangles()

    def beep(self):
        frequency = 2500
        duration = 200
        winsound.Beep(frequency, duration)

    def sound_test_start(self):
        self.label2.setText("Próba akustyczna numer : " + str(self.SOUND_NUMBER))
        self.timer()
        self.delay()
        self.BEGINING = time.time()
        self.beep()
        self.etap = 'odliczanie'


    def sound_test(self):
        if self.SOUND_NUMBER < 5:
            self.END = time.time() - self.BEGINING
            self.END = 1000 * self.END
            self.results.append(self.END)
            self.SOUND_NUMBER = self.SOUND_NUMBER + 1
            self.label2.setText("Próba akustyczna numer : " + str(self.SOUND_NUMBER))
            self.label3.setText("Czas: " + str(self.END) + " ms")
            self.etap = 'poczatek'
            self.sound_test_start()
        else:
            self.END = time.time() - self.BEGINING
            self.END = 1000 * self.END
            self.results.append(self.END)
            self.label2.setText("Próba akustyczna numer : " + str(self.SOUND_NUMBER))
            self.label3.setText("Czas: " + str(self.END) + " ms")
            self.label.setText("Kliknij, aby przejść do próby optycznej")
            self.etap ='poczatek2'

    def start(self):
        self.label2.setText("Próba optyczna numer : " + str(self.OPTIC_NUMBER))
        self.timer()
        self.delay()
        self.col = QColor(0, 0, 255)
        self.etap = 'odliczanie2'
        self.square.setStyleSheet("QFrame { background-color: %s }" % self.col.name())
        self.BEGINING = time.time()

    def testowanie(self):
        if self.OPTIC_NUMBER < 5:
            self.END = time.time() - self.BEGINING
            self.END = 1000 * self.END
            self.results.append(self.END)
            self.OPTIC_NUMBER = self.OPTIC_NUMBER + 1
            self.label2.setText("Próba optyczna numer : " + str(self.OPTIC_NUMBER))
            self.label3.setText("Czas: " + str(self.END) + " ms")
            self.col = QColor(255, 0, 0)
            self.square.setStyleSheet("QFrame { background-color: %s }" % self.col.name())
            self.etap = 'poczatek2'
            self.start()
        else:
            self.END = time.time() - self.BEGINING
            self.END = 1000 * self.END
            self.results.append(self.END)
            self.label2.setText("Próba optyczna numer : " + str(self.OPTIC_NUMBER))
            self.label3.setText("Czas: " + str(self.END) + " ms")
            print(self.results)
            self.start_click.emit()


    def mousePressEvent(self,event):
        if event and self.etap == 'poczatek':
            self.sound_test_start()

        elif event and self.etap == 'odliczanie':
            self.sound_test()

        elif event and self.etap == 'poczatek2':
            self.start()

        elif event and self.etap == 'odliczanie2':
            self.testowanie()

    def drawRectangles(self):
        self.col = QColor(255, 0, 0)
        self.square = QFrame(self)
        self.square.setGeometry(200, 200, 400, 200)
        self.square.setStyleSheet("QWidget { background-color: %s }" % self.col.name())

    def delay(self):
        ms = random.randrange(1000, 3000, 10)
        QTest.qWait(ms)

    def timer(self):
        for i in range (0,3):
            self.label.setText("Przygotuj się za " + str(3 - i))
            ms = 1000
            QTest.qWait(ms)

        self.label.setText("")

class Training(QWidget):
    n = 1
    n_akustyczne = 1
    etap = 'poczatek'
    poczatek = 0
    koniec = 0
    start_click = pyqtSignal()

    def __del__(self):
        print("destroy")

    def __init__(self):
        super(Training, self).__init__()
        self.label = QLabel("Kliknij by rozpocząć",self)
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setGeometry(100,0,600,150)

        self.label2 = QLabel(self)
        self.label2.setAlignment(Qt.AlignCenter)
        self.label2.setGeometry(100,100,600,50)

        self.label3 = QLabel(self)
        self.label3.setAlignment(Qt.AlignCenter)
        self.label3.setGeometry(100, 150, 600, 50)

        startButton = QPushButton('Powrot do Menu', self)
        startButton.setGeometry(275, 500, 250, 50)
        startButton.clicked.connect(self.start_click.emit)

        self.drawRectangles()

    def beep(self):

        frequency = 2500
        duration = 200
        winsound.Beep(frequency, duration)

    def sound_test_start(self):
        self.label2.setText("Próba akustyczna numer : " + str(self.n_akustyczne))
        self.timer()
        self.delay()
        self.poczatek = time.time()
        self.beep()
        self.etap = 'odliczanie'


    def sound_test(self):
        if self.n_akustyczne < 5:
            self.koniec = time.time() - self.poczatek
            self.koniec = 1000*self.koniec
            self.n_akustyczne = self.n_akustyczne + 1
            self.label2.setText("Próba akustyczna numer : " + str(self.n_akustyczne))
            self.label3.setText("Czas: " + str(self.koniec)+" ms")
            self.etap = 'poczatek'
            self.sound_test_start()
        else:
            self.koniec = time.time() - self.poczatek
            self.koniec = 1000 * self.koniec
            self.label2.setText("Próba akustyczna numer : " + str(self.n_akustyczne))
            self.label3.setText("Czas: " + str(self.koniec) + " ms")
            self.label.setText("Kliknij, aby przejść do próby optycznej")
            self.etap ='poczatek2'

    def start(self):
        self.label2.setText("Próba optyczna numer : " + str(self.n))
        self.timer()
        self.delay()
        self.col = QColor(0, 0, 255)
        self.etap = 'odliczanie2'
        self.square.setStyleSheet("QFrame { background-color: %s }" % self.col.name())
        self.poczatek = time.time()

    def testowanie(self):
        if self.n < 5:
            self.koniec = time.time() - self.poczatek
            self.koniec = 1000*self.koniec
            self.n = self.n + 1
            self.label2.setText("Próba optyczna numer : " + str(self.n))
            self.label3.setText("Czas: " + str(self.koniec)+ " ms")
            self.col = QColor(255, 0, 0)
            self.square.setStyleSheet("QFrame { background-color: %s }" % self.col.name())
            self.etap = 'poczatek2'
            self.start()
        else:
            self.koniec = time.time() - self.poczatek
            self.koniec = 1000 * self.koniec
            self.results.append(self.koniec)
            self.label2.setText("Próba optyczna numer : " + str(self.n))
            self.label3.setText("Czas: " + str(self.koniec) + " ms")
            self.start_click.emit()

    def mousePressEvent(self,event):
        if event and self.etap == 'poczatek':
            self.sound_test_start()

        elif event and self.etap == 'odliczanie':
            self.sound_test()

        elif event and self.etap == 'poczatek2':
            self.start()

        elif event and self.etap == 'odliczanie2':
            self.testowanie()


    def drawRectangles(self):
        self.col = QColor(255, 0, 0)
        self.square = QFrame(self)
        self.square.setGeometry(200, 200, 400, 200)
        self.square.setStyleSheet("QWidget { background-color: %s }" % self.col.name())

    def delay(self):
        ms = random.randrange(1000, 3000, 10)
        QTest.qWait(ms)

    def timer(self):
        i = 0
        for i in range (0,3):
            self.label.setText("Przygotuj się za " + str(3 - i))
            ms = 1000
            QTest.qWait(ms)

        self.label.setText("")


class Results(QWidget):
    start_click = pyqtSignal()

    def __init__(self):
        super(Results,self).__init__()

app = QApplication(sys.argv)
mainWin = MainWindow(None)
mainWin.show()
sys.exit(app.exec_())

