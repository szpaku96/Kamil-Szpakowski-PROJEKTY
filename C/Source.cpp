// Program, który sprawdza, czy ci¹g jest monotoniczny, oraz wykrywa najd³u¿szn¹ rosn¹c¹ sekwencje
// liczy œredni¹ arytmetyczn¹ i odchylenie standardowe


#include <iostream>
#include <string>

using namespace std;

int number_of_elements() {
	int number_of_elements;
	cout << "How many elements do you want?" << endl;
	cin >> number_of_elements;
	return number_of_elements;
}


void fill(int number_of_elements, float* tab) {

	for (int i = 0; i < number_of_elements; i++) {
		int element; 
		cout << "Element number " << i + 1 << endl;
		cin >> element;
		tab[i] = element;
	}

}

void write(int number_of_elements, float* tab) {
	cout << endl;

	for (int i = 0; i < number_of_elements; i++) {
		cout << tab[i] << " ";
	}
	cout << endl;

}

void growing(int number_of_elements, float* tab) {
	
	bool is_growing = true;
	int counter = 1;
	int max_counter = 1;
	int index = 0;
	int best_index = 0;


	for (int i = 1; i < number_of_elements; i++) {

		if (tab[i - 1] >= tab[i]) {	// if previous element isnt equal present

			is_growing = false;

			if (counter > max_counter) {
				max_counter = counter;
				best_index = index;
			}

			index = i;
			counter = 1;
		}

		else 
			counter += 1;
	}

	if (counter > max_counter) {
		max_counter = counter;
		best_index = index;
	}

	cout << "The biggest series of growing elements: " << max_counter << endl;
	cout << "Longes growing sequence is :";
	for (int i = 0; i < max_counter; i++) {
		cout << tab[i + best_index] << " ";
	}
	cout << endl;

	if (is_growing == true)
		cout << "This is growing sequence" << endl;
}

void non_decreasing(int number_of_elements, float* tab) {

	bool is_growing = true;

	for (int i = 1; i < number_of_elements; i++) {
		if (tab[i - 1] > tab[i]) // if previous element is larger than present
			is_growing = false;
	}

	if (is_growing == true)
		cout << "This is non_decreasing sequence" << endl;

}

void constance(int number_of_elements, float* tab) {

	
	bool is_growing = true;

	for (int i = 1; i < number_of_elements; i++) {
		if (tab[i - 1] != tab[i]) // if previous element is larger or equal as present
			is_growing = false;
	}


	if (is_growing == true)
		cout << "This is constance sequence" << endl;

}

void non_growing(int number_of_elements, float* tab) {

	bool is_growing = true;

	for (int i = 1; i < number_of_elements; i++) {
		if (tab[i - 1] < tab[i]) // if previous element is larger than present
			is_growing = false;
	}

	if (is_growing == true)
		cout << "This is non growing sequence" << endl;

}

void decreasing(int number_of_elements, float* tab) {

	bool is_growing = true;

	for (int i = 1; i < number_of_elements; i++) {
		if (tab[i - 1] <= tab[i]) // if previous element is larger than present
			is_growing = false;
	}

	if (is_growing == true)
		cout << "This is decreasing sequence" << endl;

}

float average_value(int number_of_elements, float* tab) {
	float count = 0;

	for (int i = 0; i < number_of_elements; i++)
		count += tab[i];

	float average = count / number_of_elements;
	cout << "Average value is : " << average << endl;

	return average;
}

void standard_deviation(int number_of_elements, float* tab, float average) {
	float variance = 0;
	for (int i = 0; i < number_of_elements; i++)
		variance += pow(tab[i] - average, 2);

		variance /= number_of_elements;
		float standard_deviation = sqrt(variance);
		cout << "value of standard_deviation: " << standard_deviation << endl;
}

void sequence() {
	int number = number_of_elements();
	float* tab = new float[number];
	fill(number,tab);
	write(number,tab);
	growing(number, tab);
	non_decreasing(number, tab);
	constance(number, tab);
	non_growing(number, tab);
	decreasing(number, tab);
	float average = average_value(number, tab);
	standard_deviation(number, tab,average);
}


int main() {

	sequence();

	system("pause");
	return 0;
}