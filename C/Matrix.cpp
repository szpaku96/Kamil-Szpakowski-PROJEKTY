// Macierz.cpp : Defines the entry point for the console application.
//

//#include "stdafx.h"

#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int** transform1(int **tablica, int **tablica1, int rozmiar) {
	for (int i = 0; i < rozmiar / 2; i++) // transponowanie macierzy 
		for (int j = 0; j < rozmiar / 2; j++)
			tablica1[i][j] = tablica[j][i];

	return tablica1;
}

int** transform2(int **tablica, int **tablica2, int *selection_sort, int rozmiar) {
	for (int i = 0; i < rozmiar / 2; i++) {
		for (int j = rozmiar / 2; j < rozmiar; j++) { // tworzenie wektora zamiast macierzy
			selection_sort[j - rozmiar / 2 + i * rozmiar / 2] = tablica[i][j]; // wypelniamy go elementami macierzy po kolei
		}
	}

	int half = rozmiar / 2;

	for (int i = 0; i < half * half; i++) {

		int index = 0;
		int smallest_index = 0;

		while (index < (half * half - 1)) {
			int smallest = selection_sort[index]; // szukam najmniejszego elementu

			for (int i = index; i < half*half; i++) { // jak przejde przez wszystkie elementy
				if (selection_sort[i] <= smallest) {
					smallest = selection_sort[i]; // to mam pewnosc ze znalazlem juz najmniejszy
					smallest_index = i;
				}
			}
			int bufor = selection_sort[index]; // zamieniam go miejscami z tym co jest na poczatku
			selection_sort[smallest_index] = bufor;
			selection_sort[index] = smallest;
			index += 1;
		}
	}

	for (int j = 0; j < half; j++) // zamiana z wektora na macierz 
		for (int i = 0; i < half; i++)
			tablica2[i][j] = selection_sort[i + j * half];

	return tablica2;
}

int** transform3(int **tablica, int**tablica3, int rozmiar) {

	int half = rozmiar / 2;

	for (int i = half; i < rozmiar; i++)
	{
		for (int j = 0; j < half; j++)
		{
			if ((i - half) == j) {
				tablica3[i - half][j] = 1; // zamieniam elementy dla i - half = j na 1,
			}
			else if (i == j) // tutaj brakuje tej zamiany na 0
				tablica3[i - half][j] = 0;

			else
				tablica3[i - half][j] = tablica[i][j];
		}
	}

	return tablica3;
}

void wypisz_wej(int **tablica, int rozmiar) {

	int half = rozmiar / 2;

	cout << "Macierz wejsciowa :" << endl;

	for (int i = 0; i < half; i++) {
		for (int j = 0; j < half; j++) {
			cout << tablica[i][j] << "   ";
		}
		cout << "    ";
		for (int j = half; j < rozmiar; j++) {
			cout << tablica[i][j] << "   ";
		}
		cout << endl;
	}
	cout << "     K A M I L   S Z P A K O W S K I " << endl;

	for (int i = half; i < rozmiar; i++) {
		for (int j = 0; j < half; j++) {
			cout << tablica[i][j] << "   ";
		}
		cout << "    ";
		for (int j = half; j < rozmiar; j++) {
			cout << tablica[i][j] << "   ";
		}
		cout << endl;
	}
	cout << endl;

}

int** transform4(int **tablica, int**tablica4, int rozmiar) {
	int half = rozmiar / 2;

	for (int i = half; i < rozmiar; i++)
		for (int j = half; j < rozmiar; j++)
			tablica4[i - half][j - half] = tablica[i][j];

	for (int i = 0; i < half / 2; i++)
		for (int j = 0; j < (half + 1) / 2; j++) {
			int temp = tablica4[i][j];
			tablica4[i][j] = tablica4[half - 1 - j][i];
			tablica4[half - 1 - j][i] = tablica4[half - 1 - i][half - 1 - j];
			tablica4[half - 1 - i][half - 1 - j] = tablica4[j][half - 1 - i];
			tablica4[j][half - 1 - i] = temp;
		}
	return tablica4;
}

void wypisz_wyj(int **tablica1, int **tablica2, int **tablica3, int **tablica4, int rozmiar) {

	int half = rozmiar / 2;
	cout << "Macierz wyjsciowa :" << endl;

	for (int i = 0; i < half; i++) {
		for (int j = 0; j < half; j++) {
			cout << tablica1[i][j] << "   ";
		}
		cout << "    ";
		for (int j = 0; j < half; j++) {
			cout << tablica2[j][i] << "   ";
		}
		cout << endl;
	}
	cout << "     K A M I L   S Z P A K O W S K I " << endl;

	for (int i = 0; i < half; i++) {
		for (int j = 0; j < half; j++) {
			cout << tablica3[i][j] << "   ";
		}
		cout << "    ";
		for (int j = 0; j < half; j++) {
			cout << tablica4[i][j] << "   ";
		}
		cout << endl;
	}
	cout << endl;
}

int main()
{
	srand(time(NULL)); // czas potrzebny do generowania liczb pseudolosowych

	int rozmiar;
	cout << "Wprowadz rozmiar macierzy" << endl;
	cin >> rozmiar;
	if (rozmiar < 3 || rozmiar > 14 || rozmiar % 2 == 1)
	{
		while (rozmiar < 3 ||rozmiar > 14 || rozmiar % 2 == 1 ) // jezeli tak to super, zwracamy ilosc pktow, ale jezeli nie, to wpisujemy jeszcze raz
		{                                               // az do skutku
			cout << "Macierz musi miec rozmiar wiekszy niz 2, mniejszy niz 14 i byc parzysta. Wprowadz rozmiar ponownie" << endl;
			cin >> rozmiar;
		}
	}

	int** tablica = new int*[rozmiar]; // tworzenie tablicy dwuwymiarowej dynamicznej
	for (int i = 0; i < rozmiar; i++)
		tablica[i] = new int[rozmiar];

	int** tablica1 = new int*[rozmiar / 2]; // tworzenie tablicy dwuwymiarowej dynamicznej
	for (int i = 0; i < rozmiar / 2; i++)
		tablica1[i] = new int[rozmiar / 2];

	int** tablica2 = new int*[rozmiar / 2]; // tworzenie tablicy dwuwymiarowej dynamicznej
	for (int i = 0; i < rozmiar / 2; i++)
		tablica2[i] = new int[rozmiar / 2];

	int** tablica3 = new int*[rozmiar / 2]; // tworzenie tablicy dwuwymiarowej dynamicznej
	for (int i = 0; i < rozmiar / 2; i++)
		tablica3[i] = new int[rozmiar / 2];

	int** tablica4 = new int*[rozmiar / 2]; // tworzenie tablicy dwuwymiarowej dynamicznej
	for (int i = 0; i < rozmiar / 2; i++)
		tablica4[i] = new int[rozmiar / 2];

	int* selection_sort = new int[(rozmiar / 2) * (rozmiar / 2)]; // tworzenie wektora z macierzy do algorytmu quicksort

	for (int i = 0; i < rozmiar; i++)  // wypelnia cala macierz pseudolosowymi liczbami
		for (int j = 0; j < rozmiar; j++) 
			tablica[i][j] = rand() % 100 - 50;

	tablica1 = transform1(tablica, tablica1, rozmiar); // transponowanie macierzy 
	tablica2 = transform2(tablica, tablica2, selection_sort, rozmiar); // sortowanie elementów z wykorzystaniem algorytmu selection sort 
	tablica3 = transform3(tablica, tablica3, rozmiar); // ustawienie przek¹tnej macierzy na 1
	tablica4 = transform4(tablica, tablica4, rozmiar); // obrót o 90* zgodnie z kierunkiem zegara

	wypisz_wej(tablica, rozmiar); // wypisanie macierzy wejsciowej 
	wypisz_wyj(tablica1,tablica2,tablica3,tablica4, rozmiar); // wypisanie macierzy wyjsciowej 
	
	delete[] tablica; // zwolnienie pamieci
	delete[] tablica1;
	delete[] tablica2;
	delete[] tablica3;
	delete[] tablica4;

	system("pause");
	return 0;
}