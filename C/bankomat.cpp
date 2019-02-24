#include <iostream>
#include <string>

using namespace std;

void wypelnij(int* wektor) {

	int liczba_banknotow;

	cout << "Podaj ilosc dwusetek" << endl;
	cin >> liczba_banknotow;
	wektor[0] += liczba_banknotow;
	cout << "Podaj ilosc setek" << endl;
	cin >> liczba_banknotow;
	wektor[1] += liczba_banknotow;
	cout << "Podaj ilosc piecdziesiatek" << endl;
	cin >> liczba_banknotow;
	wektor[2] += liczba_banknotow;
	cout << "Podaj ilosc dwudziestek" << endl;
	cin >> liczba_banknotow;
	wektor[3] += liczba_banknotow;
	cout << "Podaj ilosc dziesiatek" << endl;
	cin >> liczba_banknotow;
	wektor[4] += liczba_banknotow;
	system("cls");
}

void wartosci(int* banknoty,int kwota,int* wybrane_pieniadze) {

	int dwusetki = banknoty[0];
	int setki = banknoty[1];
	int piecdziesiatki = banknoty[2];
	int dwudziestki = banknoty[3];
	int dziesiatki = banknoty[4];

	int wybrane_200 = 0;
	int wybrane_100 = 0;
	int wybrane_50 = 0;
	int wybrane_20 = 0;
	int wybrane_10 = 0;

	while(kwota >= 200 && dwusetki >= 1) {
		kwota -= 200;
		wybrane_200++;
		dwusetki--;
	}

	while (kwota >= 100 && setki >= 1) {
		kwota -= 100;
		wybrane_100++;
		setki--;
	}

	while (kwota >= 50 && piecdziesiatki >= 1) {
		kwota -= 50;
		wybrane_50++;
		piecdziesiatki--;
	}

	while (kwota >= 20 && dwudziestki >= 1) {
		kwota -= 20;
		wybrane_20++;
		dwudziestki--;
	}

	while (kwota >= 10 && dziesiatki >= 1) {
		kwota -= 10;
		wybrane_10++;
		dziesiatki--;
	}

	wybrane_pieniadze[0] = wybrane_200;
	wybrane_pieniadze[1] = wybrane_100;
	wybrane_pieniadze[2] = wybrane_50;
	wybrane_pieniadze[3] = wybrane_20;
	wybrane_pieniadze[4] = wybrane_10;

	if(wybrane_pieniadze[0]!= 0)
		cout << "Wyplacono " << wybrane_pieniadze[0] << " banknowtow o nominale 200"<< endl;
	if (wybrane_pieniadze[1] != 0)
		cout << "Wyplacono " << wybrane_pieniadze[1] << " banknowtow o nominale 100" << endl;
	if (wybrane_pieniadze[2] != 0)
		cout << "Wyplacono " << wybrane_pieniadze[2] << " banknowtow o nominale 50" << endl;
	if (wybrane_pieniadze[3] != 0)
		cout << "Wyplacono " << wybrane_pieniadze[3] << " banknowtow o nominale 20" << endl;
	if (wybrane_pieniadze[4] != 0)
		cout << "Wyplacono " << wybrane_pieniadze[4] << " banknowtow o nominale 10" << endl;
	
	system("pause");

}

void pin() {
	bool good = false;
	bool poprawne_cyfry = true;
	int pin;
	system("cls");
	cout << "Podaj Pin." << endl;

	cin >> pin;

	while (good != true) {

		if (pin == 0000 || pin>999 && pin < 10000 )
				good = true;
		
		else {
			system("cls");
			cout << "Pin musi posiadac 4 cyfry." << endl;
			cout << "Podaj pin ponownie." << endl;
			cin >> pin;

		}
	}
}

void wybierz(int* wektor) {

	pin();
	system("cls");
	cout << "Ile chcesz wybrac pieniedzy" << endl;
	int pieniadze;

	unsigned int suma_w_banku = 200 * wektor[0] + 100 * wektor[1] + 50 * wektor[2] + 20 * wektor[3] + 10 * wektor[4];
	cout << "W bankomacie jest " << suma_w_banku << endl;
	bool poprawne = false;

	while (poprawne != true) {
		cin >> pieniadze;

		if (suma_w_banku < pieniadze) {
			system("cls");
			cout << "W bankomacie jest tylko " << suma_w_banku << " pieniedzy." << endl;
			cout << "Wybierz mniejsza ilosc pieniedzy" << endl;

		}

		else if (pieniadze % 10 != 0) {
			cout << "Bankomat posiada najmniejszy nominal rowny 10 pln " << endl;
			cout << "Wprowadz liczbe z koncowka 0" << endl;
		}

		else {
			poprawne = true;
		}
	}

	int* wybrane_pieniadze = new int[5];
	wartosci(wektor, pieniadze, wybrane_pieniadze);
}


void menu() {
	int* banknoty = new int[5];
	bool pierwszy = true;
	bool koniec = false;

	for (int i = 0; i < 5; i++)
		banknoty[i] = 0;


	while(koniec!= true){

		if (pierwszy == true) {
			pierwszy = false;
			cout << "Witamy w bankomacie!" << endl;
			cout << "Wprowadz ilosc pieniadzy" << endl;
			wypelnij(banknoty);
		}

		else {
			system("cls");
			cout << "Wpisz 1, aby wybraæ pieniadze z bankomatu" << endl;
			cout << "Wpisz 2, aby wplacic pieniadze do bankomatu" << endl;
			cout << "Wpisz 3, aby wyjsc" << endl;
			int wybor;
			cin >> wybor;

			switch (wybor) {
				case 1: wybierz(banknoty);
					break;
				case 2:wypelnij(banknoty);
					break;
				case 3: koniec = true;
					break;
			}
		}
	}
}

int main() {

	menu();
	system("pause");
	return 0;
}