# Testowanie kilku prostych programów

import random

class Point:

    def __init__(self):
        a = self.miesiac(2.421)
        print('Miesiac o podanym numerze to: ',a)
        wynik = self.mnozenie(2, 4)
        print(wynik)
        self.potegowanie_menu(0, 0)
        self.coiny(50)
        self.losowanie(50)
        self.piramida(16)

    def coiny(self,ilosc): # testowanie 50/50
        zero = 0
        jeden = 0

        for i in range (0,ilosc):
            a = random.randint(0,1)
            if a == 0:
                zero += 1
            else:
                jeden+= 1

        print('zero',zero,'jeden',jeden)

    def potegowanie_menu(self, a, b): # potegowanie bez uzywania funkcji pov
        if a == 0 and b == 0:
            print('Symbol nieoznaczony')
        else:
            wynik = self.potegowanie(a, b)
            print(wynik)

    def potegowanie(self, num1, num2):
        # num1^num2
        const = num1
        if num1 == 0:
            return 1
        elif num2 > 0:
            while num2 > 1:
                num1 *= const
                num2 -= 1
            return num1

    def miesiac(self, number):
        num = int(number)
        vec = ['styczen', 'luty','marzec','kwiwcien', 'maj','czerwiec','lipiec', 'sierpien','wrzesien','pazdziernik', 'listopad','grudzien']

        if num >= 1 and num < 13:
            return vec[num-1]
        else:
            return 'nie ma takiego miesiaca'

    def mnozenie(self, num1, num2): # mnozenie poprzez dodawanie

        test = num1 * num2
        num1 = abs(num1)
        num2 = abs(num2)
        const = num1

        while num2 > 1:
            num1 += const
            num2 -= 1
        if test > 0:
            return num1
        else:
            return -num1

    def losowanie(self,number):  # losowanie bez powtorzen
        losowy_array = []
        count = 0

        while count != number:
            randomowa = random.randint(0,50)
            powtorzenie = False

            for i in range (0, len(losowy_array)):
                if randomowa == losowy_array[i]:
                    powtorzenie = True

            if not powtorzenie:
                losowy_array.append(randomowa)
                count += 1

        print(losowy_array)

    def piramida(self,stopnie):

        if stopnie % 2 == 1:
            count = 1
            medium = int(stopnie / 2)
            while medium > 0:
                for i in range(0,medium-1):
                    print('-',end="")
                for i in range(0,count):
                    print('X',end="")
                for i in range(0,medium-1):
                    print('-',end="")

                print('\n')

                count += 2
                medium -= 1

        else:
            medium = int(stopnie / 2)
            count = 2
            while medium > 1:
                for i in range(0,medium-2):
                    print('-',end="")
                for i in range(0,count):
                    print('X',end="")
                for i in range(0,medium-2):
                    print('-',end="")

                print('')

                count += 2
                medium -= 1

h = Point()
