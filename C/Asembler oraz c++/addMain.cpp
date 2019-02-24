// Po³¹czenie dwóch jêzyków programowania w jednym ma³ym projekcie.
// W tym przypadku C++ i asemblera

#include <iostream>

using namespace std;

extern "C" int liczba_godzin(int odleglosc, int srednia_predkosc);
extern "C" int spalone_paliwo(int odleglosc, int spalanie);
extern "C" int cena_calkowita(int cena_poczatkowa, int spalanie, int prowizja);

int main() {

	int odleglosc;
	char samochod;
	char tryb;

	int srednia_predkosc;
	int spalanie;
	int cena_za_odleglosc;
	int cena_poczatkowa;
	int cenaCalkowita;
	int prowizja;
	int cena_za_paliwo;
	int czas = 0;
	int ilosc_paliwa;

	cout << "Wybierz samochod do jazdy: " << endl;
	cout << "a: Skoda Fabia " << endl;
	cout << "b: BMW M5 " << endl;
	cout << "c: Ford Focus" << endl;

	cin >> samochod;
	/*
	nie wiem czy jak bêdê pisaæ komentarze ni¿ej to u¿ywaæ ; czy // xd
	pyta³ siê co to jest LEA -> load effective addres, czyli wskaŸnik na konkretny element tablicy, ale nie wiem jak dok³adnie dzia³a
	procesor 32 bitowy - > stos 32 bitowy - > 4 bajty czyli dla tego w funkcjach asm masz skaczesz co 4
	w eax,[ebp+4] siedzi œlad ( dos³ownie ), i to jest instrukcja dla asemblera, ¿e jak skoñczy wykonywaæ tê funkcje to ¿eby poszed³ dalej
	
	w __asm masz program asemblerowy
	konkretnie tutaj sprawdzasz czy wpisana wartosc samochodu jest równa jednej z poni¿szych
	jezeli samochod = a, to skaczesz do skody jak b to bmw itp
	dla kazdego samochodu dajesz parametry poczatkowe typu predkosc spalanie cena itp
	*/ 

	__asm {             
		cmp samochod, 'a'
		jz skoda
		cmp samochod, 'b'
		jz bmw
		cmp samochod, 'c'
		jz ford
		jmp wyjdz

		skoda :
			mov srednia_predkosc, 60
			mov spalanie, 7
			mov cena_poczatkowa, 100
			mov cena_za_odleglosc, 5
			jmp wyjdz

		bmw :
			mov srednia_predkosc, 100
			mov spalanie, 12
			mov cena_poczatkowa, 500
			mov cena_za_odleglosc, 20
			jmp wyjdz

		ford :
			mov srednia_predkosc, 80
			mov spalanie, 8
			mov cena_poczatkowa, 200
			mov cena_za_odleglosc,10
			jmp wyjdz
		wyjdz :
	}

	cout << "Jaki dystans planujesz pokonac?" << endl;
	cin >> odleglosc;

	cout << "Jaki tryb jazdy bedziesz preferowac?" << endl;
	cout << "a: szybki" << endl;
	cout << "b: normalny" << endl;
	cout << "c: ekonomiczny" << endl;
	cin >> tryb;
	/*
	
	tutaj robisz to samo, co wy¿ej, porównujesz i skaczesz, szybki dodaje predkosc i spalanie, ekonomiczny odejmuje
	
	*/
	__asm {
		cmp tryb, 'a'
		jz szybki
		cmp tryb, 'b'
		jz normalny
		cmp tryb, 'c'
		jz ekonomiczny
		jmp wyjdz2

		szybki :
			add srednia_predkosc, 20
			add spalanie, 2
			jmp wyjdz2

		normalny :
			jmp wyjdz2

		ekonomiczny :
			sub srednia_predkosc, 20
			sub spalanie, 2
			jmp wyjdz2
		wyjdz2 :
	}

	cout << "Cena za wypozyczenie: " << cena_poczatkowa << " zlotych." << endl;
	cout << "Srednie spalanie na 100 km: " << spalanie << " litrow." <<endl;
	cout << "Srednia predkosc : " << srednia_predkosc << " km na godzine." << endl;
	cout << "Prowizja za kazde 100 km " << cena_za_odleglosc << " zlotych. " << endl << endl;

	// czas = odleglosc / predkosc
	// wywo³anie funkcji liczba_godzin która zwraca przez ile czasu jest wypo¿yczony samochód
	czas = liczba_godzin(odleglosc, srednia_predkosc);
	cout << "Ilosc rozpoczetych godzin: " << czas << endl;

	//ilosc paliwa = odleg³oœæ * spalanie / 100
	// poni¿ej jest wstawka z asemblera dla powy¿szego wzoru,
	__asm {
		mov eax, odleglosc
		mov ebx, spalanie
		imul eax, ebx
		mov ebx, 100
		idiv ebx
		mov ilosc_paliwa, eax
	}

	cout << "Spalone paliwo: " << ilosc_paliwa << " litrow."<< endl;

	// prowizja = odleglosc * cena za odleglosc / 100
	// tak samo tutaj masz wstawkê która liczy powy¿szy wzór
	__asm {
		mov eax, odleglosc
		mov ebx, cena_za_odleglosc
		imul eax, ebx
		mov ebx, 100
		idiv ebx
		mov prowizja, eax
	}

	cout << "Prowizja za odleglosc: " << prowizja << " zlotych." << endl;

	
	//cena za paliwo = ilosc_paliwa * 5;
	// mnozy razy 5
	__asm {
		mov eax, ilosc_paliwa
		mov ebx, 5
		imul eax,ebx
		mov cena_za_paliwo, eax
	}

	cout << "Cena za paliwo: " << cena_za_paliwo << " zlotych." << endl;

	// cena calkowita = cena poczatkowa + ilosc paliwa * 5 + cena za 100 km / 100 km 
	// cena calkowita to funkcja w osobnym asm
	cenaCalkowita = cena_calkowita(cena_poczatkowa, ilosc_paliwa, prowizja);
	cout << "Cena calkowita " << cenaCalkowita << " zlotych." << endl;

	system("pause");
	return 0;
}