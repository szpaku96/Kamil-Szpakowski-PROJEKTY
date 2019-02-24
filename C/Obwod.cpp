// Kamil Szpakowski
// Program, który liczy obwód figury
// ilosc punktów, oraz same punkty s¹ wprowadzane przez uzytkownika programu
// sprawdza przeciêcia krawêdzi 

#include <iostream>
#include <stdlib.h> 
#include <time.h>
#include <math.h>

using namespace std;

struct Point {				// tworzymy sobie stukture punkt
	int x;					// czyli nowy typ, posiada on dwa inty
	int y;
};

void enter_point(Point tab[], int index) {
	int x, y;
	cout << "Enter coordinates for the point" << endl;
	cin >> x >> y;			// wprowadzamy x i y z klawiatury
	tab[index].x = x;		// do tablicy o typie Point
	tab[index].y = y;		// dodajemy wpisane x i y
}

void print_all(Point tab[], int liczba) {
	for (int i = 0; i < liczba; i++)
		cout << "Point " << i << " (" << tab[i].x << "," << tab[i].y << ")" << endl; // wypisanie naszej tablicy punktow na ekran
}

void check(Point tab[], int index) {
	bool repeated = false;

	for (int i = 0; i < index; i++) {
		if (tab[i].x == tab[index].x && tab[i].y == tab[index].y) { // sprawdzamy czy dodalismy juz taki sam punkt, jezeli tak to nic z tym nie robimy
			repeated = true;	// tylko dajemy info ze jest powtorzony
		}
	}

	if (repeated == true)
		cout << "There is a point with the same coordinates." << endl; // wypisujac tutaj komunikat

	if (index > 1) {  // tu sie zaczyna pojebana akcja, bo algorytm na wykrywanie krawedzi nie jest latwy
		int x1;
		int x2;
		int x3;
		int x4;
		int y1;
		int y2;
		int y3;
		int y4;

		if (tab[index].x < tab[index - 1].x) { // mozna smialo powiedziec ze jest chujowy
			x3 = tab[index].x;				// bierzemy wspolrzedne nowego i poprzedniego punktu i ustawiamy je tak,
			y3 = tab[index].y;				// ze x3 to punkt po lewej a x4 to punkt po prawej
			x4 = tab[index - 1].x;			// czyli nie chodzi o to, ze x3 to nowy a x4 to poprzedni pkt, tylko zeby ten o mniejszej wartosci x
			y4 = tab[index - 1].y;			// byl x3, a ten o wiekszej to x4
		}
		else {
			x3 = tab[index - 1].x;
			y3 = tab[index - 1].y;
			x4 = tab[index].x;
			y4 = tab[index].y;
		}

		for (int j = 0; j < index; j++) {		// tutaj jest petelka ktora robi to samo tylko ze sprawdza wszystkie pkty od poczatku
			if (tab[j].x > tab[j + 1].x) {		// czyli krawedz pomiedzy punktami 0 a 1, 1 a 2 itp, az do indexu
				x1 = tab[j + 1].x;				// i tez ustawiamy ten punkt ktory mial mniejszy x, na x1, a wiekszy na x2
				y1 = tab[j + 1].y;
				x2 = tab[j].x;
				y2 = tab[j].y;
			}
			else {
				x1 = tab[j].x;
				y1 = tab[j].y;
				x2 = tab[j + 1].x;
				y2 = tab[j + 1].y;
			}

			if (x1 < x3 && x3 < x2 && x1 < x4 && x4 < x2 && y1 > y3 && y4 > y1)
				cout << "Edges intersect" << endl;
			else if (x1 < x3 && x3 < x2 && x1 < x4 && x4 < x2 && y2 > y3 && y4 > y2)
				cout << "Edges intersect" << endl;
			else if (x1 < x3 && x3 < x2 && x1 < x4 && x4 < x2 && y2 < y3 && y4 > y2)
				cout << "Edges intersect" << endl;
			else if (x1 < x3 && x3 < x2 && x1 < x4 && x4 < x2 && y1 < y3 && y4 > y1)
				cout << "Edges intersect" << endl;
		}
	}
}

int number_of_vertices() {
	int number_of_points;
	cout << "Enter number of vertices" << endl;
	cin >> number_of_points;
	if (number_of_points < 3 || number_of_points > 19)  // sprawdzamy czy podana ilosc wierzcholkow jest wieksza niz 3 i mniejsza niz 20 
		while (number_of_points < 3 || number_of_points > 19) // jezeli tak to super, zwracamy ilosc pktow, ale jezeli nie, to wpisujemy jeszcze raz
		{												// az do skutku
			cout << "Figure must have more than 2, and less than 20 vertices" << endl;
			cout << "Enter the number again" << endl;
			cin >> number_of_points;
			cout << endl;
		}
	return number_of_points;
}

double count(Point tab[], int liczba) {

	double edge = 0;
	double circuit = 0;

	for (int i = 0; i < liczba - 1; i++) // bierzemy punkt i oraz i+1 , czyli 0 i 1, potem 1 i 2 itd...
	{
		int x1 = tab[i].x;
		int y1 = tab[i].y;
		int x2 = tab[i + 1].x;
		int y2 = tab[i + 1].y;

		edge = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2)); // wzor na odleglosc prostej na plaszczyznie
		circuit += edge; // dodajemy krawedz do obwodu
	}

	int x1 = tab[0].x; // na koncu liczymy odleglosc pomiedzy ostatnim punktem, a pierwszym, zeby zamknac figure
	int y1 = tab[0].y;
	int x2 = tab[liczba - 1].x;
	int y2 = tab[liczba - 1].y;

	edge = sqrt(pow((x2 - x1), 2) + pow((y2 - y1), 2)); // czyli to samo co wyzej, tylko ze nie w petli, ale ostatnie wywolanie
	circuit += edge;

	return circuit; // zwracamy obwod
}


int main() {

	srand(time(NULL));								// potrzebne do generowania liczb losowych
	int number_of_points;									// zmienna ktora bedzie mowila ile jest wierzcholkow
	double sum;									// suma

	number_of_points = number_of_vertices();				// wywolanie funkcji, w ktorej mowimy ile bedzie punktow

	Point * array_of_points = new Point[number_of_points];		// tworzenie tablicy dynamicznej o ilosci elementow wskazanych wczesniej

	for (int i = 0; i < number_of_points; i++) {			// wprowadzamy wspolrzedne i sprawdzamy czy jest git
		enter_point(array_of_points, i);
		check(array_of_points, i);
	}

	print_all(array_of_points, number_of_points);					// sypisujemy punkty

	sum = count(array_of_points, number_of_points);				// wywolujemy obliczenie obwodu
	cout << "Circuit equals : " << sum << endl;

	system("pause");
	return 0;
}