# Algorytm który pobiera mapę, i pokonuję drogę z punktu startowego do końcowego omijając konkrety rodzaj przeszkody

import cv2
import math
import numpy as np


class ForwardChaining:


    start_x = 700
    start_y = 600
    goal_x = 100
    goal_y = 170
    posx = start_x
    posy = start_y
    a = 0.1
    b = 3
    dist = 15
    OBSTACLE = False
    NEAR = True

    image = cv2.imread('obstacle.png')

    def __init__(self):
        cv2.circle(self.image, (self.start_x, self.start_y), 10, (255, 0, 0), 20)
        cv2.circle(self.image, (self.goal_x, self.goal_y), 10, (0, 0, 255), 20)

        width = self.image.shape[1] #800
        height = self.image.shape[0] #800

        d = self.d(self.goal_x,self.goal_y,self.posx,self.posy)
        global_potential = [[0] * width for i in range(height)]

        goal_potential = self.goal_potential(self.goal_x,self.goal_y,width,height)
        obstacle_potential = self.obstacle_potential(width,height)

        for i in range (0,width):
            for j in range(0,height):
                global_potential[i][j] = obstacle_potential[i][j] + goal_potential[i][j]

        self.run(global_potential,self.posx,self.posy)

    def goal_potential(self,goal_x,goal_y,width,height):
        loc_goal_potential = [[0] * width for i in range(height)]

        for x in range(0, height):
            for y in range(0, width):
                loc_goal_potential[y][x] = (math.sqrt(math.pow((x-self.goal_x), 2) + math.pow((y-self.goal_y), 2)) / self.a)

        return loc_goal_potential

    def obstacle_potential(self,width,height):
        fallof = 10
        loc_obstacle_potential = [[0] * width for i in range(height)]

        for y in range(0, height):
            for x in range(0, width):
                if np.all(self.image[y][x] == (0,0,0)):
                    loc_obstacle_potential[y][x] = 100000

                if np.all(self.image[y][x] == (0, 0, 0)) and np.all(self.image[y][x-1] != (0, 0, 0)): # lewa strona
                    for i in range (0,fallof):
                        loc_obstacle_potential[y][x-i] = pow((fallof-i),2)
                        self.image[y][x-i] = (0,255,0)

                if np.all(self.image[y][x] == (0, 0, 0)) and np.all(self.image[y][x + 1] != (0, 0, 0)):  # lewa strona
                    for i in range(0, fallof):
                        loc_obstacle_potential[y][x + i] = pow((fallof - i), 2)
                        self.image[y][x + i] = (0, 255, 0)

        return loc_obstacle_potential

    def d(self, goal_x, goal_y, posx, posy):
        d = math.sqrt(math.pow((goal_x - posx), 2) + math.pow((goal_y - posy), 2))
        return d

    def show(self):
        cv2.imshow('Forward Chaining', self.image)
        cv2.waitKey(0)
        cv2.destroyAllWindows()

    def run(self, global_potential, posx, posy):
        dist = 15
        old_a = 0
        old_b = 0
        loc_min = math.inf
        d = self.d(self.goal_x, self.goal_y, posx, posy)
        self.OBSTACLE=False

        while not self.OBSTACLE:
            for i in range(0, 360):
                a = dist * math.sin(i * math.pi / 180) + posy
                b = dist * math.cos(i * math.pi / 180) + posx
                new_a = round(a)
                new_b = round(b)

                if new_a != old_a or old_b != new_b: # sprawdzamy czy następiła zmiana pixela( żeby nie liczyć pare razy w tym samym miejscu )
                    self.image[new_a][new_b] = (255, 0, 255) # zaznaczamy pole
                    minimum = global_potential[new_a][new_b]

                    if loc_min > minimum:  # loc_min ustawione na inf, bo chcemy, żeby pierwszy punkt był minimum
                        loc_min = minimum
                        minx = new_b # wspolrzedne punktu minimum
                        miny = new_a

                old_b = new_b
                old_a = new_a

            cv2.line(self.image, (posx, posy), (minx, miny), (0, 255, 255), 1)
            d = self.d(self.goal_x, self.goal_y, posx, posy)
            print('d',d,'posx',posx, 'posy',posy)

            if d < dist: # tu konczymy
                cv2.line(self.image, (posx, posy), (self.goal_x, self.goal_y), (0, 255, 255), 1)
                self.OBSTACLE = True
                self.show()

            if minx == posx and miny == posy: # tutaj cały czas jesteśmy w tym while, więc loc_min już nie jest inf, tylko poprzednią wartością
                print("Przeszlo do runaway") # więc jeżeli ten warunek został spełniony i tu weszliśmy, oznacza, że nie nadpisaliśmy minx i miny
                self.runaway(posy, posx, global_potential) # czyli jesteśmy w tym samym punkcie, więc zmiana algorytmu

            posx = minx
            posy = miny



    def runaway(self,posy,posx,global_potential):
        dist = 15
        old_a = 0
        old_b = 0
        loc_near = False
        self.NEAR = True

        while self.NEAR: # loc_near ( podkreślam loc ) jest ustawione na false
            loc_min = math.inf
            minimum = math.inf
            for i in range(180+20, 360-20):
                a = dist * math.sin(i * math.pi / 180) + posy
                b = dist * math.cos(i * math.pi / 180) + posx
                new_a = round(a)
                new_b = round(b)
                # print(old_a,old_b)
                if new_a != old_a or old_b != new_b:
                    self.image[new_a][new_b] = (255, 0, 0)
                    minimum = global_potential[new_a][new_b]
                    if global_potential[new_a][new_b] >= 100000: #  jeżeli znajdziemy jakiś punkt którego wartość wynosi ponad 100000
                        loc_near = True # to oznacza tylko jedno, że w zasięgu naszych pixeli jest przeszkoda, ustawiamy loc_near na True
                    if loc_min > minimum:
                        loc_min = minimum
                        minx2 = new_b
                        miny2 = new_a

                old_b = new_b
                old_a = new_a
            cv2.line(self.image, (posx, posy), (minx2, miny2), (0, 255, 255), 1)
            print(posx,posy)
            posx = minx2
            posy = miny2
            if loc_near != True: # jezeli loc near jest false, czyli nie zalezlismy przeszkody to oznacza, ze NEAR dajemy na false
                self.NEAR = False # jak damy near na false, to wyjdziemy z runaway

            loc_near = False # wracamy z loc_near na false, bo to musi dla każdego nowego punktu sprawdzać czy lecimy dalej
        self.OBSTACLE = True # tutaj jest tem moment, że po skończeniu runaway, kończymy też run, to jest potrzebne, żeby tammen while się kiedyś skończył
        print('wrocilo do run')
        self.run(global_potential,posx,posy) # i tu z powrotem skaczemy do run
        print('wyszlo')

forward = ForwardChaining()